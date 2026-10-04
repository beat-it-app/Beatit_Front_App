import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_socket_api.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_api_provider.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_socket_api_provider.dart';

final chatRoomProvider =
    NotifierProvider.autoDispose<ChatRoomNotifier, ChatRoomState>(
      ChatRoomNotifier.new,
    );

class ChatRoomState {
  const ChatRoomState({
    this.chatId,
    this.roomName = '',
    this.participantCount = 0,
    this.profileImageUrls = const <String>[],
    this.messages = const <ChatMessage>[],
    this.pendingAttachments = const <ChatPendingAttachment>[],
    this.currentPage = 0,
    this.hasNext = false,
    this.isDraft = false,
    this.isInitialLoading = false,
    this.isLoadingOlderMessages = false,
    this.isCreatingRoom = false,
    this.isSendingMessage = false,
    this.isUpdatingRoomName = false,
    this.isLeavingRoom = false,
    this.errorMessage,
  });

  final int? chatId;
  final String roomName;
  final int participantCount;
  final List<String> profileImageUrls;
  final List<ChatMessage> messages;
  final List<ChatPendingAttachment> pendingAttachments;
  final int currentPage;
  final bool hasNext;
  final bool isDraft;
  final bool isInitialLoading;
  final bool isLoadingOlderMessages;
  final bool isCreatingRoom;
  final bool isSendingMessage;
  final bool isUpdatingRoomName;
  final bool isLeavingRoom;
  final String? errorMessage;

  ChatRoomType get roomType =>
      ChatRoomType.fromParticipantCount(participantCount);

  bool get isBusy =>
      isCreatingRoom ||
      isSendingMessage ||
      isUpdatingRoomName ||
      isLeavingRoom;

  ChatRoomState copyWith({
    int? chatId,
    bool clearChatId = false,
    String? roomName,
    int? participantCount,
    List<String>? profileImageUrls,
    List<ChatMessage>? messages,
    List<ChatPendingAttachment>? pendingAttachments,
    int? currentPage,
    bool? hasNext,
    bool? isDraft,
    bool? isInitialLoading,
    bool? isLoadingOlderMessages,
    bool? isCreatingRoom,
    bool? isSendingMessage,
    bool? isUpdatingRoomName,
    bool? isLeavingRoom,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatRoomState(
      chatId: clearChatId ? null : chatId ?? this.chatId,
      roomName: roomName ?? this.roomName,
      participantCount: participantCount ?? this.participantCount,
      profileImageUrls: profileImageUrls ?? this.profileImageUrls,
      messages: messages ?? this.messages,
      pendingAttachments: pendingAttachments ?? this.pendingAttachments,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      isDraft: isDraft ?? this.isDraft,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingOlderMessages:
          isLoadingOlderMessages ?? this.isLoadingOlderMessages,
      isCreatingRoom: isCreatingRoom ?? this.isCreatingRoom,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isUpdatingRoomName: isUpdatingRoomName ?? this.isUpdatingRoomName,
      isLeavingRoom: isLeavingRoom ?? this.isLeavingRoom,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class ChatRoomNotifier extends Notifier<ChatRoomState> {
  static const int _pageSize = 30;
  static const List<Duration> _reconnectDelays = <Duration>[
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 15),
  ];

  // Backend는 @Transactional 안에서 Kafka publish를 먼저 수행합니다.
  // 따라서 WebSocket 이벤트가 DB commit보다 먼저 도착할 수 있어,
  // 이벤트는 즉시 화면에 추가하고 상세 정보 보강만 commit 이후 재조회합니다.
  static const List<Duration> _socketEnrichmentDelays = <Duration>[
    Duration(milliseconds: 250),
    Duration(milliseconds: 600),
    Duration(milliseconds: 1200),
  ];

  // 현재 Backend의 Kafka consumer group은 모든 인스턴스가 같은 chat-group을 사용합니다.
  // WebSocket 세션이 붙은 인스턴스와 Kafka 메시지를 소비한 인스턴스가 다르면
  // broadcast가 누락될 수 있으므로, 방을 열어 둔 동안 최신 메시지를 안전 동기화합니다.
  // WebSocket 이벤트가 정상 도착하면 즉시 반영되고, 이 동기화는 누락 복구용입니다.
  static const Duration _realtimeSafetySyncInterval = Duration(seconds: 1);

  int _requestId = 0;
  final Map<int, _LocalAttachmentMetadata> _localAttachmentMetadata = {};

  ChatSocketConnection? _socketConnection;
  StreamSubscription<String>? _socketSubscription;
  Timer? _socketReconnectTimer;
  Timer? _realtimeSafetySyncTimer;
  int? _socketChatId;
  int _socketReconnectAttempt = 0;
  bool _isSocketConnecting = false;
  bool _isSocketSyncRunning = false;
  bool _socketSyncPending = false;
  bool _isDisposed = false;

  @override
  ChatRoomState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      unawaited(_disconnectSocket());
    });
    return const ChatRoomState();
  }

