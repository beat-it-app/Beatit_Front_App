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
    this.minuteInterval = 1,
    this.initialDate,
    this.startYear = 2000,
    this.minDate,
    this.maxDate,
    required this.onConfirmTime,
    required this.onConfirmDate,
  });

  final AppTimePickerMode mode;
  final String? title;
  final TimeOfDay? initialTime;

  /// 시간 선택 간격입니다. 기본값은 기존 동작과 같은 1분입니다.
  final int minuteInterval;
  final DateTime? initialDate;
  final int startYear;
  final DateTime? minDate;
  final DateTime? maxDate;

  final ValueChanged<TimeOfDay>? onConfirmTime;
  final ValueChanged<DateTime>? onConfirmDate;

  static Future<TimeOfDay?> showTimePicker(
    BuildContext context, {
    String? title,
    TimeOfDay? initialTime,
    int minuteInterval = 1,
  }) {
    assert(minuteInterval > 0 && 60 % minuteInterval == 0);
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppTimeBottomSheet(
        mode: AppTimePickerMode.time,
        title: title,
        initialTime: initialTime,
        minuteInterval: minuteInterval,
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
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppTimeBottomSheet(
        mode: AppTimePickerMode.date,
        title: title,
        initialDate: initialDate,
        startYear: startYear ?? minDate?.year ?? 2000,
        minDate: minDate,
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

  DateTime? get _minDateOnly =>
      widget.minDate != null ? DateUtils.dateOnly(widget.minDate!) : null;

  DateTime get _effectiveMaxDate {
    if (widget.maxDate != null) return DateUtils.dateOnly(widget.maxDate!);
    // minDate가 설정된 미래 선택 모드에서는 기본 최대 연도를 10년 뒤로 허용
    if (widget.minDate != null) {
      return DateTime(DateTime.now().year + 10, 12, 31);
    }
    return DateUtils.dateOnly(DateTime.now());
  }

  int get _startYear => _minDateOnly?.year ?? widget.startYear;

  int get _endYear => _effectiveMaxDate.year;

  @override
  void initState() {
    super.initState();

    if (widget.mode == AppTimePickerMode.time) {
      final initial = widget.initialTime ?? TimeOfDay.now();
      _selectedPeriodIndex = initial.hour >= 12 ? 1 : 0;
      int hour12 = initial.hourOfPeriod;
      if (hour12 == 0) hour12 = 12;
      _selectedHourIndex = hour12 - 1;
      _selectedMinuteIndex = initial.minute ~/ widget.minuteInterval;
      _selectedYear = DateTime.now().year;
      _selectedMonth = DateTime.now().month;
      _selectedDay = DateTime.now().day;
    } else {
      DateTime initial = DateUtils.dateOnly(
        widget.initialDate ?? DateTime.now(),
      );
      if (_minDateOnly != null && initial.isBefore(_minDateOnly!)) {
        initial = _minDateOnly!;
      }
      if (initial.isAfter(_effectiveMaxDate)) {
        initial = _effectiveMaxDate;
      }
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
    return TimeOfDay(
      hour: hour24,
      minute: _selectedMinuteIndex * widget.minuteInterval,
    );
  }

  DateTime _getSelectedDate() {
    final minDate = _minDateOnly;
    final maxDate = _effectiveMaxDate;

    int year = _selectedYear.clamp(_startYear, maxDate.year);

    int minMonth = (minDate != null && year == minDate.year)
        ? minDate.month
        : 1;
    int maxMonth = (year == maxDate.year) ? maxDate.month : 12;
    int month = _selectedMonth.clamp(minMonth, maxMonth);

    int maxDaysInMonth = DateUtils.getDaysInMonth(year, month);
    int minDay =
        (minDate != null && year == minDate.year && month == minDate.month)
        ? minDate.day
        : 1;
    int maxDay = (year == maxDate.year && month == maxDate.month)
        ? maxDate.day
        : maxDaysInMonth;
    int day = _selectedDay.clamp(minDay, maxDay);

    return DateTime(year, month, day);
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
            children: List.generate(60 ~/ widget.minuteInterval, (index) {
              final minute = (index * widget.minuteInterval).toString().padLeft(
                2,
                '0',
              );
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
    final minDate = _minDateOnly;
    final maxDate = _effectiveMaxDate;

    int maxYear = _endYear;
    int currentYear = _selectedYear.clamp(_startYear, maxYear);

    int minMonth = (minDate != null && currentYear == minDate.year)
        ? minDate.month
        : 1;
    int maxMonth = (currentYear == maxDate.year) ? maxDate.month : 12;
    int currentMonth = _selectedMonth.clamp(minMonth, maxMonth);

    int maxDaysInMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);
    int minDay =
        (minDate != null &&
            currentYear == minDate.year &&
            currentMonth == minDate.month)
        ? minDate.day
        : 1;
    int maxDay = (currentYear == maxDate.year && currentMonth == maxDate.month)
        ? maxDate.day
        : maxDaysInMonth;
    int currentDay = _selectedDay.clamp(minDay, maxDay);

    int yearIndex = (currentYear - _startYear).clamp(0, maxYear - _startYear);
    int monthIndex = (currentMonth - minMonth).clamp(0, maxMonth - minMonth);
    int dayIndex = (currentDay - minDay).clamp(0, maxDay - minDay);

    return Row(
      children: [
        // 연도 피커
        Expanded(
          child: CupertinoPicker(
            key: ValueKey('year_$_startYear\_$maxYear'),
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: yearIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedYear = _startYear + index;
                final newMinMonth =
                    (minDate != null && _selectedYear == minDate.year)
                    ? minDate.month
                    : 1;
                final newMaxMonth = (_selectedYear == maxDate.year)
                    ? maxDate.month
                    : 12;
                _selectedMonth = _selectedMonth.clamp(newMinMonth, newMaxMonth);

                final mDays = DateUtils.getDaysInMonth(
                  _selectedYear,
                  _selectedMonth,
                );
                final newMinDay =
                    (minDate != null &&
                        _selectedYear == minDate.year &&
                        _selectedMonth == minDate.month)
                    ? minDate.day
                    : 1;
                final newMaxDay =
                    (_selectedYear == maxDate.year &&
                        _selectedMonth == maxDate.month)
                    ? maxDate.day
                    : mDays;
                _selectedDay = _selectedDay.clamp(newMinDay, newMaxDay);
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
        // 월 피커 (과거 월 원천 차단)
        Expanded(
          child: CupertinoPicker(
            key: ValueKey('month_${currentYear}_$minMonth\_$maxMonth'),
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: monthIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMonth = minMonth + index;
                final mDays = DateUtils.getDaysInMonth(
                  _selectedYear,
                  _selectedMonth,
                );
                final newMinDay =
                    (minDate != null &&
                        _selectedYear == minDate.year &&
                        _selectedMonth == minDate.month)
                    ? minDate.day
                    : 1;
                final newMaxDay =
                    (_selectedYear == maxDate.year &&
                        _selectedMonth == maxDate.month)
                    ? maxDate.day
                    : mDays;
                _selectedDay = _selectedDay.clamp(newMinDay, newMaxDay);
              });
            },
            children: List.generate(maxMonth - minMonth + 1, (index) {
              final month = minMonth + index;
              return Center(
                child: Text(
                  '$month',
                  style: FontStyles.reg18.copyWith(color: colors.onSurface),
                ),
              );
            }),
          ),
        ),
        // 일 피커 (과거 일 원천 차단)
        Expanded(
          child: CupertinoPicker(
            key: ValueKey(
              'day_${currentYear}_${currentMonth}_$minDay\_$maxDay',
            ),
            itemExtent: 40,
            selectionOverlay: const SizedBox.shrink(),
            scrollController: FixedExtentScrollController(
              initialItem: dayIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedDay = minDay + index;
              });
            },
            children: List.generate(maxDay - minDay + 1, (index) {
              final day = minDay + index;
              return Center(
                child: Text(
                  '$day',
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
