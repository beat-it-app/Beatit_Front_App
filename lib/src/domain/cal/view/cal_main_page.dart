import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_date_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_month_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_write_data.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_main_provider.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_create_page.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_detail_page.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_month_dropdown.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_month_view.dart';
import 'package:beatit_front_app/src/domain/cal/widget/schedule_list_item.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalMainPage extends ConsumerStatefulWidget {
  const CalMainPage({super.key});

  @override
  ConsumerState<CalMainPage> createState() => _CalMainPageState();
}

class _CalMainPageState extends ConsumerState<CalMainPage> {
  late final DateTime _today;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  bool _isBootstrapping = true;

  static final DateTime _firstCalendarDay = DateTime(2020, 1, 1);
  static final DateTime _lastCalendarDay = DateTime(2035, 12, 31);

  @override
  void initState() {
    super.initState();

    _today = DateUtils.dateOnly(DateTime.now());
    _selectedDay = _today;
    _focusedDay = DateTime(_today.year, _today.month);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      await Future.wait(<Future<void>>[
        _loadMonth(_focusedDay),
        _loadSelectedDate(_selectedDay),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _isBootstrapping = false;
      });
    });
  }

  Future<void> _loadMonth(DateTime month) {
    return ref.read(calMainProvider.notifier).loadMonth(
      year: month.year,
      month: month.month,
    );
  }

  Future<void> _loadSelectedDate(DateTime day) {
    return ref.read(calMainProvider.notifier).loadDate(day: day);
  }

  Future<void> _refreshCalendar({
    required DateTime month,
    required DateTime day,
  }) async {
    await Future.wait(<Future<void>>[
      ref.read(calMainProvider.notifier).loadMonth(
        year: month.year,
        month: month.month,
        force: true,
      ),
      ref.read(calMainProvider.notifier).loadDate(
        day: day,
        force: true,
      ),
    ]);
  }

  Future<void> _goToCalCreatePage() async {
    final createdSchedule = await Navigator.of(context).push<ScheduleWriteData>(
      MaterialPageRoute(builder: (_) => const CalCreatePage()),
    );

    if (!mounted || createdSchedule == null) {
      return;
    }

    final createdDay = DateUtils.dateOnly(_toKst(createdSchedule.startsAt));
    final createdMonth = DateTime(createdDay.year, createdDay.month);

    setState(() {
      _selectedDay = createdDay;
      _focusedDay = createdMonth;
    });

    await _refreshCalendar(month: createdMonth, day: createdDay);
  }

  Future<void> _goToCalDetailPage(int scheduleId) async {
    final didChange = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CalDetailPage(scheduleId: scheduleId),
      ),
    );

    if (!mounted || didChange != true) {
      return;
    }

    await _refreshCalendar(month: _focusedDay, day: _selectedDay);
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final normalizedSelectedDay = DateUtils.dateOnly(selectedDay);
    final previousFocusedMonth = _focusedDay;
    final nextFocusedMonth = DateTime(selectedDay.year, selectedDay.month);

    setState(() {
      _selectedDay = normalizedSelectedDay;

      // 이전 달 또는 다음 달의 날짜를 선택했을 때
      // 선택한 날짜가 속한 월로 화면을 이동합니다.
      _focusedDay = nextFocusedMonth;
    });

    final hasMonthChanged =
        previousFocusedMonth.year != nextFocusedMonth.year ||
        previousFocusedMonth.month != nextFocusedMonth.month;

    if (hasMonthChanged) {
      _loadMonth(nextFocusedMonth);
    }

    _loadSelectedDate(normalizedSelectedDay);
  }

  void _handlePageChanged(DateTime focusedDay) {
    final normalizedMonth = DateTime(focusedDay.year, focusedDay.month);

    setState(() {
      _focusedDay = normalizedMonth;
    });

    _loadMonth(normalizedMonth);
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

    final nextSelectedDay = DateTime(
      normalizedMonth.year,
      normalizedMonth.month,
      selectedDay,
    );

    setState(() {
      _focusedDay = normalizedMonth;
      _selectedDay = nextSelectedDay;
    });

    _loadMonth(normalizedMonth);
    _loadSelectedDate(nextSelectedDay);
  }

  DateTime _dateKey(DateTime date) {
    return DateUtils.dateOnly(date);
  }

  /// 백엔드 Calendar API가 +09:00 기준으로 범위를 조회하고 있으므로
  /// 캘린더 날짜 비교와 시간 표시는 동일하게 KST 기준으로 맞춥니다.
  DateTime _toKst(DateTime dateTime) {
    return dateTime.toUtc().add(const Duration(hours: 9));
  }

  List<CalendarSchedule> _calendarSchedulesForDay(
    DateTime day,
    List<CalendarSchedule> schedules,
  ) {
    final targetDay = _dateKey(day);

    return schedules.where((schedule) {
      final startDay = _dateKey(_toKst(schedule.startsAt));
      final endDay = _dateKey(_toKst(schedule.endsAt));

      return !targetDay.isBefore(startDay) && !targetDay.isAfter(endDay);
    }).toList(growable: false);
  }

  bool _hasSchedule(
    DateTime day,
    List<CalendarSchedule> schedules,
  ) {
    return _calendarSchedulesForDay(day, schedules).isNotEmpty;
  }

  String? _labelForDay(
    DateTime day,
    List<CalendarSchedule> schedules,
  ) {
    final daySchedules = _calendarSchedulesForDay(day, schedules);

    if (daySchedules.isEmpty) {
      return null;
    }

    // 백엔드가 startsAt ASC로 반환하므로 첫 번째 일정이
    // 해당 날짜에서 가장 상단에 노출할 일정입니다.
    return _shortCalendarLabel(daySchedules.first.title);
  }

  String _shortCalendarLabel(String title) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      return '-';
    }

    final runes = trimmedTitle.runes.toList(growable: false);

    if (runes.length <= 4) {
      return trimmedTitle;
    }

    return '${String.fromCharCodes(runes.take(4))}…';
  }

  /// 현재 두 Calendar API에는 공휴일 정보가 없으므로
  /// 우선 기존 UI 규칙인 일요일만 공휴일로 처리합니다.
  bool _isHoliday(DateTime day) {
    return day.weekday == DateTime.sunday;
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

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _formatScheduleTimeRange(DateSchedule schedule) {
    final startsAt = _toKst(schedule.startsAt);
    final endsAt = _toKst(schedule.endsAt);

    final startDate = _formatScheduleDate(startsAt);
    final endDate = _formatScheduleDate(endsAt);

    if (startDate == endDate) {
      return '$startDate ${_formatTime(startsAt)} - ${_formatTime(endsAt)}';
    }

    return '$startDate ${_formatTime(startsAt)} - '
        '$endDate ${_formatTime(endsAt)}';
  }

  @override
  Widget build(BuildContext context) {
    final calState = ref.watch(calMainProvider);
    final locationCache = ref.watch(locationDetailCacheProvider);
    final selectedSchedules = calState.selectedDateSchedules;
    final isInitialLoading =
        _isBootstrapping ||
        ((!calState.hasLoadedMonthOnce || !calState.hasLoadedDateOnce) &&
            (calState.isMonthLoading || calState.isDateLoading));

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
        child: isInitialLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
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
                  hasSchedule: (day) => _hasSchedule(
                    day,
                    calState.monthSchedules,
                  ),
                  isHoliday: _isHoliday,
                  labelForDay: (day) => _labelForDay(
                    day,
                    calState.monthSchedules,
                  ),
                  onDaySelected: _handleDaySelected,
                  onPageChanged: _handlePageChanged,
                ),

                if (calState.monthError != null) ...[
                  const SizedBox(height: AppSpacing.x8),
                  _buildInlineError(
                    context,
                    message: calState.monthError!,
                    onRetry: () {
                      ref.read(calMainProvider.notifier).loadMonth(
                        year: _focusedDay.year,
                        month: _focusedDay.month,
                        force: true,
                      );
                    },
                  ),
                ],

                const SizedBox(height: AppSpacing.x20),

                Text(
                  _formatSelectedDate(_selectedDay),
                  style: FontStyles.semi16.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),

                const SizedBox(height: AppSpacing.x20),

                if (calState.isDateLoading)
                  _buildScheduleLoading(context)
                else if (calState.dateError != null)
                  _buildInlineError(
                    context,
                    message: calState.dateError!,
                    onRetry: () {
                      ref.read(calMainProvider.notifier).loadDate(
                        day: _selectedDay,
                        force: true,
                      );
                    },
                  )
                else if (selectedSchedules.isEmpty)
                  _buildEmptySchedule(context)
                else
                  _buildScheduleList(selectedSchedules, locationCache),
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

  Widget _buildScheduleLoading(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 80,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildInlineError(
    BuildContext context, {
    required String message,
    required VoidCallback onRetry,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: FontStyles.reg14.copyWith(
              color: context.colors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
          TextButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
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

  String _locationText(
    int? locationId,
    Map<int, LocationData> locationCache,
  ) {
    if (locationId == null) {
      return '장소 미등록';
    }

    final location = locationCache[locationId];
    final name = location?.locationName?.trim();

    return name == null || name.isEmpty ? '장소 ID $locationId' : name;
  }

  Widget _buildScheduleList(
    List<DateSchedule> schedules,
    Map<int, LocationData> locationCache,
  ) {
    return Column(
      children: List.generate(schedules.length, (index) {
        final schedule = schedules[index];
        final isLastItem = index == schedules.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLastItem ? 0 : AppSpacing.x30),
          child: ScheduleListItem(
            titleText: schedule.title,
            locationText: _locationText(schedule.locationId, locationCache),
            timeText: _formatScheduleTimeRange(schedule),
            scheduleType: ScheduleType.mine,
            onTap: () {
              debugPrint('scheduleId=${schedule.scheduleId} 일정 선택');
              _goToCalDetailPage(schedule.scheduleId);
            },
          ),
        );
      }),
    );
  }
}
