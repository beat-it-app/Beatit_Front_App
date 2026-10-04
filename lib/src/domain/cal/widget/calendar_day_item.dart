import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// 표시된 월 상태
enum CalendarMonthState { currentMonth, outsideMonth }

/// 날짜의 강조 상태
/// 오늘은 선택 여부보다 우선해서 오늘 스타일을 유지합니다.
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
    this.isHoliday = false,
    this.isPast = false,
    this.monthState = CalendarMonthState.currentMonth,
    this.highlightState = CalendarHighlightState.normal,
    this.scheduleState = CalendarScheduleState.none,
  });

  final int day;
  final String? label;
  final VoidCallback? onTap;

  final bool isSelected;

  /// 공휴일 여부
  final bool isHoliday;

  /// 오늘 이전 날짜 여부
  final bool isPast;

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
              style: FontStyles.semi14.copyWith(
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
                  color: _resolveScheduleDotColor(context),
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

  /// 큰 날짜 원 색상
  Color _resolveDayBackgroundColor(BuildContext context) {
    // 선택한 공휴일
    // 일요일도 isHoliday == true이므로 동일하게 적용됨
    if (isSelected && isHoliday) {
      return context.brands.beatOrange1;
    }

    return switch (highlightState) {
      // 오늘
      CalendarHighlightState.today => context.grays.gray1,

      // 선택한 일반 날짜
      CalendarHighlightState.selected => context.brands.beatOrange3,

      // 일반 날짜 / 선택되지 않은 공휴일 모두 gray8
      CalendarHighlightState.normal => context.grays.gray8,
    };
  }

  Color _resolveDayTextColor(BuildContext context) {
    // 선택한 날짜는 배경 위에서 보여야 하므로 white
    if (isSelected) {
      return context.grays.white;
    }
    // 오늘
    if (highlightState == CalendarHighlightState.today) {
      return context.grays.white;
    }
    // 이전/다음 달 날짜
    if (monthState == CalendarMonthState.outsideMonth) {
      return context.grays.gray5;
    }
    // 일요일 또는 공휴일
    if (isHoliday) {
      return context.brands.beatOrange1;
    }
    // 일반 날짜
    return context.grays.black;
  }

  /// 날짜 우측 상단 일정 표시 점
  Color _resolveScheduleDotColor(BuildContext context) {
    // 당일 및 다가오는 일정
    if (!isPast) {
      return context.brands.beatOrange1;
    }

    // 지난 일정
    return context.grays.gray5;
  }

  /// 날짜 아래 일정 텍스트 색상
  Color _resolveLabelColor(BuildContext context) {
    // 오늘이 아닌 다른 날짜를 선택한 경우
    if (isSelected && highlightState != CalendarHighlightState.today) {
      return context.brands.beatOrange1;
    }

    // 지난 일정/날짜는 일정 존재 여부와 관계없이 gray5
    if (isPast) {
      return context.grays.gray5;
    }

    // 오늘 또는 미래에 내가 참여하는 일정이 있는 경우
    if (_hasSchedule) {
      return context.grays.black;
    }

    // 일정이 없는 경우
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

    if (isHoliday) {
      parts.add('공휴일');
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
