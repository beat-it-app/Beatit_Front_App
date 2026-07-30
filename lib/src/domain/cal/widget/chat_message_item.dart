import 'package:beatit_front_app/popup_test_page.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cal/model/chat_message_data.dart';
import 'package:beatit_front_app/src/domain/cal/widget/chat_list_item.dart';
import 'package:flutter/material.dart';

/// 메시지의 소유자를 판단해 상대방 메시지와 내 메시지를 구분합니다.
class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem({
    super.key,
    required this.roomType,
    required this.message,
  });

  final ChatRoomType roomType;
  final ChatMessageViewData message;

  @override
  Widget build(BuildContext context) {
    if (message.isMine) {
      return SentChatMessage(roomType: roomType, message: message);
    }

    return ReceivedChatMessage(message: message);
  }
}

/// 기존 _ChatMessageOne 디자인을 그대로 사용하는 상대방 메시지입니다.
class ReceivedChatMessage extends StatelessWidget {
  const ReceivedChatMessage({super.key, required this.message});

  final ChatMessageViewData message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.x10,
        horizontal: AppSpacing.x4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChatProfileImage(imageUrl: message.senderProfileImageUrl, size: 36),
          const SizedBox(width: AppSpacing.x8),

          // 기존 디자인은 유지하면서 긴 메시지의 overflow만 방지합니다.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: FontStyles.med12.copyWith(color: context.grays.black),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 234),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x8,
                          horizontal: AppSpacing.x12,
                        ),
                        decoration: BoxDecoration(
                          color: context.grays.gray8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppRadius.xxl),
                            topRight: Radius.circular(AppRadius.xxl),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(AppRadius.xxl),
                          ),
                        ),
                        child: Text(
                          message.content,
                          style: FontStyles.med16.copyWith(
                            color: context.grays.black,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x8),
                    Text(
                      message.timeText,
                      style: FontStyles.med11.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
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

/// 기존 _ChatMessageTwo 디자인을 그대로 사용하는 내 메시지입니다.
class SentChatMessage extends StatelessWidget {
  const SentChatMessage({
    super.key,
    required this.roomType,
    required this.message,
  });

  final ChatRoomType roomType;
  final ChatMessageViewData message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.timeText,
                style: FontStyles.med11.copyWith(color: context.grays.gray5),
              ),
              const SizedBox(width: AppSpacing.x8),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 254),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.x8,
                    horizontal: AppSpacing.x12,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.xxl),
                      topRight: Radius.circular(AppRadius.xxl),
                      bottomLeft: Radius.circular(AppRadius.xxl),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: FontStyles.med16.copyWith(
                      color: context.grays.white,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 개인방과 단체방의 읽음 표시를 분리합니다.
          _ChatReadReceipt(roomType: roomType, readers: message.readBy),
        ],
      ),
    );
  }
}

/// 개인 채팅방과 단체 채팅방의 읽음 표시를 구분합니다.
///
/// 개인방:
/// - 상대방이 읽었을 때 '읽음' 표시
///
/// 단체방:
/// - 읽은 참여자 프로필 표시
class _ChatReadReceipt extends StatelessWidget {
  const _ChatReadReceipt({required this.roomType, required this.readers});

  final ChatRoomType roomType;
  final List<ChatMemberViewData> readers;

  @override
  Widget build(BuildContext context) {
    final validReaders = readers
        .where((reader) => !reader.isMe)
        .toList(growable: false);

    if (validReaders.isEmpty) {
      return const SizedBox.shrink();
    }

    if (roomType == ChatRoomType.direct) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.x4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            '읽음',
            key: const ValueKey('direct-chat-read'),
            style: FontStyles.med11.copyWith(color: context.grays.gray5),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x4),
      child: _AnimatedReaderProfiles(readers: validReaders),
    );
  }
}

/// 단체방에서 읽은 사람이 늘어날 때 프로필 목록의 너비가
/// 오른쪽을 기준으로 왼쪽 방향으로 자연스럽게 확장됩니다.
class _AnimatedReaderProfiles extends StatelessWidget {
  const _AnimatedReaderProfiles({required this.readers});

  final List<ChatMemberViewData> readers;

  @override
  Widget build(BuildContext context) {
    // addReader()는 뒤에 새 사용자를 추가합니다.
    //
    // 화면에서는 reverse하여 새로 읽은 사람이 왼쪽에 표시되고,
    // 기존 첫 번째 프로필은 오른쪽 위치를 유지하도록 합니다.
    final reversedReaders = readers.reversed.toList(growable: false);

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var index = 0; index < reversedReaders.length; index++) ...[
            if (index > 0) const SizedBox(width: 3),
            _AnimatedReaderProfile(
              key: ValueKey(reversedReaders[index].id),
              reader: reversedReaders[index],
            ),
          ],
        ],
      ),
    );
  }
}

/// 새롭게 읽은 사용자의 프로필이 작은 원에서 커지며 등장합니다.
class _AnimatedReaderProfile extends StatelessWidget {
  const _AnimatedReaderProfile({super.key, required this.reader});

  final ChatMemberViewData reader;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0.5, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0).toDouble(),
          child: Transform.scale(
            scale: value,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: _ChatProfileImage(imageUrl: reader.profileImageUrl, size: 20),
    );
  }
}

/// 프로필 이미지가 있을 때는 기존 GroupChatProfile을 사용하고,
/// 이미지가 없을 때만 기본 프로필을 표시합니다.
class _ChatProfileImage extends StatelessWidget {
  const _ChatProfileImage({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (hasImage) {
      return GroupChatProfile(imageUrls: [imageUrl!], size: size);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.grays.gray8,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: size * 0.6,
        color: context.grays.gray5,
      ),
    );
  }
}
