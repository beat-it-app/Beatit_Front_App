import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlarmItemWidget extends StatefulWidget {
  const AlarmItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AlarmNotification notification;
  final VoidCallback onTap;

  @override
  State<AlarmItemWidget> createState() => _AlarmItemWidgetState();
}

class _AlarmItemWidgetState extends State<AlarmItemWidget> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  String _timeLabel(DateTime createdAt) {
    final elapsed = DateTime.now().difference(createdAt);
    if (elapsed.isNegative || elapsed.inMinutes < 1) return '방금 전';
    if (elapsed.inMinutes < 60) return '${elapsed.inMinutes}분 전';
    if (elapsed.inHours < 24) return '${elapsed.inHours}시간 전';
    if (elapsed.inDays < 7) return '${elapsed.inDays}일 전';
    return '${createdAt.month}. ${createdAt.day}.';
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.notification;
    final highlighted = _hovered || _focused || _pressed;
    final textOpacity = item.isRead ? 0.55 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      color: highlighted ? context.brands.beatOrange6 : context.grays.white,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        onHighlightChanged: (value) => setState(() => _pressed = value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/etc/alarm_check_on.svg',
                width: 22,
                height: 22,
              ),
              const SizedBox(width: AppSpacing.x20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: FontStyles.semi18.copyWith(
                        color: context.grays.black.withValues(alpha: textOpacity),
                        height: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      item.content,
                      style: FontStyles.med16.copyWith(
                        color: context.grays.gray4.withValues(alpha: textOpacity),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(
                _timeLabel(item.createdAt),
                style: FontStyles.med12.copyWith(
                  color: context.grays.gray5,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
