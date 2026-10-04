import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/api/cal_api.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_date_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_month_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';

/// 화면이 살아있는 동안 이미 조회한 월/날짜를 재사용합니다.
/// 생성·수정·삭제 후에는 호출부에서 force=true로 필요한 범위만 갱신합니다.
final calMainProvider =
    NotifierProvider.autoDispose<CalMainNotifier, CalMainState>(
      CalMainNotifier.new,
    );

class CalMainState {
  const CalMainState({
    this.monthSchedules = const <CalendarSchedule>[],
    this.selectedDateSchedules = const <DateSchedule>[],
    this.isMonthLoading = false,
    this.isDateLoading = false,
    this.monthError,
    this.dateError,
    this.loadedYear,
    this.loadedMonth,
    this.loadedDate,
    this.hasLoadedMonthOnce = false,
    this.hasLoadedDateOnce = false,
  });

  final List<CalendarSchedule> monthSchedules;
  final List<DateSchedule> selectedDateSchedules;

  final bool isMonthLoading;
  final bool isDateLoading;

  final String? monthError;
  final String? dateError;

  final int? loadedYear;
  final int? loadedMonth;
  final DateTime? loadedDate;
  final bool hasLoadedMonthOnce;
  final bool hasLoadedDateOnce;

  CalMainState copyWith({
    List<CalendarSchedule>? monthSchedules,
    List<DateSchedule>? selectedDateSchedules,
    bool? isMonthLoading,
    bool? isDateLoading,
    String? monthError,
    String? dateError,
    bool clearMonthError = false,
    bool clearDateError = false,
    int? loadedYear,
    int? loadedMonth,
    DateTime? loadedDate,
    bool? hasLoadedMonthOnce,
    bool? hasLoadedDateOnce,
  }) {
    return CalMainState(
      monthSchedules: monthSchedules ?? this.monthSchedules,
      selectedDateSchedules:
          selectedDateSchedules ?? this.selectedDateSchedules,
      isMonthLoading: isMonthLoading ?? this.isMonthLoading,
      isDateLoading: isDateLoading ?? this.isDateLoading,
      monthError: clearMonthError ? null : monthError ?? this.monthError,
      dateError: clearDateError ? null : dateError ?? this.dateError,
      loadedYear: loadedYear ?? this.loadedYear,
      loadedMonth: loadedMonth ?? this.loadedMonth,
      loadedDate: loadedDate ?? this.loadedDate,
      hasLoadedMonthOnce: hasLoadedMonthOnce ?? this.hasLoadedMonthOnce,
      hasLoadedDateOnce: hasLoadedDateOnce ?? this.hasLoadedDateOnce,
    );
  }
}

class CalMainNotifier extends Notifier<CalMainState> {
  final Map<String, List<CalendarSchedule>> _monthCache =
      <String, List<CalendarSchedule>>{};
  final Map<DateTime, List<DateSchedule>> _dateCache =
      <DateTime, List<DateSchedule>>{};
  final Map<String, Future<List<CalendarSchedule>>> _monthInFlight =
      <String, Future<List<CalendarSchedule>>>{};
  final Map<DateTime, Future<List<DateSchedule>>> _dateInFlight =
      <DateTime, Future<List<DateSchedule>>>{};

  int _monthRequestId = 0;
  int _dateRequestId = 0;

  @override
  CalMainState build() {
    return const CalMainState();
  }

  Future<void> loadMonth({
    required int year,
    required int month,
    bool force = false,
  }) async {
    final key = _monthKey(year, month);

    if (!force) {
      final cached = _monthCache[key];
      if (cached != null) {
        state = state.copyWith(
          monthSchedules: cached,
          isMonthLoading: false,
          loadedYear: year,
          loadedMonth: month,
          hasLoadedMonthOnce: true,
          clearMonthError: true,
        );
        return;
      }

      if (state.isMonthLoading &&
          state.loadedYear == year &&
          state.loadedMonth == month) {
        return;
      }
    }

    final requestId = ++_monthRequestId;

    state = state.copyWith(
      isMonthLoading: true,
      loadedYear: year,
      loadedMonth: month,
      clearMonthError: true,
    );

    try {
      final items = await _getMonthItems(
        year: year,
        month: month,
        force: force,
      );

      if (!ref.mounted || requestId != _monthRequestId) {
        return;
      }

      state = state.copyWith(
        monthSchedules: items,
        isMonthLoading: false,
        loadedYear: year,
        loadedMonth: month,
        hasLoadedMonthOnce: true,
        clearMonthError: true,
      );
    } catch (error) {
      if (!ref.mounted || requestId != _monthRequestId) {
        return;
      }

      state = state.copyWith(
        isMonthLoading: false,
        monthError: _getErrorMessage(error),
      );
    }
  }

