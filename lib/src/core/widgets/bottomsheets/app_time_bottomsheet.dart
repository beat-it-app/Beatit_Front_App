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
    required this.onConfirmTime,
    required this.onConfirmDate,
  });

  final AppTimePickerMode mode;
  final String? title;
  final TimeOfDay? initialTime;
  final DateTime? initialDate;

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
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppTimeBottomSheet(
        mode: AppTimePickerMode.date,
        initialDate: initialDate,
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

  final int _startYear = 2000;
  final int _endYear = DateTime.now().year;

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
    } else {
      final initial = widget.initialDate ?? DateTime.now();
      _selectedYear = initial.year;
      _selectedMonth = initial.month;
      _selectedDay = initial.day;
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
    int maxDays = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);
    int day = _selectedDay > maxDays ? maxDays : _selectedDay;
    return DateTime(_selectedYear, _selectedMonth, day);
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
                      Expanded(
                        child: Center(
                          child: Text(
                            '',
                            style: FontStyles.med20.copyWith(
                              color: context.grays.gray3,
                            ),
                          ),
                        ),
                      ),
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

            // 피커 영역 (시간 또는 날짜)
            SizedBox(
              height: 200,
              child: isTimeMode
                  ? _buildTimePicker(colors)
                  : _buildDatePicker(colors),
            ),

            const SizedBox(height: AppSpacing.x20),

            // 선택 완료 버튼
            AppButton(
              text: '선택 완료',
              width: ButtonWidth.expand,
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
          ],
        ),
      ),
    );
  }

  // 시간 피커 (오전/오후, 시, 분)
  Widget _buildTimePicker(ColorScheme colors) {
    return Row(
      children: [
        // 오전 / 오후
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
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
        // 시 (1시 ~ 12시)
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
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
        // 분 (00분 ~ 59분)
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
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

  // 날짜 피커 (년, 월, 일)
  Widget _buildDatePicker(ColorScheme colors) {
    int maxDays = DateUtils.getDaysInMonth(_selectedYear, _selectedMonth);

    int yearIndex = _selectedYear - _startYear;
    if (yearIndex < 0) yearIndex = 0;
    if (yearIndex > _endYear - _startYear) yearIndex = _endYear - _startYear;

    return Row(
      children: [
        // 년도
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
              initialItem: yearIndex,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedYear = _startYear + index;
              });
            },
            children: List.generate(_endYear - _startYear + 1, (index) {
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
        // 월
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
              initialItem: _selectedMonth - 1,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMonth = index + 1;
              });
            },
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
        // 일
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40,
            scrollController: FixedExtentScrollController(
              initialItem:
                  (_selectedDay > maxDays ? maxDays : _selectedDay) - 1,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedDay = index + 1;
              });
            },
            children: List.generate(maxDays, (index) {
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
