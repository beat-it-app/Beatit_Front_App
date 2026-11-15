import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_socket_api.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_api_provider.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_socket_api_provider.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/etc_api_provider.dart';

final chatListProvider =
    NotifierProvider.autoDispose<ChatListNotifier, ChatListState>(
      ChatListNotifier.new,
    );

class ChatListState {
  const ChatListState({
    this.rooms = const <ChatRoomSummary>[],
    this.localUnnamedRoomNames = const <String, String>{},
    this.inferredUnnamedRoomNames = const <String, String>{},
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ChatRoomSummary> rooms;
  // "사용자ID:채팅방ID" -> 이 기기에서 직접 선택한 다른 멤버들의 표시 이름.
  // 서버에 저장된 채팅방 이름과는 별개입니다.
  final Map<String, String> localUnnamedRoomNames;
  // 채팅 목록의 프로필 사진을 실제 팀 멤버와 일치시켜 찾은 표시 이름.
  final Map<String, String> inferredUnnamedRoomNames;
  final bool isLoading;
  final String? errorMessage;

  ChatListState copyWith({
    List<ChatRoomSummary>? rooms,
    Map<String, String>? localUnnamedRoomNames,
    Map<String, String>? inferredUnnamedRoomNames,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatListState(
      rooms: rooms ?? this.rooms,
      localUnnamedRoomNames:
          localUnnamedRoomNames ?? this.localUnnamedRoomNames,
      inferredUnnamedRoomNames:
          inferredUnnamedRoomNames ?? this.inferredUnnamedRoomNames,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  String displayNameFor(ChatRoomSummary room, int? currentUserId) {
    final savedName = room.roomName.trim();
    if (savedName.isNotEmpty) return savedName;

    final localName = currentUserId == null
        ? null
        : localUnnamedRoomNames['$currentUserId:${room.chatId}'];
    final inferredName = currentUserId == null
        ? null
        : inferredUnnamedRoomNames['$currentUserId:${room.chatId}'];
    return localName ?? inferredName ?? '채팅방';
  }
}

class ChatListNotifier extends Notifier<ChatListState> {
  static const Duration _refreshDebounceDuration = Duration(milliseconds: 120);
  static const Duration _reconnectDelay = Duration(seconds: 2);

  int _requestId = 0;
  final Map<int, ChatSocketConnection> _socketConnections = {};
  final Map<int, StreamSubscription<String>> _socketSubscriptions = {};
  final Map<int, Timer> _socketReconnectTimers = {};
  final Set<int> _socketConnecting = <int>{};
  Timer? _refreshDebounceTimer;
  bool _isDisposed = false;
  String? _memberLookupKey;
  Future<List<TeamMemberSearchResult>>? _memberLookupFuture;
  final Set<String> _locallyCreatedRoomKeys = <String>{};
  final Map<String, Map<int, String>> _observedMembers = {};

  @override
  ChatListState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      unawaited(_disposeRoomSockets());
    });
    return const ChatListState();
  }

  // 생성 직후의 임시 제목만 기억합니다. 방 이름을 수정하는 API는 호출하지 않습니다.
  void rememberCreatedRoomMembers({
    required int chatId,
    required List<String> otherMemberNames,
  }) {
    final currentUserId = ref.read(authProvider).asData?.value?.userId;
    if (currentUserId == null) return;

    final localName = otherMemberNames
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .join(', ');
    if (localName.isEmpty) return;
    _locallyCreatedRoomKeys.add('$currentUserId:$chatId');

    state = state.copyWith(
      localUnnamedRoomNames: Map<String, String>.unmodifiable({
        ...state.localUnnamedRoomNames,
        '$currentUserId:$chatId': localName,
      }),
    );
  }

  // 이미 채팅방을 열어서 받은 메시지의 발신자/읽음 사용자 이름만 재사용합니다.
  // 이름 조회를 위해 메시지 API를 추가 호출하면 읽음 상태가 변경되므로 금지합니다.
  void rememberObservedRoomMembers({
    required int chatId,
    required int participantCount,
    required Iterable<ChatMessage> messages,
    required Iterable<ChatReadMarker> readMarkers,
  }) {
    final userId = ref.read(authProvider).asData?.value?.userId;
    if (userId == null || participantCount <= 1) return;
    final key = '$userId:$chatId';
    if (_locallyCreatedRoomKeys.contains(key) ||
        state.inferredUnnamedRoomNames.containsKey(key) ||
        state.rooms.any((room) =>
            room.chatId == chatId && room.roomName.trim().isNotEmpty)) {
      return;
    }

    final names = _observedMembers.putIfAbsent(key, () => <int, String>{});
    for (final message in messages) {
      if (message.isMine || message.senderId == userId) continue;
      final name = message.senderName.trim();
      if (_isUsableMemberName(name)) names[message.senderId] = name;
    }
    for (final reader in readMarkers) {
      if (reader.userId == userId) continue;
      final name = reader.name.trim();
      if (_isUsableMemberName(name)) names[reader.userId] = name;
    }
    if (names.isEmpty) return;

    final expected = participantCount - 1;
    final knownNames = names.values.take(expected).toList(growable: false);
    final remaining = expected - knownNames.length;
    final displayName = remaining > 0
        ? '${knownNames.join(', ')} 외 $remaining명'
        : knownNames.join(', ');
    if (state.localUnnamedRoomNames[key] == displayName) return;
    state = state.copyWith(
      localUnnamedRoomNames: Map<String, String>.unmodifiable({
        ...state.localUnnamedRoomNames,
        key: displayName,
      }),
    );
  }

  bool _isUsableMemberName(String name) =>
      name.isNotEmpty && name != '알 수 없음' && name != '알 수 없는 사용자';

  Future<void> loadChatRooms({bool force = false}) async {
    if (!force && state.rooms.isNotEmpty && state.errorMessage == null) {
      return;
    }

    final requestId = ++_requestId;
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    try {
      final data = await ref.read(chatApiProvider).getChatRooms();

      if (requestId != _requestId) {
        return;
      }

      final sortedRooms = List<ChatRoomSummary>.of(data.chatroomList)
        ..sort((a, b) {
          final aTime = a.lastMessageTime;
          final bTime = b.lastMessageTime;

          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });

      state = state.copyWith(
        rooms: List<ChatRoomSummary>.unmodifiable(sortedRooms),
        isLoading: false,
        clearErrorMessage: true,
      );

      _syncRoomSockets(sortedRooms);
      // 메시지 상세 조회는 읽음 상태를 변경하므로, 이름 확인에 사용하지 않습니다.
      // 이미 제공되는 채팅방 프로필 이미지와 팀 멤버 정보로만 이름을 찾습니다.
      unawaited(_resolveUnnamedRoomNames(sortedRooms));
    } catch (error) {
      if (requestId != _requestId) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: error is ChatApiException
            ? error.message
            : '채팅방 목록을 불러오지 못했습니다.',
      );
    }
  }

  Future<void> _resolveUnnamedRoomNames(List<ChatRoomSummary> rooms) async {
    final currentUserId = ref.read(authProvider).asData?.value?.userId;
    if (currentUserId == null ||
        !rooms.any((room) => room.roomName.trim().isEmpty)) {
      return;
    }

    // 새 방이 추가되거나 팀이 변경되면 목록 ID가 달라져 멤버 목록을 재조회합니다.
    // WebSocket으로 메시지만 갱신될 때는 멤버 목록을 다시 요청하지 않습니다.
    final roomIds = rooms.map((room) => room.chatId).toList()..sort();
    final lookupKey = '$currentUserId:${roomIds.join(',')}';
    if (_memberLookupKey != lookupKey) {
      _memberLookupKey = lookupKey;
      _memberLookupFuture = _loadTeamMembers();
    }

    try {
      final members = await _memberLookupFuture!;
      if (_isDisposed || _memberLookupKey != lookupKey ||
          ref.read(authProvider).asData?.value?.userId != currentUserId) {
        return;
      }

      // 같은 URL을 여러 회원이 사용한다면 이름을 추정하지 않습니다.
      final membersByImage = <String, List<TeamMemberSearchResult>>{};
      for (final member in members) {
        if (member.userId == currentUserId || member.userName.trim().isEmpty) {
          continue;
        }
        final imageKey = _imageKey(member.profileImageUrl);
        if (imageKey == null) continue;
        membersByImage.putIfAbsent(imageKey, () => []).add(member);
      }

      final inferred = <String, String>{...state.inferredUnnamedRoomNames};
      for (final room in state.rooms) {
        final key = '$currentUserId:${room.chatId}';
        if (room.roomName.trim().isNotEmpty) {
          inferred.remove(key);
          continue;
        }

        final expectedOtherMembers = room.participantCount - 1;
        if (expectedOtherMembers <= 0) continue;
        final names = <String>[];
        final seenUserIds = <int>{};
        for (final image in room.profileImage) {
          final imageKey = _imageKey(image);
          if (imageKey == null) continue;
          final candidates = membersByImage[imageKey];
          if (candidates == null || candidates.length != 1) continue;
          final member = candidates.single;
          if (member.userId != null && !seenUserIds.add(member.userId!)) {
            continue;
          }
          if (member.userId == null && names.contains(member.userName)) {
            continue;
          }
          names.add(member.userName.trim());
        }
        if (names.isEmpty) continue;
        // 일부 멤버는 프로필 이미지가 없을 수 있으므로 전체 명단인 척하지 않습니다.
        final remaining = expectedOtherMembers - names.length;
        inferred[key] = remaining > 0
            ? '${names.join(', ')} 외 $remaining명'
            : names.join(', ');
      }

      if (!mapEquals(state.inferredUnnamedRoomNames, inferred)) {
        state = state.copyWith(
          inferredUnnamedRoomNames: Map<String, String>.unmodifiable(inferred),
        );
      }
    } catch (error) {
      // 다음 목록 새로고침에서 멤버 조회를 다시 시도할 수 있게 합니다.
      if (_memberLookupKey == lookupKey) {
        _memberLookupKey = null;
        _memberLookupFuture = null;
      }
      // 팀 멤버 조회가 실패해도 채팅방 목록을 계속 사용할 수 있어야 합니다.
      debugPrint('[Chat List] 기본 채팅방 이름 조회 실패: $error');
    }
  }

  Future<List<TeamMemberSearchResult>> _loadTeamMembers() async {
    final members = <TeamMemberSearchResult>[];
    var page = 0;
    while (true) {
      final result = await ref.read(memberApiProvider).getMembers(
        page: page,
        size: 100,
      );
      members.addAll(result.members);
      if (!result.hasNext || result.members.isEmpty) break;
      page++;
    }
    return members;
  }

  String? _imageKey(String? imageUrl) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty || uri.path.isEmpty) {
      return url;
    }
    // 서명된 URL의 일시적인 query parameter는 무시합니다.
    return '${uri.scheme.toLowerCase()}://${uri.host.toLowerCase()}${uri.path}';
  }

  void _syncRoomSockets(List<ChatRoomSummary> rooms) {
    if (_isDisposed) return;

    final activeRoomIds = rooms.map((room) => room.chatId).toSet();
    final knownRoomIds = <int>{
      ..._socketConnections.keys,
      ..._socketSubscriptions.keys,
      ..._socketReconnectTimers.keys,
      ..._socketConnecting,
    };

    for (final chatId in knownRoomIds.difference(activeRoomIds)) {
      unawaited(_closeRoomSocket(chatId));
    }

    for (final chatId in activeRoomIds) {
      if (_socketConnections.containsKey(chatId) ||
          _socketConnecting.contains(chatId) ||
          _socketReconnectTimers[chatId]?.isActive == true) {
        continue;
      }
      unawaited(_connectRoomSocket(chatId));
    }
  }

  Future<void> _connectRoomSocket(int chatId) async {
    if (_isDisposed || !_hasRoom(chatId) || _socketConnecting.contains(chatId)) {
      return;
    }

    _socketConnecting.add(chatId);
    debugPrint('[Chat List WS] CONNECT START | chatId=$chatId');

    try {
      final connection = await ref
          .read(chatSocketApiProvider)
          .connect(chatId: chatId);

      if (_isDisposed || !_hasRoom(chatId)) {
        await connection.close();
        return;
      }

      _socketReconnectTimers.remove(chatId)?.cancel();
      _socketConnections[chatId] = connection;
      _socketSubscriptions[chatId] = connection.messages.listen(
        (payload) {
          debugPrint(
            '[Chat List WS] RECEIVE | chatId=$chatId | payload=$payload',
          );
          _scheduleListRefresh();
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint(
            '[Chat List WS] STREAM ERROR | chatId=$chatId | error=$error',
          );
          _handleRoomSocketDisconnected(chatId);
        },
        onDone: () {
          debugPrint('[Chat List WS] STREAM DONE | chatId=$chatId');
          _handleRoomSocketDisconnected(chatId);
        },
        cancelOnError: true,
      );

      debugPrint('[Chat List WS] CONNECTED | chatId=$chatId');
    } catch (error) {
      debugPrint(
        '[Chat List WS] CONNECT FAILED | chatId=$chatId | error=$error',
      );
      _scheduleRoomSocketReconnect(chatId);
    } finally {
      _socketConnecting.remove(chatId);
    }
  }

  void _handleRoomSocketDisconnected(int chatId) {
    final connection = _socketConnections.remove(chatId);
    _socketSubscriptions.remove(chatId);
    if (connection != null) {
      unawaited(connection.close());
    }
    _scheduleRoomSocketReconnect(chatId);
  }

  void _scheduleRoomSocketReconnect(int chatId) {
    if (_isDisposed || !_hasRoom(chatId)) return;
    if (_socketReconnectTimers[chatId]?.isActive == true) return;

    _socketReconnectTimers[chatId] = Timer(_reconnectDelay, () {
      _socketReconnectTimers.remove(chatId);
      if (_isDisposed || !_hasRoom(chatId)) return;
      unawaited(_connectRoomSocket(chatId));
    });
  }

  void _scheduleListRefresh() {
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = Timer(_refreshDebounceDuration, () {
      _refreshDebounceTimer = null;
      if (_isDisposed) return;
      unawaited(loadChatRooms(force: true));
    });
  }

  bool _hasRoom(int chatId) {
    return state.rooms.any((room) => room.chatId == chatId);
  }

  Future<void> _closeRoomSocket(int chatId) async {
    _socketReconnectTimers.remove(chatId)?.cancel();
    _socketConnecting.remove(chatId);

    final subscription = _socketSubscriptions.remove(chatId);
    final connection = _socketConnections.remove(chatId);

    await subscription?.cancel();
    await connection?.close();
  }

  Future<void> _disposeRoomSockets() async {
    _refreshDebounceTimer?.cancel();
    _refreshDebounceTimer = null;

    for (final timer in _socketReconnectTimers.values) {
      timer.cancel();
    }
    _socketReconnectTimers.clear();

    final roomIds = <int>{
      ..._socketConnections.keys,
      ..._socketSubscriptions.keys,
    };
    for (final chatId in roomIds) {
      await _closeRoomSocket(chatId);
    }
  }
}
