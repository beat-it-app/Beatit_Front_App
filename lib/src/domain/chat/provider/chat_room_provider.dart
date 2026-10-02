import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_api_provider.dart';

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
  int _requestId = 0;
  final Map<int, _LocalAttachmentMetadata> _localAttachmentMetadata = {};

  @override
  ChatRoomState build() => const ChatRoomState();

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

    try {
      final detail = await ref.read(chatApiProvider).getChatRoomDetails(
        chatId: chatId,
        page: 0,
        size: _pageSize,
      );

      if (requestId != _requestId) return;
      _applyLatestDetail(detail);
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
    if (chatId == null || state.isDraft || state.isSendingMessage) return false;

    state = state.copyWith(isSendingMessage: true, clearErrorMessage: true);

    try {
      final sent = await ref.read(chatApiProvider).sendAttachmentMessage(
        chatId: chatId,
        messageType: messageType,
        filePath: filePath,
        fileName: fileName,
      );
      _localAttachmentMetadata[sent.messageId] = _LocalAttachmentMetadata(
        name: fileName,
        sizeBytes: fileSizeBytes,
      );
      _appendSentMessage(
        sent,
        attachmentName: fileName,
        attachmentSizeBytes: fileSizeBytes,
      );
      state = state.copyWith(isSendingMessage: false);

      await _refreshLatestMessages(
        fallbackMessage: '파일은 전송되었지만 채팅 내용을 다시 불러오지 못했습니다.',
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isSendingMessage: false,
        errorMessage: _errorMessage(error, '파일을 전송하지 못했습니다.'),
      );
      return false;
    }
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

  Future<void> _refreshLatestMessages({required String fallbackMessage}) async {
    final chatId = state.chatId;
    if (chatId == null) return;

    try {
      final detail = await ref.read(chatApiProvider).getChatRoomDetails(
        chatId: chatId,
        page: 0,
        size: _pageSize,
      );
      _applyLatestDetail(detail);
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
