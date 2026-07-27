import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_fonts.dart';

enum ScheduleType { none, mine }

class ScheduleListItem extends StatefulWidget {
  const ScheduleListItem({
    super.key,
    required this.titleText,
    required this.locationText,
    required this.timeText,
    required this.onTap,
    this.scheduleType = ScheduleType.none,
    this.isSelected = false,
  });

  final String titleText;
  final String locationText;
  final String timeText;
  final ScheduleType scheduleType;
  final VoidCallback onTap;

  final bool isSelected;

  @override
  State<ScheduleListItem> createState() => _ScheduleListItemState();
}

class _ScheduleListItemState extends State<ScheduleListItem> {
  bool _isPressed = false;
  bool _isFocused = false;
  bool _isHovered = false;

  bool get _isActive {
    return widget.isSelected || _isPressed || _isFocused || _isHovered;
  }

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: ShapeDecoration(
              shape: OvalBorder(),
              color: _resolveScheduleBackgroundColor(context),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/core/calendar.svg',
                colorFilter: ColorFilter.mode(
                  _resolveScheduleIconColor(context),
                  BlendMode.srcIn,
                ),
                width: 24.0,
                height: 24.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titleText,
                style: FontStyles.semi16.copyWith(color: context.grays.black),
              ),
              Text(
                widget.locationText,
                style: FontStyles.med14.copyWith(color: context.grays.gray4),
              ),
              Text(
                widget.timeText,
                style: FontStyles.med12.copyWith(color: context.grays.gray4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _resolveScheduleBackgroundColor(BuildContext context) {
    return switch (widget.scheduleType) {
      ScheduleType.mine => context.colors.primary,
      ScheduleType.none => context.grays.gray1,
    };
  }

  Color _resolveScheduleIconColor(BuildContext context) {
    return switch (widget.scheduleType) {
      ScheduleType.mine => context.brands.beatOrange4,
      ScheduleType.none => context.grays.gray3,
    };
  }
}
