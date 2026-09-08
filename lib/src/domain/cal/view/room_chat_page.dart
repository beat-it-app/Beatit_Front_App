import 'package:beatit_front_app/popup_test_page.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_message_input.dart';
import 'package:beatit_front_app/src/domain/cal/model/chat_message_data.dart';
import 'package:beatit_front_app/src/domain/cal/widget/chat_list_item.dart';
import 'package:beatit_front_app/src/domain/cal/widget/chat_message_item.dart';
import 'package:flutter/material.dart';

class RoomChatPage extends StatefulWidget {
  const RoomChatPage({
    super.key,
    required this.roomType,
    required this.roomTitle,
    required this.dateLabel,
    required this.members,
    required this.messages,
    required this.onSendMessage,
  });

  final ChatRoomType roomType;
  final String roomTitle;
  final String dateLabel;

  final List<ChatMemberViewData> members;
  final List<ChatMessageViewData> messages;

  final ValueChanged<String> onSendMessage;

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _messageFocusNode.addListener(_handleFocusChanged);

    if (widget.messages.isNotEmpty) {
      _scrollToBottom(animate: false);
    }
  }

  @override
  void didUpdateWidget(covariant RoomChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final messageWasAdded = widget.messages.length > oldWidget.messages.length;

    if (messageWasAdded) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageFocusNode.removeListener(_handleFocusChanged);

    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _handleFocusChanged() {
    if (_messageFocusNode.hasFocus && widget.messages.isNotEmpty) {
      _scrollToBottom();
    }
  }

  void _handleSendMessage(String message) {
    widget.onSendMessage(message);

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final targetOffset = _scrollController.position.maxScrollExtent;

      if (!animate) {
        _scrollController.jumpTo(targetOffset);
        return;
      }

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppTopAppBar(
        title: widget.roomTitle,
        showBackButton: true,
        trailing: AppTopAppBarTrailing.more,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: widget.messages.isEmpty
                  ? _EmptyRoomContent(
                      roomType: widget.roomType,
                      dateLabel: widget.dateLabel,
                      members: widget.members,
                    )
                  : _ChatMessageList(
                      controller: _scrollController,
                      roomType: widget.roomType,
                      dateLabel: widget.dateLabel,
                      messages: widget.messages,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x8,
                AppSpacing.x8,
                AppSpacing.x16,
                AppSpacing.x12,
              ),
              child: AppMessageInput(
                controller: _messageController,
                focusNode: _messageFocusNode,
                hintText: '대화 시작하기',
                onSend: _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList({
    required this.controller,
    required this.roomType,
    required this.dateLabel,
    required this.messages,
  });

  final ScrollController controller;
  final ChatRoomType roomType;
  final String dateLabel;
  final List<ChatMessageViewData> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        0,
        AppSpacing.x16,
        AppSpacing.x24,
      ),
      itemCount: messages.length + 1,
      separatorBuilder: (_, __) {
        return const SizedBox(height: AppSpacing.x16);
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ChatSectionLabel(text: dateLabel);
        }

        final message = messages[index - 1];

        return Column(
          children: [
            if (message.separatorTextBefore != null) ...[
              _ChatSectionLabel(text: message.separatorTextBefore!),
              const SizedBox(height: AppSpacing.x10),
            ],
            ChatMessageItem(
              key: ValueKey(message.id),
              roomType: roomType,
              message: message,
            ),
          ],
        );
      },
    );
  }
}

class _ChatSectionLabel extends StatelessWidget {
  const _ChatSectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
      child: Center(
        child: Text(
          text,
          style: FontStyles.med12.copyWith(color: colors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _EmptyRoomContent extends StatelessWidget {
  const _EmptyRoomContent({
    required this.roomType,
    required this.dateLabel,
    required this.members,
  });

  final ChatRoomType roomType;
  final String dateLabel;
  final List<ChatMemberViewData> members;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final profileImageUrls = members
        .map((member) => member.profileImageUrl)
        .whereType<String>()
        .where((url) => url.trim().isNotEmpty)
        .toList();

    final memberNames = members
        .map((member) {
          return member.isMe ? '나' : member.name;
        })
        .join(', ');

    final readyText = roomType == ChatRoomType.group
        ? '단체 채팅 준비가 완료되었습니다.'
        : '채팅 준비가 완료되었습니다.';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        0,
        AppSpacing.x16,
        AppSpacing.x24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ChatSectionLabel(text: dateLabel),
          const SizedBox(height: AppSpacing.x70),
          GroupChatProfile(imageUrls: profileImageUrls, size: 160),
          const SizedBox(height: AppSpacing.x20),
          Text(
            memberNames,
            textAlign: TextAlign.center,
            style: FontStyles.med16.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.x30),
          Text(
            readyText,
            textAlign: TextAlign.center,
            style: FontStyles.bold22.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            '채팅을 시작해보세요.',
            textAlign: TextAlign.center,
            style: FontStyles.med16.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
