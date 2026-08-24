import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_day_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';

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

  /// 해당 날짜에 일정이 있는지 반환
  final bool Function(DateTime day) hasSchedule;

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
  static const double _daysOfWeekHeight = 28;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CalendarWeekdayHeader(),

        const SizedBox(height: AppSpacing.x12),

        TableCalendar<Object?>(
          firstDay: DateUtils.dateOnly(firstDay),
          lastDay: DateUtils.dateOnly(lastDay),
          focusedDay: DateUtils.dateOnly(focusedDay),

          // TableCalendar 기본 오늘 계산 대신
          // 화면에서 관리하는 오늘 값을 사용합니다.
          currentDay: DateUtils.dateOnly(today),

          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.sunday,

          // Beatit 전용 월 헤더를 바깥에서 따로 구현합니다.
          headerVisible: false,
          daysOfWeekVisible: false,
          rowHeight: _dayItemHeight + weekGap,

          // 세로 화면 스크롤과 충돌하지 않도록
          // 캘린더에서는 가로 스와이프만 받습니다.
          availableGestures: AvailableGestures.horizontalSwipe,

          // 5주짜리 달은 5주로, 6주짜리 달은 6주로 표시합니다.
          sixWeekMonthsEnforced: false,
          shouldFillViewport: false,

          // Padding 부분까지 날짜 셀 전체를 터치 영역으로 사용
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

          // 기본 날짜 장식은 사용하지 않고 CalendarDayItem이 담당합니다.
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

            // todayBuilder, selectedBuilder, outsideBuilder를
            // 각각 중복 작성하지 않고 이곳에서 한 번에 처리합니다.
            prioritizedBuilder: (context, day, visibleMonth) {
              final isCurrentMonth =
                  day.year == visibleMonth.year &&
                  day.month == visibleMonth.month;

              final isToday = DateUtils.isSameDay(day, today);
              final isSelected = DateUtils.isSameDay(day, selectedDay);
              final hasDaySchedule = hasSchedule(day);

              return Padding(
                padding: EdgeInsets.symmetric(vertical: weekGap / 2),
                child: CalendarDayItem(
                  day: day.day,
                  label: labelForDay(day),
                  isSelected: isSelected,
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

                  // 날짜 터치는 TableCalendar.onDaySelected가 담당합니다.
                  // CalendarDayItem에서는 중복 콜백을 연결하지 않습니다.
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
      children: weekdays.map((weekday) {
        return Expanded(
          child: Text(
            weekday,
            textAlign: TextAlign.center,
            style: FontStyles.med12.copyWith(color: context.grays.gray5),
          ),
        );
      }).toList(),
    );
  }
}
