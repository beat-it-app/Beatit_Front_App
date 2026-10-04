import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_attachment_message_card.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_image_message.dart';
import 'package:beatit_front_app/src/domain/chat/widget/chat_link_message_preview.dart';
import 'package:beatit_front_app/src/domain/chat/widget/group_chat_profile.dart';

class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem({
    super.key,
    required this.message,
    this.onImagePressed,
    this.onAttachmentPressed,
    this.showProfile = true,
    this.showSenderName = true,
    this.showTime = true,
  });

  final ChatMessage message;
  final VoidCallback? onImagePressed;
  final VoidCallback? onAttachmentPressed;
  final bool showProfile;
  final bool showSenderName;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == ChatMessageType.system) {
      return _SystemMessage(message: message);
    }

    if (message.isMine) {
      return _SentMessage(
        message: message,
        onImagePressed: onImagePressed,
        onAttachmentPressed: onAttachmentPressed,
        showTime: showTime,
      );
    }

    return _ReceivedMessage(
      message: message,
      onImagePressed: onImagePressed,
      onAttachmentPressed: onAttachmentPressed,
      showProfile: showProfile,
      showSenderName: showSenderName,
      showTime: showTime,
    );
  }
}

class _ReceivedMessage extends StatelessWidget {
  const _ReceivedMessage({
    required this.message,
    required this.onImagePressed,
    required this.onAttachmentPressed,
    required this.showProfile,
    required this.showSenderName,
    required this.showTime,
  });

  final ChatMessage message;
  final VoidCallback? onImagePressed;
  final VoidCallback? onAttachmentPressed;
  final bool showProfile;
  final bool showSenderName;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showProfile)
            _ChatProfileImage(imageUrl: message.profileImageUrl, size: 36)
          else
            const SizedBox(width: 36),
          const SizedBox(width: AppSpacing.x8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSenderName) ...[
                  Text(
                    message.senderName,
                    style: FontStyles.med12.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: _MessageContent(
                        message: message,
                        isMine: false,
                        onImagePressed: onImagePressed,
                        onAttachmentPressed: onAttachmentPressed,
                      ),
                    ),
                    if (showTime) ...[
                      const SizedBox(width: AppSpacing.x8),
                      _MessageTime(createdAt: message.createdAt),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SentMessage extends StatelessWidget {
  const _SentMessage({
    required this.message,
    required this.onImagePressed,
    required this.onAttachmentPressed,
    required this.showTime,
  });

  final ChatMessage message;
  final VoidCallback? onImagePressed;
  final VoidCallback? onAttachmentPressed;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showTime) ...[
            _MessageTime(createdAt: message.createdAt),
            const SizedBox(width: AppSpacing.x8),
          ],
          Flexible(
            child: _MessageContent(
              message: message,
              isMine: true,
              onImagePressed: onImagePressed,
              onAttachmentPressed: onAttachmentPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.message,
    required this.isMine,
    required this.onImagePressed,
    required this.onAttachmentPressed,
  });

  final ChatMessage message;
  final bool isMine;
  final VoidCallback? onImagePressed;
  final VoidCallback? onAttachmentPressed;

  @override
  Widget build(BuildContext context) {
    switch (message.messageType) {
      case ChatMessageType.image:
        return ChatImageMessage(
          imageUrl: message.content,
          onTap: onImagePressed,
        );
      case ChatMessageType.file:
      case ChatMessageType.video:
        return ChatAttachmentMessageCard(
          message: message,
          onTap: onAttachmentPressed,
        );
      case ChatMessageType.text:
      case ChatMessageType.unknown:
        final uri = _wholeMessageUri(message.content);
        if (uri == null) {
          return _MessageBubble(content: message.content, isMine: isMine);
        }
        return Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _MessageBubble(content: message.content, isMine: isMine),
            const SizedBox(height: AppSpacing.x8),
            ChatLinkMessagePreview(uri: uri),
          ],
        );
      case ChatMessageType.system:
        return const SizedBox.shrink();
    }
  }

  Uri? _wholeMessageUri(String content) {
    final uri = Uri.tryParse(content.trim());
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return null;
    }
    return uri;
  }
}

class _SystemMessage extends StatelessWidget {
  const _SystemMessage({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
        child: Text(
          message.content,
          textAlign: TextAlign.center,
          style: FontStyles.med12.copyWith(color: context.grays.gray5),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.content, required this.isMine});

  final String content;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.x8,
        horizontal: AppSpacing.x12,
      ),
      decoration: BoxDecoration(
        color: isMine ? context.colors.primary : context.grays.gray8,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.xxl),
          topRight: const Radius.circular(AppRadius.xxl),
          bottomLeft: Radius.circular(isMine ? AppRadius.xxl : 0),
          bottomRight: Radius.circular(isMine ? 0 : AppRadius.xxl),
        ),
      ),
      child: Text(
        content,
        style: FontStyles.med16.copyWith(
          color: isMine ? context.grays.white : context.grays.black,
          height: 1.35,
        ),
      ),
    );
  }
}

class _MessageTime extends StatelessWidget {
  const _MessageTime({required this.createdAt});

  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final local = createdAt.toLocal();
    return Text(
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}',
      style: FontStyles.med11.copyWith(color: context.grays.gray5),
    );
  }
}

class _ChatProfileImage extends StatelessWidget {
  const _ChatProfileImage({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    return GroupChatProfile(
      imageUrls: hasImage ? <String>[imageUrl!] : const <String>[],
      size: size,
    );
  }
}
