import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_list_provider.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_member_selection_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_room_page.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_list_item.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';

class ListChatPage extends ConsumerStatefulWidget {
  const ListChatPage({super.key});

  @override
  ConsumerState<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends ConsumerState<ListChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatListProvider.notifier).loadChatRooms();
    });
  }

  Future<void> _openChatRoom(ChatRoomSummary room) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RoomChatPage(
          chatId: room.chatId,
          initialRoomName: room.roomName,
          initialParticipantCount: room.participantCount,
          initialProfileImageUrls: room.profileImage,
        ),
      ),
    );

    if (mounted) {
      await ref.read(chatListProvider.notifier).loadChatRooms(force: true);
    }
  }

  Future<void> _startChatRoomCreation() async {
    final selectedMembers = await Navigator.of(context)
        .push<List<TeamMemberSearchResult>>(
          MaterialPageRoute<List<TeamMemberSearchResult>>(
            builder: (_) => const ChatMemberSelectionPage(),
          ),
        );

    if (!mounted || selectedMembers == null || selectedMembers.isEmpty) {
      return;
    }

    final roomName = selectedMembers
        .map((member) => member.userName.trim())
        .where((name) => name.isNotEmpty)
        .join(', ');
    final profileImageUrls = selectedMembers
        .map((member) => member.profileImageUrl)
        .whereType<String>()
        .where((url) => url.trim().isNotEmpty)
        .toList(growable: false);

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RoomChatPage(
          initialRoomName: roomName,
          initialParticipantCount: selectedMembers.length + 1,
          initialProfileImageUrls: profileImageUrls,
          draftMembers: selectedMembers,
        ),
      ),
    );

    if (mounted) {
      await ref.read(chatListProvider.notifier).loadChatRooms(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatListProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppTwoAppBar(
        title: '',
        showBackButton: false,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(0, 68),
        addMenuItems: [
          AppDropdownItem(label: '채팅방 생성', onPressed: _startChatRoomCreation),
        ],
      ),
      body: SafeArea(
        child: _ChatListBody(
          state: state,
          onRetry: () =>
              ref.read(chatListProvider.notifier).loadChatRooms(force: true),
          onTapRoom: _openChatRoom,
        ),
      ),
    );
  }
}

class _ChatListBody extends StatelessWidget {
  const _ChatListBody({
    required this.state,
    required this.onRetry,
    required this.onTapRoom,
  });

  final ChatListState state;
  final VoidCallback onRetry;
  final ValueChanged<ChatRoomSummary> onTapRoom;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.rooms.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.rooms.isEmpty) {
      return _ChatListError(message: state.errorMessage!, onRetry: onRetry);
    }

    if (state.rooms.isEmpty) {
      return const _EmptyChatList();
    }

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x8,
          AppSpacing.x20,
          AppSpacing.x16,
          AppSpacing.x24,
        ),
        itemCount: state.rooms.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.x12),
        itemBuilder: (context, index) {
          final room = state.rooms[index];

          return ChatListItem(
            roomName: room.roomName,
            lastMessage: room.lastMessage ?? '채팅을 시작해보세요.',
            timeText: _formatListTime(room.lastMessageTime),
            unreadCount: room.unreadCount,
            profileImageUrls: room.profileImage,
            onTap: () => onTapRoom(room),
          );
        },
      ),
    );
  }

  String _formatListTime(DateTime? value) {
    if (value == null) {
      return '';
    }

    final dateTime = value.toLocal();
    final now = DateTime.now();

    if (_isSameDate(now, dateTime)) {
      final period = dateTime.hour < 12 ? '오전' : '오후';
      final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$period $hour12:$minute';
    }

    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _ChatListError extends StatelessWidget {
  const _ChatListError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.grays.gray5),
            ),
            const SizedBox(height: AppSpacing.x12),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatList extends StatelessWidget {
  const _EmptyChatList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '채팅 목록이 없습니다.',
              textAlign: TextAlign.center,
              style: FontStyles.bold22.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x10),
            Text(
              '+ 버튼을 눌러 채팅을 시작해보세요.',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(color: context.grays.gray5),
            ),
          ],
        ),
      ),
    );
  }
}
