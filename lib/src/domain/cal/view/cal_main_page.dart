import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_create_page.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_detail_page.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_month_dropdown.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_month_view.dart';
import 'package:beatit_front_app/src/domain/cal/widget/schedule_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalMainPage extends StatefulWidget {
  const CalMainPage({super.key});

  @override
  State<CalMainPage> createState() => _CalMainPageState();
}

class _CalMainPageState extends State<CalMainPage> {
  late final DateTime _today;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  static final DateTime _firstCalendarDay = DateTime(2020, 1, 1);
  static final DateTime _lastCalendarDay = DateTime(2035, 12, 31);

  /// API 연결 전 UI 확인용 임시 일정 데이터
  ///
  /// Map의 key는 반드시 시간값이 제거된 날짜여야 합니다.
  final Map<DateTime, List<_CalendarScheduleData>> _schedulesByDate = {
    DateTime(2026, 7, 16): const [
      _CalendarScheduleData(
        titleText: '13:00 알사탕 합주',
        locationText: '그라운드 합주실 본점 A3',
        calendarLabel: '합주',
        scheduleType: ScheduleType.mine,
      ),
      _CalendarScheduleData(
        titleText: '17:00 정기 합주',
        locationText: '그라운드 합주실 본점 B1',
        calendarLabel: '합주',
        scheduleType: ScheduleType.mine,
      ),
    ],
    DateTime(2026, 7, 18): const [
      _CalendarScheduleData(
        titleText: '15:00 공연 리허설',
        locationText: 'Beat Hall',
        calendarLabel: '합주',
        scheduleType: ScheduleType.mine,
      ),
    ],
    DateTime(2026, 7, 20): const [
      _CalendarScheduleData(
        titleText: '19:00 개인 연습',
        locationText: '그라운드 합주실 본점 A2',
        calendarLabel: '합주',
        scheduleType: ScheduleType.mine,
      ),
    ],
    DateTime(2026, 7, 23): const [
      _CalendarScheduleData(
        titleText: '18:30 알사탕 합주',
        locationText: '그라운드 합주실 본점 A3',
        calendarLabel: '합주',
        scheduleType: ScheduleType.mine,
      ),
    ],
    DateTime(2026, 7, 25): const [
      _CalendarScheduleData(
        titleText: '14:00 주말 합주',
        locationText: '그라운드 합주실 본점 A3',
        calendarLabel: '합주',
        scheduleType: ScheduleType.mine,
      ),
    ],
    DateTime(2026, 7, 28): const [
      _CalendarScheduleData(
        titleText: '13:00 알사탕 합주',
        locationText: '그라운드 합주실 본점 A3',
        calendarLabel: '13:00 알',
        scheduleType: ScheduleType.mine,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();

    _today = DateUtils.dateOnly(DateTime.now());
    _selectedDay = _today;
    _focusedDay = DateTime(_today.year, _today.month);
  }

  void _goToCalCreatePage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CalCreatePage()));
  }

  void _goToCalDetialPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CalDetailPage()));
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = DateUtils.dateOnly(selectedDay);

      // 이전 달 또는 다음 달의 날짜를 선택했을 때
      // 선택한 날짜가 속한 월로 화면을 이동합니다.
      _focusedDay = DateTime(selectedDay.year, selectedDay.month);
    });
  }

  void _handlePageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = DateTime(focusedDay.year, focusedDay.month);
    });
  }

  void _handleMonthSelected(DateTime selectedMonth) {
    final normalizedMonth = DateTime(selectedMonth.year, selectedMonth.month);

    final lastDayOfMonth = DateUtils.getDaysInMonth(
      normalizedMonth.year,
      normalizedMonth.month,
    );

    final selectedDay = _selectedDay.day > lastDayOfMonth
        ? lastDayOfMonth
        : _selectedDay.day;

    setState(() {
      _focusedDay = normalizedMonth;
      _selectedDay = DateTime(
        normalizedMonth.year,
        normalizedMonth.month,
        selectedDay,
      );
    });
  }

  DateTime _dateKey(DateTime date) {
    return DateUtils.dateOnly(date);
  }

  List<_CalendarScheduleData> _schedulesForDay(DateTime day) {
    return _schedulesByDate[_dateKey(day)] ?? const <_CalendarScheduleData>[];
  }

  bool _hasSchedule(DateTime day) {
    return _schedulesForDay(day).isNotEmpty;
  }

  String? _labelForDay(DateTime day) {
    final schedules = _schedulesForDay(day);

    if (schedules.isEmpty) {
      return null;
    }

    return schedules.first.calendarLabel;
  }

  String _formatMonth(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');

    return '${date.year}.$month';
  }

  String _formatSelectedDate(DateTime date) {
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];

    return '${date.month}월 ${date.day}일 $weekday요일';
  }

  String _formatScheduleDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    final selectedSchedules = _schedulesForDay(_selectedDay);

    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.add,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(0, 68),

        addMenuItems: [
          AppDropdownItem(
            label: '일정 생성하기',
            onPressed: () {
              _goToCalCreatePage();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x12,
            AppSpacing.x16,
            0,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: AppSpacing.x30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMonthHeader(context),

                const SizedBox(height: AppSpacing.x24),

                CalendarMonthView(
                  firstDay: _firstCalendarDay,
                  lastDay: _lastCalendarDay,
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  today: _today,
                  hasSchedule: _hasSchedule,
                  labelForDay: _labelForDay,
                  onDaySelected: _handleDaySelected,
                  onPageChanged: _handlePageChanged,
                ),

                const SizedBox(height: AppSpacing.x20),

                Text(
                  _formatSelectedDate(_selectedDay),
                  style: FontStyles.semi16.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),

                const SizedBox(height: AppSpacing.x20),

                if (selectedSchedules.isEmpty)
                  _buildEmptySchedule(context)
                else
                  _buildScheduleList(selectedSchedules),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    return CalendarMonthDropdown(
      selectedMonth: _focusedDay,
      firstMonth: _firstCalendarDay,
      lastMonth: _lastCalendarDay,
      onMonthSelected: _handleMonthSelected,
      triggerBuilder: (context, controller) {
        return Semantics(
          button: true,
          expanded: controller.isOpen,
          label: '월 선택',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (controller.isOpen) {
                controller.close();
                return;
              }

              controller.open();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatMonth(_focusedDay),
                  style: FontStyles.bold34.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),

                const SizedBox(width: AppSpacing.x4),

                RotatedBox(
                  quarterTurns: controller.isOpen ? 2 : 0,
                  child: SvgPicture.asset(
                    'assets/icons/cal/toggle_down.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.colors.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptySchedule(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x20),
        child: Text(
          '등록된 일정이 없습니다.',
          textAlign: TextAlign.center,
          style: FontStyles.reg14.copyWith(color: context.grays.gray5),
        ),
      ),
    );
  }

  Widget _buildScheduleList(List<_CalendarScheduleData> schedules) {
    return Column(
      children: List.generate(schedules.length, (index) {
        final schedule = schedules[index];
        final isLastItem = index == schedules.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastItem ? 0 : AppSpacing.x30),
          child: ScheduleListItem(
            titleText: schedule.titleText,
            locationText: schedule.locationText,
            timeText: _formatScheduleDate(_selectedDay),
            scheduleType: schedule.scheduleType,
            onTap: () {
              debugPrint('${schedule.titleText} 일정 선택');
              _goToCalDetialPage();
            },
          ),
        );
      }),
    );
  }
}

/// 실제 일정 API 모델이 연결되기 전까지 사용하는
/// CalMainPage 전용 임시 표시 모델입니다.
class _CalendarScheduleData {
  const _CalendarScheduleData({
    required this.titleText,
    required this.locationText,
    required this.calendarLabel,
    required this.scheduleType,
  });

  final String titleText;
  final String locationText;

  /// CalendarDayItem의 날짜 원 아래에 표시할 텍스트
  final String calendarLabel;

  final ScheduleType scheduleType;
}