  Future<void> loadDate({
    required DateTime day,
    bool force = false,
  }) async {
    final targetDay = DateTime(day.year, day.month, day.day);

    if (!force) {
      final cached = _dateCache[targetDay];
      if (cached != null) {
        state = state.copyWith(
          selectedDateSchedules: cached,
          isDateLoading: false,
          loadedDate: targetDay,
          hasLoadedDateOnce: true,
          clearDateError: true,
        );
        return;
      }

      if (state.isDateLoading && state.loadedDate == targetDay) {
        return;
      }
    }

    final requestId = ++_dateRequestId;

    state = state.copyWith(
      selectedDateSchedules: const <DateSchedule>[],
      isDateLoading: true,
      loadedDate: targetDay,
      clearDateError: true,
    );

    try {
      // 일정과 각 일정의 장소 상세가 모두 준비되어야 날짜 로딩을 종료합니다.
      final items = await _getDateItems(targetDay, force: force);

      if (!ref.mounted || requestId != _dateRequestId) {
        return;
      }

      state = state.copyWith(
        selectedDateSchedules: items,
        isDateLoading: false,
        loadedDate: targetDay,
        hasLoadedDateOnce: true,
        clearDateError: true,
      );
    } catch (error) {
      if (!ref.mounted || requestId != _dateRequestId) {
        return;
      }

      state = state.copyWith(
        isDateLoading: false,
        dateError: _getErrorMessage(error),
      );
    }
  }

  Future<List<CalendarSchedule>> _getMonthItems({
    required int year,
    required int month,
    required bool force,
  }) async {
    final key = _monthKey(year, month);

    if (!force) {
      final cached = _monthCache[key];
      if (cached != null) {
        return cached;
      }

      final pending = _monthInFlight[key];
      if (pending != null) {
        return pending;
      }
    }

    final future = _fetchMonth(year: year, month: month);
    _monthInFlight[key] = future;

    try {
      final items = await future;
      _monthCache[key] = items;
      return items;
    } finally {
      if (identical(_monthInFlight[key], future)) {
        _monthInFlight.remove(key);
      }
    }
  }

  Future<List<CalendarSchedule>> _fetchMonth({
    required int year,
    required int month,
  }) async {
    final api = ref.read(calApiProvider);
    final response = await api.getCalendarSchedules(year: year, month: month);

    return response.data.items;
  }

  Future<List<DateSchedule>> _getDateItems(
    DateTime targetDay, {
    required bool force,
  }) async {
    if (!force) {
      final cached = _dateCache[targetDay];
      if (cached != null) {
        return cached;
      }

      final pending = _dateInFlight[targetDay];
      if (pending != null) {
        return pending;
      }
    }

    final future = _fetchDateReady(targetDay);
    _dateInFlight[targetDay] = future;

    try {
      final items = await future;
      _dateCache[targetDay] = items;
      return items;
    } finally {
      if (identical(_dateInFlight[targetDay], future)) {
        _dateInFlight.remove(targetDay);
      }
    }
  }

  Future<List<DateSchedule>> _fetchDateReady(DateTime targetDay) async {
    final api = ref.read(calApiProvider);
    final locationCache = ref.read(locationDetailCacheProvider.notifier);
    final response = await api.getDateSchedules(
      year: targetDay.year,
      month: targetDay.month,
      date: targetDay.day,
    );

    final items = response.data.items;
    final locationIds = items
        .map((schedule) => schedule.locationId)
        .whereType<int>();

    await locationCache.loadLocations(locationIds);

    return items;
  }

  void removeScheduleLocally(int scheduleId) {
    _monthCache.updateAll(
      (_, schedules) => schedules
          .where((schedule) => schedule.scheduleId != scheduleId)
          .toList(growable: false),
    );
    _dateCache.updateAll(
      (_, schedules) => schedules
          .where((schedule) => schedule.scheduleId != scheduleId)
          .toList(growable: false),
    );

    state = state.copyWith(
      monthSchedules: state.monthSchedules
          .where((schedule) => schedule.scheduleId != scheduleId)
          .toList(growable: false),
      selectedDateSchedules: state.selectedDateSchedules
          .where((schedule) => schedule.scheduleId != scheduleId)
          .toList(growable: false),
    );
  }

  String _monthKey(int year, int month) => '$year-${month.toString().padLeft(2, '0')}';

  String _getErrorMessage(Object error) {
    if (error is CalApiException) {
      return error.message;
    }

    return '일정을 불러오는 중 오류가 발생했습니다.';
  }
}
