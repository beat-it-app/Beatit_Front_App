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
    this.teamName,
    this.isBusy = false,
  });

  final AlarmNotification notification;
  final VoidCallback? onTap;
  final String? teamName;
  final bool isBusy;

  // 서버의 알림 본문은 그대로 두고, 현재 팀 이름이 붙은 접두어만 화면에서 숨깁니다.
  // 사용자 입력(투표명, 공지 제목, 메시지) 안의 동일한 문자열은 수정하지 않습니다.
  String _withoutTeamPrefix(String value) {
    final name = teamName?.trim();
    if (name == null || name.isEmpty) return value;

    final bracketPrefix = '[$name]';
    if (value.startsWith(bracketPrefix)) {
      return value.substring(bracketPrefix.length).trimLeft();
    }

    // 채팅 알림은 '[팀명 / 채팅방명]'에서 팀명만 제거합니다.
    final chatPrefix = '[$name / ';
    if (value.startsWith(chatPrefix)) {
      return '[${value.substring(chatPrefix.length)}';
    }

    final titlePrefix = '$name ';
    if (value.startsWith(titlePrefix)) {
      return value.substring(titlePrefix.length);
    }
    return value;
  }

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x24,
            vertical: AppSpacing.x20,
          ),
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
                      _withoutTeamPrefix(notification.title),
                      style: FontStyles.semi18.copyWith(
                        color: grayTitleTone,
                        height: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      _withoutTeamPrefix(notification.content),
                      style: FontStyles.med16.copyWith(color: grayContentTone),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              // 읽음 처리 중에도 알림 생성 시각은 그대로 보여줍니다.
              Text(
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
