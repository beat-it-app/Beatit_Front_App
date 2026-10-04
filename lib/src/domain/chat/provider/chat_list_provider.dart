import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_socket_api.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_api_provider.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_socket_api_provider.dart';

final chatListProvider =
    NotifierProvider.autoDispose<ChatListNotifier, ChatListState>(
      ChatListNotifier.new,
    );

class ChatListState {
  const ChatListState({
    this.rooms = const <ChatRoomSummary>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ChatRoomSummary> rooms;
  final bool isLoading;
  final String? errorMessage;

  ChatListState copyWith({
    List<ChatRoomSummary>? rooms,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatListState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
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

  @override
  ChatListState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      unawaited(_disposeRoomSockets());
    });
    return const ChatListState();
  }

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
