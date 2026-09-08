import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cal/widget/group_chat_profile.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    super.key,
    required this.roomName,
    required this.lastMessage,
    required this.timeText,
    required this.unreadCount,
    required this.profileImageUrls,
    this.onTap,
  });

  final String roomName;
  final String lastMessage;
  final String timeText;
  final int unreadCount;
  final List<String> profileImageUrls;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    );

    return Material(
      color: colorScheme.surface,
      shape: cardShape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: cardShape,
        splashColor: context.grays.gray4.withOpacity(0.1),
        highlightColor: context.grays.gray4.withOpacity(0.1),
        hoverColor: context.grays.gray4.withOpacity(0.1),
        focusColor: context.grays.gray4.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x8,
            horizontal: AppSpacing.x8,
          ),
          child: Row(
            children: [
              GroupChatProfile(imageUrls: profileImageUrls, size: 48),
              const SizedBox(width: AppSpacing.x10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.semi16.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.gray3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.x10),

              SizedBox(
                height: 47,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeText,
                      style: FontStyles.reg12.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    if (unreadCount > 0)
                      Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: colorScheme.primary,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: FontStyles.med12.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
