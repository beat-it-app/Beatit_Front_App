import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_api_provider.dart';

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
  int _requestId = 0;

  @override
  ChatListState build() => const ChatListState();

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
}
