import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlarmItemWidget extends StatelessWidget {
  const AlarmItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
    this.isBusy = false,
  });

  final AlarmNotification notification;
  final VoidCallback? onTap;
  final bool isBusy;

  String _elapsedTime(DateTime createdAt) {
    final elapsed = DateTime.now().difference(createdAt);
    if (elapsed.isNegative || elapsed.inMinutes == 0) return '방금 전';
    if (elapsed.inMinutes < 60) return '${elapsed.inMinutes}분 전';
    if (elapsed.inHours < 24) return '${elapsed.inHours}시간 전';
    if (elapsed.inDays < 7) return '${elapsed.inDays}일 전';
    final local = createdAt.toLocal();
    return '${local.month}. ${local.day}.';
  }

  @override
  Widget build(BuildContext context) {
    final gray = context.grays;
    final opacity = notification.isRead ? 0.55 : 1.0;
    final grayTitleTone = notification.isRead ? gray.gray4 : gray.black;
    final grayContentTone = notification.isRead ? gray.gray5 : gray.gray4;
    final String notificationSvg = notification.isRead
        ? 'assets/icons/etc/alarm_check_off.svg'
        : 'assets/icons/etc/alarm_check_on.svg';
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: isBusy ? null : onTap,
        hoverColor: context.brands.beatOrange6,
        focusColor: context.brands.beatOrange6,
        highlightColor: context.brands.beatOrange6,
        splashColor: context.brands.beatOrange6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(notificationSvg, width: 22, height: 22),
              const SizedBox(width: AppSpacing.x20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      notification.title,
                      style: FontStyles.semi18.copyWith(
                        color: grayTitleTone,
                        height: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      notification.content,
                      style: FontStyles.med16.copyWith(color: grayContentTone),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              isBusy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _elapsedTime(notification.createdAt),
                      style: FontStyles.med12.copyWith(
                        color: gray.gray5,
                        height: 1,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
