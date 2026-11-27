import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/calendar_day_item.dart';
import 'package:flutter/material.dart';

/// 밋잇 생성 화면에서 사용하는 다중 날짜 선택 달력입니다.
///
/// - 기본 상태에서는 현재 주를 기준으로 2주만 표시합니다.
/// - 펼치면 현재 월 전체를 표시합니다.
/// - 오늘 이전 날짜는 선택할 수 없습니다.
/// - 탭 또는 드래그로 여러 날짜를 선택/해제할 수 있습니다.
class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    super.key,
    required this.focusedMonth,
    required this.today,
    required this.selectedDays,
    required this.isExpanded,
    required this.onSelectionChanged,
  });

  final DateTime focusedMonth;
  final DateTime today;
  final Set<DateTime> selectedDays;
  final bool isExpanded;
  final ValueChanged<Set<DateTime>> onSelectionChanged;

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  static const double _dayCellHeight = 48;
  static const int _columnCount = 7;

  final Set<int> _dragVisitedIndexes = <int>{};
  bool? _dragShouldSelect;

  DateTime get _normalizedToday => DateUtils.dateOnly(widget.today);

  DateTime get _normalizedFocusedMonth =>
      DateTime(widget.focusedMonth.year, widget.focusedMonth.month);

  @override
  Widget build(BuildContext context) {
    final cells = _buildVisibleCells();
    final rowCount = (cells.length / _columnCount).ceil();

    return Column(
      children: [
        const _CalendarWeekdayHeader(),
        const SizedBox(height: AppSpacing.x8),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth / _columnCount;
            final gridHeight = rowCount * _dayCellHeight;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                _startDrag(details.localPosition, cells, cellWidth, gridHeight);
              },
              onPanUpdate: (details) {
                _updateDrag(
                  details.localPosition,
                  cells,
                  cellWidth,
                  gridHeight,
                );
              },
              onPanEnd: (_) => _finishDrag(),
              onPanCancel: _finishDrag,
              child: SizedBox(
                height: gridHeight,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _columnCount,
                    mainAxisExtent: _dayCellHeight,
                  ),
                  itemCount: cells.length,
                  itemBuilder: (context, index) {
                    final date = cells[index];

                    if (date == null) {
                      return const SizedBox.shrink();
                    }

                    final dayState = _resolveDayState(date);

                    return CalendarDayItem(
                      date: date,
                      state: dayState,
                      onTap: dayState == MeatitCalendarDayState.disabled
                          ? null
                          : () => _toggleDate(date),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 화면에 보여줄 셀을 실제 요일 위치에 맞춰 생성합니다.
  /// 월 바깥 날짜는 null 셀로 두어 디자인 시안처럼 비워 둡니다.
  List<DateTime?> _buildVisibleCells() {
    if (widget.isExpanded) {
      return _buildFullMonthCells(_normalizedFocusedMonth);
    }

    final focusedMonth = _normalizedFocusedMonth;
    final isCurrentMonth =
        focusedMonth.year == _normalizedToday.year &&
        focusedMonth.month == _normalizedToday.month;

    if (isCurrentMonth) {
      final weekStart = _startOfWeek(_normalizedToday);
      return List<DateTime?>.generate(14, (index) {
        final date = weekStart.add(Duration(days: index));
        return _isSameMonth(date, focusedMonth) ? date : null;
      });
    }

    final monthCells = _buildFullMonthCells(focusedMonth);
    return monthCells.take(math.min(14, monthCells.length)).toList();
  }

  List<DateTime?> _buildFullMonthCells(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Sunday = 0 위치로 맞춥니다.
    final leadingEmptyCount = firstDay.weekday % 7;
    final usedCellCount = leadingEmptyCount + daysInMonth;
    final rowCount = (usedCellCount / _columnCount).ceil();
    final totalCellCount = rowCount * _columnCount;

    return List<DateTime?>.generate(totalCellCount, (index) {
      final day = index - leadingEmptyCount + 1;

      if (day < 1 || day > daysInMonth) {
        return null;
      }

      return DateTime(month.year, month.month, day);
    });
  }

  DateTime _startOfWeek(DateTime date) {
    // Dart weekday: Mon=1 ... Sun=7
    final daysFromSunday = date.weekday % 7;
    return DateUtils.dateOnly(date.subtract(Duration(days: daysFromSunday)));
  }

  MeatitCalendarDayState _resolveDayState(DateTime date) {
    final normalizedDate = DateUtils.dateOnly(date);

    if (normalizedDate.isBefore(_normalizedToday)) {
      return MeatitCalendarDayState.disabled;
    }

    if (_containsDate(widget.selectedDays, normalizedDate)) {
      return MeatitCalendarDayState.selected;
    }

    return MeatitCalendarDayState.selectable;
  }

  void _toggleDate(DateTime date) {
    final normalizedDate = DateUtils.dateOnly(date);

    if (normalizedDate.isBefore(_normalizedToday)) {
      return;
    }

    final nextSelectedDays = _normalizedSelectedDays();

    if (nextSelectedDays.contains(normalizedDate)) {
      nextSelectedDays.remove(normalizedDate);
    } else {
      nextSelectedDays.add(normalizedDate);
    }

    widget.onSelectionChanged(nextSelectedDays);
  }

  void _startDrag(
    Offset localPosition,
    List<DateTime?> cells,
    double cellWidth,
    double gridHeight,
  ) {
    _dragVisitedIndexes.clear();
    _dragShouldSelect = null;

    final index = _indexForPosition(
      localPosition,
      cells.length,
      cellWidth,
      gridHeight,
    );

    if (index == null) {
      return;
    }

    final date = cells[index];
    if (!_isSelectableDate(date)) {
      return;
    }

    final normalizedDate = DateUtils.dateOnly(date!);
    _dragShouldSelect = !_containsDate(widget.selectedDays, normalizedDate);
    _applyDragAt(index, cells);
  }

  void _updateDrag(
    Offset localPosition,
    List<DateTime?> cells,
    double cellWidth,
    double gridHeight,
  ) {
    if (_dragShouldSelect == null) {
      return;
    }

    final index = _indexForPosition(
      localPosition,
      cells.length,
      cellWidth,
      gridHeight,
    );

    if (index == null) {
      return;
    }

    _applyDragAt(index, cells);
  }

  void _applyDragAt(int index, List<DateTime?> cells) {
    if (_dragVisitedIndexes.contains(index)) {
      return;
    }

    final date = cells[index];
    if (!_isSelectableDate(date)) {
      return;
    }

    _dragVisitedIndexes.add(index);

    final normalizedDate = DateUtils.dateOnly(date!);
    final nextSelectedDays = _normalizedSelectedDays();

    if (_dragShouldSelect == true) {
      nextSelectedDays.add(normalizedDate);
    } else {
      nextSelectedDays.remove(normalizedDate);
    }

    widget.onSelectionChanged(nextSelectedDays);
  }

  void _finishDrag() {
    _dragVisitedIndexes.clear();
    _dragShouldSelect = null;
  }

  int? _indexForPosition(
    Offset position,
    int itemCount,
    double cellWidth,
    double gridHeight,
  ) {
    if (position.dx < 0 ||
        position.dy < 0 ||
        position.dx >= cellWidth * _columnCount ||
        position.dy >= gridHeight) {
      return null;
    }

    final column = (position.dx / cellWidth).floor();
    final row = (position.dy / _dayCellHeight).floor();
    final index = row * _columnCount + column;

    if (index < 0 || index >= itemCount) {
      return null;
    }

    return index;
  }

  bool _isSelectableDate(DateTime? date) {
    if (date == null) {
      return false;
    }

    return !DateUtils.dateOnly(date).isBefore(_normalizedToday);
  }

  Set<DateTime> _normalizedSelectedDays() {
    return widget.selectedDays.map(DateUtils.dateOnly).toSet();
  }

  bool _containsDate(Set<DateTime> dates, DateTime target) {
    return dates.any((date) => DateUtils.isSameDay(date, target));
  }

  bool _isSameMonth(DateTime date, DateTime month) {
    return date.year == month.year && date.month == month.month;
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
