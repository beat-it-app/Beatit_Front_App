import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

enum AppTimePickerMode { time, date }

class AppTimeBottomSheet extends StatefulWidget {
  const AppTimeBottomSheet({
    super.key,
    required this.mode,
    this.title,
    this.initialTime,
    this.initialDate,
    this.startYear = 2000,
    this.maxDate,
    required this.onConfirmTime,
    required this.onConfirmDate,
  });

  final AppTimePickerMode mode;
  final String? title;
  final TimeOfDay? initialTime;
  final DateTime? initialDate;
  final int startYear;
  final DateTime? maxDate;

  final ValueChanged<TimeOfDay>? onConfirmTime;
  final ValueChanged<DateTime>? onConfirmDate;

  static Future<TimeOfDay?> showTimePicker(
    BuildContext context, {
    String? title,
    TimeOfDay? initialTime,
  }) {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppTimeBottomSheet(
        mode: AppTimePickerMode.time,
        initialTime: initialTime,
        onConfirmTime: (selectedTime) {
          Navigator.of(context).pop(selectedTime);
        },
        onConfirmDate: null,
      ),
    );
  }

  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    String? title,
    DateTime? initialDate,
    int? startYear,
    DateTime? maxDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppTimeBottomSheet(
        mode: AppTimePickerMode.date,
        initialDate: initialDate,
        startYear: startYear ?? 2000,
        maxDate: maxDate,
        onConfirmTime: null,
        onConfirmDate: (selectedDate) {
          Navigator.of(context).pop(selectedDate);
        },
      ),
    );
  }

  @override
  State<AppTimeBottomSheet> createState() => _AppTimeBottomSheetState();
}

class _AppTimeBottomSheetState extends State<AppTimeBottomSheet> {
  late int _selectedPeriodIndex;
  late int _selectedHourIndex;
  late int _selectedMinuteIndex;

  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  int get _startYear => widget.startYear;

  int get _endYear => widget.maxDate?.year ?? DateTime.now().year;

  @override
  void initState() {
    super.initState();

    if (widget.mode == AppTimePickerMode.time) {
      final initial = widget.initialTime ?? TimeOfDay.now();
      _selectedPeriodIndex = initial.hour >= 12 ? 1 : 0;
      int hour12 = initial.hourOfPeriod;
      if (hour12 == 0) hour12 = 12;
      _selectedHourIndex = hour12 - 1;
      _selectedMinuteIndex = initial.minute;
      _selectedYear = DateTime.now().year;
      _selectedMonth = DateTime.now().month;
      _selectedDay = DateTime.now().day;
    } else {
      final initial = widget.initialDate ?? DateTime.now();
      _selectedYear = initial.year;
      _selectedMonth = initial.month;
      _selectedDay = initial.day;
      _selectedPeriodIndex = 0;
      _selectedHourIndex = 0;
      _selectedMinuteIndex = 0;
    }
  }

  TimeOfDay _getSelectedTime() {
    bool isPM = _selectedPeriodIndex == 1;
    int hour12 = _selectedHourIndex + 1;
    int hour24;
    if (isPM) {
      hour24 = hour12 == 12 ? 12 : hour12 + 12;
    } else {
      hour24 = hour12 == 12 ? 0 : hour12;
    }
    return TimeOfDay(hour: hour24, minute: _selectedMinuteIndex);
  }

