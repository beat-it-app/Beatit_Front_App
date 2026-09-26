import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_day_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({
    super.key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    required this.selectedDay,
    required this.today,
    required this.hasSchedule,
    required this.labelForDay,
    required this.onDaySelected,
    required this.onPageChanged,
    this.isHoliday,
    this.weekGap = AppSpacing.x12,
  });

  /// 사용자가 이동할 수 있는 첫 날짜
  final DateTime firstDay;

  /// 사용자가 이동할 수 있는 마지막 날짜
  final DateTime lastDay;

  /// 현재 화면에 표시 중인 월
  final DateTime focusedDay;

  /// 사용자가 선택한 날짜
  final DateTime selectedDay;

  /// 실제 오늘
  final DateTime today;

  /// 해당 날짜에 내가 참여하는 일정이 있는지 반환
  final bool Function(DateTime day) hasSchedule;

  /// 해당 날짜가 공휴일인지 반환
  ///
  /// 현재 공휴일 API/모델이 연결되어 있지 않으므로 optional로 유지합니다.
  final bool Function(DateTime day)? isHoliday;

  /// 날짜 원 아래에 표시할 라벨
  final String? Function(DateTime day) labelForDay;

  /// 날짜 선택
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  /// 월 페이지 변경
  final ValueChanged<DateTime> onPageChanged;

  /// 주차와 주차 사이에 들어갈 세로 간격
  final double weekGap;

  /// 날짜 원 + 라벨이 실제로 사용하는 높이
  static const double _dayItemHeight = 60;

  @override
  Widget build(BuildContext context) {
    final normalizedToday = DateUtils.dateOnly(today);

    return Column(
      children: [
        const _CalendarWeekdayHeader(),

        const SizedBox(height: AppSpacing.x12),

        TableCalendar<Object?>(
          firstDay: DateUtils.dateOnly(firstDay),
          lastDay: DateUtils.dateOnly(lastDay),
          focusedDay: DateUtils.dateOnly(focusedDay),
          currentDay: normalizedToday,

          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,

          headerVisible: false,
          daysOfWeekVisible: false,
          rowHeight: _dayItemHeight + weekGap,

          availableGestures: AvailableGestures.horizontalSwipe,

          sixWeekMonthsEnforced: false,
          shouldFillViewport: false,

          dayHitTestBehavior: HitTestBehavior.opaque,

          selectedDayPredicate: (day) {
            return DateUtils.isSameDay(day, selectedDay);
          },

          onDaySelected: (selectedDay, focusedDay) {
            onDaySelected(
              DateUtils.dateOnly(selectedDay),
              DateUtils.dateOnly(focusedDay),
            );
          },

          onPageChanged: (focusedDay) {
            onPageChanged(DateTime(focusedDay.year, focusedDay.month));
          },

          calendarStyle: const CalendarStyle(
            outsideDaysVisible: true,
            isTodayHighlighted: false,
            cellMargin: EdgeInsets.zero,
            cellPadding: EdgeInsets.zero,
          ),

          calendarBuilders: CalendarBuilders<Object?>(
            dowBuilder: (context, day) {
              return Center(
                child: Text(
                  _weekdayLabel(day.weekday),
                  style: FontStyles.med12.copyWith(color: context.grays.gray5),
                ),
              );
            },

            prioritizedBuilder: (context, day, visibleMonth) {
              final normalizedDay = DateUtils.dateOnly(day);

              final isCurrentMonth =
                  day.year == visibleMonth.year &&
                  day.month == visibleMonth.month;

              final isToday = DateUtils.isSameDay(
                normalizedDay,
                normalizedToday,
              );

              final isSelected = DateUtils.isSameDay(
                normalizedDay,
                selectedDay,
              );

              final hasDaySchedule = hasSchedule(normalizedDay);

              final isPast = normalizedDay.isBefore(normalizedToday);

              final isHolidayDay = isHoliday?.call(normalizedDay) ?? false;

              return Padding(
                padding: EdgeInsets.symmetric(vertical: weekGap / 2),
                child: CalendarDayItem(
                  day: day.day,
                  label: labelForDay(normalizedDay),
                  isSelected: isSelected,
                  isHoliday: isHolidayDay,
                  isPast: isPast,
                  monthState: isCurrentMonth
                      ? CalendarMonthState.currentMonth
                      : CalendarMonthState.outsideMonth,
                  highlightState: CalendarHighlightState.resolve(
                    isToday: isToday,
                    isSelected: isSelected,
                  ),
                  scheduleState: hasDaySchedule
                      ? CalendarScheduleState.hasSchedule
                      : CalendarScheduleState.none,
                  onTap: null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static String _weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.sunday => '일',
      DateTime.monday => '월',
      DateTime.tuesday => '화',
      DateTime.wednesday => '수',
      DateTime.thursday => '목',
      DateTime.friday => '금',
      DateTime.saturday => '토',
      _ => '',
    };
  }
}

class _CalendarWeekdayHeader extends StatelessWidget {
  const _CalendarWeekdayHeader();

  static const weekdays = <String>['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(weekdays.length, (index) {
        final isSunday = index == 0;

        return Expanded(
          child: Text(
            weekdays[index],
            textAlign: TextAlign.center,
            style: FontStyles.med12.copyWith(
              color: isSunday
                  ? context.brands.beatOrange1
                  : context.grays.gray5,
            ),
          ),
        );
      }),
    );
  }
}
