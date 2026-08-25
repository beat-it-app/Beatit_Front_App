import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

/// 밋잇 후보 날짜의 표시 상태입니다.
enum MeatitCalendarDayState {
  /// 오늘 이전 날짜 또는 현재 표시 월 바깥의 날짜
  disabled,

  /// 선택 가능한 날짜
  selectable,

  /// 사용자가 후보 날짜로 선택한 날짜
  selected,
}

class CalendarDayItem extends StatelessWidget {
  const CalendarDayItem({
    super.key,
    required this.date,
    required this.state,
    this.onTap,
  });

  final DateTime date;
  final MeatitCalendarDayState state;
  final VoidCallback? onTap;

  static const double dayCircleSize = 35;

  bool get _isDisabled => state == MeatitCalendarDayState.disabled;
  bool get _isSelected => state == MeatitCalendarDayState.selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: !_isDisabled,
      enabled: !_isDisabled,
      selected: _isSelected,
      label: '${date.month}월 ${date.day}일${_isSelected ? ', 선택됨' : ''}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isDisabled ? null : onTap,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              width: dayCircleSize,
              height: dayCircleSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _backgroundColor(context),
              ),
              child: Text(
                '${date.day}',
                style: FontStyles.med14.copyWith(
                  color: _textColor(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    return switch (state) {
      MeatitCalendarDayState.disabled => context.grays.gray8,
      MeatitCalendarDayState.selectable => context.grays.black,
      MeatitCalendarDayState.selected => context.brands.beatOrange1,
    };
  }

  Color _textColor(BuildContext context) {
    return switch (state) {
      MeatitCalendarDayState.disabled => context.grays.gray5,
      MeatitCalendarDayState.selectable => context.grays.white,
      MeatitCalendarDayState.selected => context.grays.white,
    };
  }
}
