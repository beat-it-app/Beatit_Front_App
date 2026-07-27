import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// 표시된 월 상태
enum CalendarMonthState { currentMonth, outsideMonth }

/// 날짜의 강조 상태 : 우선순위 today > selected > normal
enum CalendarHighlightState {
  normal,
  selected,
  today;

  static CalendarHighlightState resolve({
    required bool isToday,
    required bool isSelected,
  }) {
    if (isToday) {
      return CalendarHighlightState.today;
    }

    if (isSelected) {
      return CalendarHighlightState.selected;
    }

    return CalendarHighlightState.normal;
  }
}

/// 일정 상태
enum CalendarScheduleState { none, hasSchedule }

class CalendarDayItem extends StatelessWidget {
  const CalendarDayItem({
    super.key,
    required this.day,
    this.onTap,
    this.label,
    this.isSelected = false,
    this.monthState = CalendarMonthState.currentMonth,
    this.highlightState = CalendarHighlightState.normal,
    this.scheduleState = CalendarScheduleState.none,
  });

  final int day;
  final String? label;
  final VoidCallback? onTap;

  final bool isSelected;

  final CalendarMonthState monthState;
  final CalendarHighlightState highlightState;
  final CalendarScheduleState scheduleState;

  static const double _dayCircleSize = 35;
  static const double _scheduleDotSize = 12;
  static const double _scheduleDotBorderWidth = 2;

  bool get _hasSchedule {
    return scheduleState == CalendarScheduleState.hasSchedule;
  }

  @override
  Widget build(BuildContext context) {
    final displayLabel = label == null || label!.trim().isEmpty ? '-' : label!;

    return Semantics(
      button: onTap != null,
      selected: isSelected,
      label: _buildSemanticLabel(),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDayCircle(context),

              const SizedBox(height: AppSpacing.x4),

              Text(
                displayLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: FontStyles.med12.copyWith(
                  color: _resolveLabelColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCircle(BuildContext context) {
    return SizedBox(
      width: _dayCircleSize,
      height: _dayCircleSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _dayCircleSize,
            height: _dayCircleSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _resolveDayBackgroundColor(context),
            ),
            child: Text(
              day.toString(),
              style: FontStyles.med14.copyWith(
                color: _resolveDayTextColor(context),
              ),
            ),
          ),

          if (_hasSchedule)
            Positioned(
              top: -2,
              right: -3,
              child: Container(
                width: _scheduleDotSize,
                height: _scheduleDotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary,
                  border: Border.all(
                    color: context.colors.surface,
                    width: _scheduleDotBorderWidth,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _resolveDayBackgroundColor(BuildContext context) {
    return switch (highlightState) {
      CalendarHighlightState.today => context.brands.beatOrange1,

      CalendarHighlightState.selected => context.brands.beatOrange3,

      CalendarHighlightState.normal => switch (monthState) {
        CalendarMonthState.currentMonth => context.grays.gray1,
        CalendarMonthState.outsideMonth => context.grays.gray8,
      },
    };
  }

  Color _resolveDayTextColor(BuildContext context) {
    return switch (highlightState) {
      CalendarHighlightState.today => context.grays.white,

      CalendarHighlightState.selected => context.grays.white,

      CalendarHighlightState.normal => switch (monthState) {
        CalendarMonthState.currentMonth => context.grays.white,
        CalendarMonthState.outsideMonth => context.grays.gray5,
      },
    };
  }

  Color _resolveLabelColor(BuildContext context) {
    if (highlightState == CalendarHighlightState.today) {
      return context.colors.primary;
    }

    if (monthState == CalendarMonthState.outsideMonth) {
      return context.grays.gray6;
    }

    if (_hasSchedule) {
      return context.colors.onSurface;
    }

    return context.grays.gray5;
  }

  String _buildSemanticLabel() {
    final parts = <String>['$day일'];

    if (highlightState == CalendarHighlightState.today) {
      parts.add('오늘');
    }

    if (isSelected) {
      parts.add('선택됨');
    }

    if (_hasSchedule) {
      parts.add('일정 있음');
    }

    if (label != null && label!.trim().isNotEmpty) {
      parts.add(label!);
    }

    return parts.join(', ');
  }
}