  DateTime _getSelectedDate() {
    final limitDate = widget.maxDate ?? DateTime.now();
    int maxYear = limitDate.year;
    int maxMonth = (_selectedYear == maxYear) ? limitDate.month : 12;
    int month = _selectedMonth > maxMonth ? maxMonth : _selectedMonth;

    int maxDays = DateUtils.getDaysInMonth(_selectedYear, month);
    int maxDay = (_selectedYear == maxYear && month == limitDate.month)
        ? limitDate.day
        : maxDays;
    int day = _selectedDay > maxDay ? maxDay : _selectedDay;

    return DateTime(_selectedYear, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isTimeMode = widget.mode == AppTimePickerMode.time;
    final displayTitle = widget.title ?? (isTimeMode ? '시간 선택' : '날짜 선택');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x20,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x20),
            Center(
              child: Text(
                displayTitle,
                textAlign: TextAlign.center,
                style: FontStyles.bold26.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(height: AppSpacing.x24),
            Row(
              children: isTimeMode
                  ? [
                      const Expanded(child: Center(child: Text(''))),
                      Expanded(
                        child: Center(
                          child: Text(
                            '시',
                            style: FontStyles.med20.copyWith(
                              color: context.grays.gray3,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '분',
                            style: FontStyles.med20.copyWith(
                              color: context.grays.gray3,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : [
                      Expanded(
                        child: Center(
                          child: Text(
                            '년',
                            style: FontStyles.med20.copyWith(
                              color: context.grays.gray3,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '월',
                            style: FontStyles.med20.copyWith(
                              color: context.grays.gray3,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '일',
                            style: FontStyles.med20.copyWith(
                              color: context.grays.gray3,
                            ),
                          ),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: AppSpacing.x8),
            Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.grays.gray8,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: isTimeMode
                      ? _buildTimePicker(colors)
                      : _buildDatePicker(colors),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: '취소',
                    height: ButtonHeight.normal,
                    variant: ButtonVariant.outlinedGray,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: AppButton(
                    text: '확인',
                    height: ButtonHeight.normal,
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      if (isTimeMode) {
                        widget.onConfirmTime?.call(_getSelectedTime());
                      } else {
                        widget.onConfirmDate?.call(_getSelectedDate());
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: _selectedPeriodIndex,
            ),
            onSelectedItemChanged: (index) =>
                setState(() => _selectedPeriodIndex = index),
            children: [
              Center(
                child: Text(
                  '오전',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              ),
              Center(
                child: Text(
                  '오후',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: _selectedHourIndex,
            ),
            onSelectedItemChanged: (index) =>
                setState(() => _selectedHourIndex = index),
            children: List.generate(12, (index) {
              return Center(
                child: Text(
                  '${index + 1}',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: _selectedMinuteIndex,
            ),
            onSelectedItemChanged: (index) =>
                setState(() => _selectedMinuteIndex = index),
            children: List.generate(60, (index) {
              final minute = index.toString().padLeft(2, '0');
              return Center(
                child: Text(
                  minute,
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(ColorScheme colors) {
    final DateTime limitDate = widget.maxDate ?? DateTime.now();

    int maxYear = limitDate.year;
    int currentYear = _selectedYear > maxYear ? maxYear : _selectedYear;

    // 현재 선택된 연도가 제한 연도(올해)와 같으면 maxMonth를 limitDate의 월(8월)로 고정
    int maxMonth = (currentYear == limitDate.year) ? limitDate.month : 12;
    int currentMonth = _selectedMonth > maxMonth ? maxMonth : _selectedMonth;

    int maxDaysInMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);
    int maxDay =
        (currentYear == limitDate.year && currentMonth == limitDate.month)
        ? limitDate.day
        : maxDaysInMonth;
    int currentDay = _selectedDay > maxDay ? maxDay : _selectedDay;

    int yearIndex = currentYear - _startYear;
    if (yearIndex < 0) yearIndex = 0;
    if (yearIndex > maxYear - _startYear) yearIndex = maxYear - _startYear;

    int monthIndex = currentMonth - 1;
    if (monthIndex < 0) monthIndex = 0;
    if (monthIndex >= maxMonth) monthIndex = maxMonth - 1;

    int dayIndex = currentDay - 1;
    if (dayIndex < 0) dayIndex = 0;
    if (dayIndex >= maxDay) dayIndex = maxDay - 1;

    return Row(
      children: [
        // 연도 피커
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: yearIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedYear = _startYear + index;
                int newMaxMonth = (_selectedYear == limitDate.year)
                    ? limitDate.month
                    : 12;
                if (_selectedMonth > newMaxMonth) _selectedMonth = newMaxMonth;
                int mDays = DateUtils.getDaysInMonth(
                  _selectedYear,
                  _selectedMonth,
                );
                int mDayLimit =
                    (_selectedYear == limitDate.year &&
                        _selectedMonth == limitDate.month)
                    ? limitDate.day
                    : mDays;
                if (_selectedDay > mDayLimit) _selectedDay = mDayLimit;
              });
            },
            children: List.generate(maxYear - _startYear + 1, (index) {
              final year = _startYear + index;
              return Center(
                child: Text(
                  '$year',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              );
            }),
          ),
        ),
        // 월 피커: maxMonth 개수(현재 연도라면 8까지만)로 리스트를 생성하여 미래 월을 원천 차단
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: monthIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMonth = index + 1;
                int mDays = DateUtils.getDaysInMonth(
                  _selectedYear,
                  _selectedMonth,
                );
                int mDayLimit =
                    (_selectedYear == limitDate.year &&
                        _selectedMonth == limitDate.month)
                    ? limitDate.day
                    : mDays;
                if (_selectedDay > mDayLimit) _selectedDay = mDayLimit;
              });
            },
            children: List.generate(maxMonth, (index) {
              return Center(
                child: Text(
                  '${index + 1}',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              );
            }),
          ),
        ),
        // 일 피커
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: dayIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedDay = index + 1;
              });
            },
            children: List.generate(maxDay, (index) {
              return Center(
                child: Text(
                  '${index + 1}',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