  Future<void> loadExistingRoom({
    required int chatId,
    required String initialRoomName,
    required int initialParticipantCount,
    required List<String> initialProfileImageUrls,
  }) async {
    final requestId = ++_requestId;

    state = ChatRoomState(
      chatId: chatId,
      roomName: initialRoomName,
      participantCount: initialParticipantCount,
      profileImageUrls: List<String>.unmodifiable(initialProfileImageUrls),
      isInitialLoading: true,
    );

    unawaited(_connectSocket(chatId));
    _startRealtimeSafetySync(chatId);

    try {
      final detail = await ref.read(chatApiProvider).getChatRoomDetails(
        chatId: chatId,
        page: 0,
        size: _pageSize,
      );

      if (requestId != _requestId) return;
      _applyLatestDetail(detail);
      _markLatestMessageRead(detail.messages);
      unawaited(_queueSocketSync());
    } catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: _errorMessage(error, '채팅 내용을 불러오지 못했습니다.'),
      );
    }
  }

  void initializeDraft({
    required String roomName,
    required int participantCount,
    required List<String> profileImageUrls,
  }) {
    _requestId++;
    unawaited(_disconnectSocket());
    state = ChatRoomState(
      roomName: roomName,
      participantCount: participantCount,
      profileImageUrls: List<String>.unmodifiable(profileImageUrls),
      isDraft: true,
    );
  }

  Future<bool> createRoom({
    required List<int> participantIds,
    required String firstMessageContent,
  }) async {
    if (!state.isDraft || state.isCreatingRoom) return false;

    state = state.copyWith(isCreatingRoom: true, clearErrorMessage: true);

    try {
      final created = await ref.read(chatApiProvider).createChatRoom(
        ChatRoomCreateRequest(
          roomName: state.roomName,
          participantIds: participantIds,
          firstMessageContent: firstMessageContent,
        ),
      );

      state = state.copyWith(
        chatId: created.chatId,
        roomName: created.roomName,
        isDraft: false,
        isCreatingRoom: false,
        clearErrorMessage: true,
      );

      unawaited(_connectSocket(created.chatId));
      _startRealtimeSafetySync(created.chatId);

      await _refreshLatestMessages(
        fallbackMessage: '채팅방은 생성되었지만 메시지를 다시 불러오지 못했습니다.',
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isCreatingRoom: false,
        errorMessage: _errorMessage(error, '채팅방을 생성하지 못했습니다.'),
      );
      return false;
    }
  }

  Future<bool> sendTextMessage(String content) async {
    final chatId = state.chatId;
    if (chatId == null || state.isDraft || state.isSendingMessage) return false;

    state = state.copyWith(isSendingMessage: true, clearErrorMessage: true);

    try {
      final sent = await ref.read(chatApiProvider).sendTextMessage(
        chatId: chatId,
        content: content,
      );
      _appendSentMessage(sent);
      state = state.copyWith(isSendingMessage: false);

      await _refreshLatestMessages(
        fallbackMessage: '메시지는 전송되었지만 채팅 내용을 다시 불러오지 못했습니다.',
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isSendingMessage: false,
        errorMessage: _errorMessage(error, '메시지를 전송하지 못했습니다.'),
      );
      return false;
    }
  }

  Future<bool> sendAttachmentMessage({
    required ChatMessageType messageType,
    required String filePath,
    required String fileName,
    required int fileSizeBytes,
  }) async {
    final chatId = state.chatId;
    if (chatId == null || state.isDraft) return false;

    final pending = ChatPendingAttachment(
      localId: DateTime.now().microsecondsSinceEpoch.toString(),
      filePath: filePath,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      messageType: messageType,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      pendingAttachments: List<ChatPendingAttachment>.unmodifiable([
        ...state.pendingAttachments,
        pending,
      ]),
      clearErrorMessage: true,
    );

    return _uploadPendingAttachment(pending.localId, chatId: chatId);
  }

  Future<bool> retryAttachment(String localId) async {
    final chatId = state.chatId;
    if (chatId == null) return false;

    final pending = _pendingById(localId);
    if (pending == null ||
        pending.status != ChatPendingAttachmentStatus.failed) {
      return false;
    }

    _replacePending(
      pending.copyWith(
        status: ChatPendingAttachmentStatus.uploading,
        progress: 0,
        errorMessage: null,
      ),
    );

    return _uploadPendingAttachment(localId, chatId: chatId);
  }

  void removePendingAttachment(String localId) {
    state = state.copyWith(
      pendingAttachments: List<ChatPendingAttachment>.unmodifiable(
        state.pendingAttachments
            .where((item) => item.localId != localId)
            .toList(growable: false),
      ),
    );
  }

  Future<bool> _uploadPendingAttachment(
    String localId, {
    required int chatId,
  }) async {
    final pending = _pendingById(localId);
    if (pending == null) return false;

    try {
      final sent = await ref.read(chatApiProvider).sendAttachmentMessage(
        chatId: chatId,
        messageType: pending.messageType,
        filePath: pending.filePath,
        fileName: pending.fileName,
        onSendProgress: (sentBytes, totalBytes) {
          if (totalBytes <= 0) return;
          final current = _pendingById(localId);
          if (current == null) return;
          final progress = (sentBytes / totalBytes).clamp(0.0, 1.0).toDouble();
          _replacePending(current.copyWith(progress: progress));
        },
      );

      _localAttachmentMetadata[sent.messageId] = _LocalAttachmentMetadata(
        name: pending.fileName,
        sizeBytes: pending.fileSizeBytes,
      );
      _appendSentMessage(
        sent,
        attachmentName: pending.fileName,
        attachmentSizeBytes: pending.fileSizeBytes,
      );
      removePendingAttachment(localId);

      await _refreshLatestMessages(
        fallbackMessage: '파일은 전송되었지만 채팅 내용을 다시 불러오지 못했습니다.',
      );
      return true;
    } catch (error) {
      final current = _pendingById(localId);
      if (current != null) {
        _replacePending(
          current.copyWith(
            status: ChatPendingAttachmentStatus.failed,
            errorMessage: _errorMessage(error, '파일을 전송하지 못했습니다.'),
          ),
        );
      }
      return false;
    }
  }

  ChatPendingAttachment? _pendingById(String localId) {
    for (final item in state.pendingAttachments) {
      if (item.localId == localId) return item;
    }
    return null;
  }

  void _replacePending(ChatPendingAttachment updated) {
    state = state.copyWith(
      pendingAttachments: List<ChatPendingAttachment>.unmodifiable(
        state.pendingAttachments
            .map((item) => item.localId == updated.localId ? updated : item)
            .toList(growable: false),
      ),
    );
  }

  Future<bool> renameRoom(String roomName) async {
    final chatId = state.chatId;
    final normalizedName = roomName.trim();
    if (chatId == null || state.isDraft || normalizedName.isEmpty) return false;

    state = state.copyWith(isUpdatingRoomName: true, clearErrorMessage: true);

    try {
      final updated = await ref.read(chatApiProvider).updateChatRoomName(
        chatId: chatId,
        roomName: normalizedName,
      );
      state = state.copyWith(
        roomName: updated.roomName,
        isUpdatingRoomName: false,
        clearErrorMessage: true,
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isUpdatingRoomName: false,
        errorMessage: _errorMessage(error, '채팅방 이름을 수정하지 못했습니다.'),
      );
      return false;
    }
  }

  Future<bool> leaveRoom() async {
    final chatId = state.chatId;
    if (chatId == null || state.isDraft || state.isLeavingRoom) return false;

    state = state.copyWith(isLeavingRoom: true, clearErrorMessage: true);

    try {
      await ref.read(chatApiProvider).leaveChatRoom(chatId: chatId);
      await _disconnectSocket();
      state = state.copyWith(isLeavingRoom: false, clearErrorMessage: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLeavingRoom: false,
        errorMessage: _errorMessage(error, '채팅방을 나가지 못했습니다.'),
      );
      return false;
    }
  }

  Future<void> loadOlderMessages() async {
    final chatId = state.chatId;
    if (chatId == null ||
        !state.hasNext ||
        state.isInitialLoading ||
        state.isLoadingOlderMessages) {
      return;
    }

    final nextPage = state.currentPage + 1;
    state = state.copyWith(
      isLoadingOlderMessages: true,
      clearErrorMessage: true,
    );

    try {
      final detail = await ref.read(chatApiProvider).getChatRoomDetails(
        chatId: chatId,
        page: nextPage,
        size: _pageSize,
      );

      final existingIds = state.messages
          .map((message) => message.messageId)
          .toSet();
      final olderMessages = detail.messages
          .where((message) => !existingIds.contains(message.messageId))
          .map(_withLocalAttachmentMetadata)
          .toList(growable: false);

      state = state.copyWith(
        messages: List<ChatMessage>.unmodifiable([
          ...olderMessages,
          ...state.messages,
        ]),
        currentPage: nextPage,
        hasNext: detail.hasNext,
        isLoadingOlderMessages: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingOlderMessages: false,
        errorMessage: _errorMessage(error, '이전 메시지를 불러오지 못했습니다.'),
      );
    }
  }

  Future<void> _connectSocket(int chatId) async {
    debugPrint(
      '[Chat WS] PROVIDER CONNECT REQUEST | chatId=$chatId | '
      'stateChatId=${state.chatId} | draft=${state.isDraft} | '
      'disposed=$_isDisposed | connecting=$_isSocketConnecting | '
      'hasConnection=${_socketConnection != null}',
    );

    if (_isDisposed || state.isDraft || state.chatId != chatId) {
      debugPrint(
        '[Chat WS] PROVIDER CONNECT SKIPPED | chatId=$chatId | '
        'stateChatId=${state.chatId} | draft=${state.isDraft} | '
        'disposed=$_isDisposed',
      );
      return;
    }

    if (_socketChatId == chatId &&
        (_socketConnection != null || _isSocketConnecting)) {
      debugPrint(
        '[Chat WS] PROVIDER CONNECT SKIPPED | chatId=$chatId | '
        'already connected/connecting',
      );
      return;
    }

    await _closeSocketConnection(cancelReconnect: false);
    if (_isDisposed || state.chatId != chatId || state.isDraft) {
      debugPrint(
        '[Chat WS] PROVIDER CONNECT ABORTED AFTER CLOSE | chatId=$chatId',
      );
      return;
    }

    _socketChatId = chatId;
    _isSocketConnecting = true;

    try {
      final socketApi = ref.read(chatSocketApiProvider);
      debugPrint(
        '[Chat WS] PROVIDER OPENING | chatId=$chatId | '
        'uri=${socketApi.socketUriFor(chatId)}',
      );

      final connection = await socketApi.connect(chatId: chatId);

      if (_isDisposed || state.chatId != chatId || state.isDraft) {
        debugPrint(
          '[Chat WS] PROVIDER CONNECTED BUT ROOM CHANGED | chatId=$chatId',
        );
        await connection.close();
        return;
      }

      _socketConnection = connection;
      _isSocketConnecting = false;
      _socketReconnectAttempt = 0;
      _socketReconnectTimer?.cancel();
      _socketReconnectTimer = null;

      debugPrint(
        '[Chat WS] PROVIDER LISTENING | chatId=$chatId | '
        'uri=${connection.uri} | readyState=${connection.readyState}',
      );

      _socketSubscription = connection.messages.listen(
        (payload) {
          debugPrint(
            '[Chat WS] RECEIVE | chatId=$chatId | payload=$payload',
          );
          _handleSocketMessage(chatId, payload);
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint(
            '[Chat WS] STREAM ERROR | chatId=$chatId | error=$error',
          );
          debugPrintStack(stackTrace: stackTrace);
          _handleSocketDisconnected(chatId, reason: 'stream error');
        },
        onDone: () {
          debugPrint('[Chat WS] STREAM DONE | chatId=$chatId');
          _handleSocketDisconnected(chatId, reason: 'stream done');
        },
        cancelOnError: false,
      );

      // 연결 직전 들어온 메시지가 있다면 한 번 보강합니다.
      unawaited(_queueSocketSync());
    } catch (error, stackTrace) {
      _isSocketConnecting = false;
      debugPrint(
        '[Chat WS] PROVIDER CONNECT FAILED | chatId=$chatId | error=$error',
      );
      debugPrintStack(stackTrace: stackTrace);
      _scheduleSocketReconnect(chatId);
    }
  }

  void _handleSocketMessage(int chatId, String payload) {
    if (_isDisposed || state.chatId != chatId) {
      debugPrint(
        '[Chat WS] RECEIVE IGNORED | chatId=$chatId | '
        'stateChatId=${state.chatId} | disposed=$_isDisposed',
      );
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) {
        debugPrint(
          '[Chat WS] PAYLOAD IGNORED | chatId=$chatId | not a JSON object',
        );
        return;
      }

      final eventJson = Map<String, dynamic>.from(decoded);
      eventJson['createdAt'] = _normalizeSocketCreatedAt(
        eventJson['createdAt'],
      );

      final event = ChatMessageSendData.fromJson(eventJson);

      if (event.chatId != chatId) {
        debugPrint(
          '[Chat WS] PAYLOAD IGNORED | expectedChatId=$chatId | '
          'eventChatId=${event.chatId}',
        );
        return;
      }

      final alreadyLoaded = state.messages.any(
        (message) => message.messageId == event.messageId,
      );
      if (alreadyLoaded) {
        debugPrint(
          '[Chat WS] DUPLICATE IGNORED | chatId=$chatId | '
          'messageId=${event.messageId}',
        );
        return;
      }

      debugPrint(
        '[Chat WS] MESSAGE APPLY | chatId=$chatId | '
        'messageId=${event.messageId} | senderId=${event.senderId} | '
        'type=${event.messageType}',
      );

      _appendSocketMessageImmediately(event);
      _markRealtimeMessageRead(event);
      unawaited(_enrichSocketMessageAfterCommit(event.messageId));
    } catch (error, stackTrace) {
      debugPrint(
        '[Chat WS] PAYLOAD PARSE FAILED | chatId=$chatId | '
        'payload=$payload | error=$error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Object? _normalizeSocketCreatedAt(Object? rawValue) {
    if (rawValue is num) {
      final microseconds =
          (rawValue.toDouble() * Duration.microsecondsPerSecond).round();
      return DateTime.fromMicrosecondsSinceEpoch(
        microseconds,
        isUtc: true,
      ).toIso8601String();
    }

    return rawValue;
  }

  void _appendSocketMessageImmediately(ChatMessageSendData event) {
    final currentUserId = ref.read(authProvider).asData?.value?.userId;
    final isMine = currentUserId != null && event.senderId == currentUserId;

    ChatMessage? knownSenderMessage;
    for (final message in state.messages.reversed) {
      if (message.senderId == event.senderId) {
        knownSenderMessage = message;
        break;
      }
    }

    final realtimeMessage = ChatMessage(
      messageId: event.messageId,
      senderId: event.senderId,
      senderName: isMine
          ? '나'
          : knownSenderMessage?.senderName ?? '멤버',
      profileImageUrl: knownSenderMessage?.profileImageUrl,
      content: event.content,
      messageType: event.messageType,
      createdAt: event.createdAt,
      isMine: isMine,
    );

    final messages = <ChatMessage>[...state.messages, realtimeMessage]
      ..sort((a, b) => a.messageId.compareTo(b.messageId));

    state = state.copyWith(
      messages: List<ChatMessage>.unmodifiable(messages),
      clearErrorMessage: true,
    );
  }

  Future<void> _enrichSocketMessageAfterCommit(int messageId) async {
    for (final delay in _socketEnrichmentDelays) {
      if (_isDisposed || state.chatId == null || state.isDraft) return;

      await Future<void>.delayed(delay);
      if (_isDisposed) return;

      final synced = await _syncLatestMessagesFromSocket(
        expectedMessageId: messageId,
      );
      if (synced) return;
    }
  }

  void _handleSocketDisconnected(
    int chatId, {
    required String reason,
  }) {
    if (_socketChatId != chatId) return;

    debugPrint(
      '[Chat WS] DISCONNECTED | chatId=$chatId | reason=$reason',
    );

    _socketConnection = null;
    _socketSubscription = null;
    _isSocketConnecting = false;
    _scheduleSocketReconnect(chatId);
  }

  void _scheduleSocketReconnect(int chatId) {
    if (_isDisposed ||
        state.isDraft ||
        state.chatId != chatId ||
        _socketChatId != chatId ||
        _socketReconnectTimer?.isActive == true) {
      return;
    }

    final delayIndex = _socketReconnectAttempt
        .clamp(0, _reconnectDelays.length - 1)
        .toInt();
    final delay = _reconnectDelays[delayIndex];
    _socketReconnectAttempt++;

    debugPrint(
      '[Chat WS] RECONNECT SCHEDULED | chatId=$chatId | '
      'delay=${delay.inSeconds}s | attempt=$_socketReconnectAttempt',
    );

    _socketReconnectTimer = Timer(delay, () {
      _socketReconnectTimer = null;
      if (_isDisposed || state.chatId != chatId || state.isDraft) return;
      unawaited(_connectSocket(chatId));
    });
  }

  Future<void> _queueSocketSync() async {
    if (_isDisposed || state.chatId == null || state.isDraft) return;

    if (_isSocketSyncRunning) {
      _socketSyncPending = true;
      return;
    }

    _isSocketSyncRunning = true;
    try {
      do {
        _socketSyncPending = false;
        await _syncLatestMessagesFromSocket();
      } while (_socketSyncPending && !_isDisposed);
    } finally {
      _isSocketSyncRunning = false;
    }
  }

  Future<bool> _syncLatestMessagesFromSocket({int? expectedMessageId}) async {
    final chatId = state.chatId;
    if (chatId == null || state.isDraft) return false;

    try {
      final detail = await ref.read(chatApiProvider).getChatRoomDetails(
        chatId: chatId,
        page: 0,
        size: _pageSize,
      );
      if (_isDisposed || state.chatId != chatId) return false;

      _mergeLatestDetail(detail);
      _markLatestMessageRead(detail.messages);

      if (expectedMessageId == null) return true;
      return detail.messages.any(
        (message) => message.messageId == expectedMessageId,
      );
    } catch (_) {
      // 실시간 동기화 실패는 기존 화면을 깨뜨리지 않습니다.
      // 재연결 또는 다음 보강 시도에서 다시 동기화합니다.
      return false;
    }
  }

  void _markLatestMessageRead(List<ChatMessage> messages) {
    if (messages.isEmpty) return;
    _markMessageRead(messages.last.messageId);
  }

  void _markRealtimeMessageRead(ChatMessageSendData event) {
    final currentUserId = ref.read(authProvider).asData?.value?.userId;
    if (currentUserId != null && event.senderId == currentUserId) return;
    _markMessageRead(event.messageId);
  }

  void _markMessageRead(int messageId) {
    final chatId = state.chatId;
    if (chatId == null || state.isDraft) return;

    unawaited(
      ref
          .read(chatApiProvider)
          .markChatRoomRead(chatId: chatId, messageId: messageId)
          .catchError((Object error) {
            debugPrint(
              '[Chat Read] FAILED | chatId=$chatId | '
              'messageId=$messageId | error=$error',
            );
          }),
    );
  }

  void _startRealtimeSafetySync(int chatId) {
    _realtimeSafetySyncTimer?.cancel();
    _realtimeSafetySyncTimer = Timer.periodic(
      _realtimeSafetySyncInterval,
      (_) {
        if (_isDisposed || state.isDraft || state.chatId != chatId) {
          _realtimeSafetySyncTimer?.cancel();
          _realtimeSafetySyncTimer = null;
          return;
        }

        unawaited(_queueSocketSync());
      },
    );
  }

  Future<void> _disconnectSocket() async {
    debugPrint(
      '[Chat WS] DISCONNECT REQUEST | chatId=$_socketChatId | '
      'stateChatId=${state.chatId}',
    );
    _realtimeSafetySyncTimer?.cancel();
    _realtimeSafetySyncTimer = null;
    _socketChatId = null;
    _socketReconnectAttempt = 0;
    await _closeSocketConnection(cancelReconnect: true);
  }

  Future<void> _closeSocketConnection({required bool cancelReconnect}) async {
    if (cancelReconnect) {
      _socketReconnectTimer?.cancel();
      _socketReconnectTimer = null;
    }

    final subscription = _socketSubscription;
    final connection = _socketConnection;
    _socketSubscription = null;
    _socketConnection = null;
    _isSocketConnecting = false;

    await subscription?.cancel();
    await connection?.close();
  }

  Future<void> _refreshLatestMessages({required String fallbackMessage}) async {
    final chatId = state.chatId;
    if (chatId == null) return;

    try {
      final detail = await ref.read(chatApiProvider).getChatRoomDetails(
        chatId: chatId,
        page: 0,
        size: _pageSize,
      );
      _mergeLatestDetail(detail);
      _markLatestMessageRead(detail.messages);
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: _errorMessage(error, fallbackMessage),
      );
    }
  }

  void _appendSentMessage(
    ChatMessageSendData sent, {
    String? attachmentName,
    int? attachmentSizeBytes,
  }) {
    final exists = state.messages.any(
      (message) => message.messageId == sent.messageId,
    );
    if (exists) return;

    state = state.copyWith(
      messages: List<ChatMessage>.unmodifiable([
        ...state.messages,
        ChatMessage(
          messageId: sent.messageId,
          senderId: sent.senderId,
          senderName: '나',
          content: sent.content,
          messageType: sent.messageType,
          createdAt: sent.createdAt,
          isMine: true,
          attachmentName: attachmentName,
          attachmentSizeBytes: attachmentSizeBytes,
        ),
      ]),
    );
  }

  ChatMessage _withLocalAttachmentMetadata(ChatMessage message) {
    final metadata = _localAttachmentMetadata[message.messageId];
    if (metadata == null) return message;

    return message.copyWith(
      attachmentName: metadata.name,
      attachmentSizeBytes: metadata.sizeBytes,
    );
  }

  void _mergeLatestDetail(ChatRoomDetailData detail) {
    final mergedById = <int, ChatMessage>{
      for (final message in state.messages) message.messageId: message,
    };

    for (final message in detail.messages) {
      mergedById[message.messageId] = _withLocalAttachmentMetadata(message);
    }

    final mergedMessages = mergedById.values.toList(growable: false)
      ..sort((a, b) => a.messageId.compareTo(b.messageId));

    state = state.copyWith(
      roomName: detail.chatroomName,
      participantCount: detail.participantCount,
      messages: List<ChatMessage>.unmodifiable(mergedMessages),
      hasNext: state.currentPage == 0 ? detail.hasNext : state.hasNext,
      isInitialLoading: false,
      clearErrorMessage: true,
    );
  }

  void _applyLatestDetail(ChatRoomDetailData detail) {
    final messages = detail.messages
        .map(_withLocalAttachmentMetadata)
        .toList(growable: false);

    state = state.copyWith(
      roomName: detail.chatroomName,
      participantCount: detail.participantCount,
      messages: List<ChatMessage>.unmodifiable(messages),
      currentPage: 0,
      hasNext: detail.hasNext,
      isInitialLoading: false,
      isLoadingOlderMessages: false,
      clearErrorMessage: true,
    );
  }

  String _errorMessage(Object error, String fallbackMessage) {
    return error is ChatApiException ? error.message : fallbackMessage;
  }
}

class _LocalAttachmentMetadata {
  const _LocalAttachmentMetadata({required this.name, required this.sizeBytes});

  final String name;
  final int sizeBytes;
}
