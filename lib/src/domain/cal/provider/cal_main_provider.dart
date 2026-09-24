import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/api/cal_api.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_date_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_month_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';

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
    );
  }
}

class CalMainNotifier extends Notifier<CalMainState> {
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
    final isAlreadyLoaded =
        state.loadedYear == year &&
        state.loadedMonth == month &&
        state.monthError == null;

    if (!force && isAlreadyLoaded) {
      return;
    }

    final requestId = ++_monthRequestId;

    state = state.copyWith(
      isMonthLoading: true,
      clearMonthError: true,
    );

    try {
      final response = await ref
          .read(calApiProvider)
          .getCalendarSchedules(year: year, month: month);

      if (requestId != _monthRequestId) {
        return;
      }

      state = state.copyWith(
        monthSchedules: response.data.items,
        isMonthLoading: false,
        loadedYear: year,
        loadedMonth: month,
        clearMonthError: true,
      );
    } catch (error) {
      if (requestId != _monthRequestId) {
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
    final isAlreadyLoaded =
        state.loadedDate == targetDay && state.dateError == null;

    if (!force && isAlreadyLoaded) {
      return;
    }

    final requestId = ++_dateRequestId;

    state = state.copyWith(
      selectedDateSchedules: const <DateSchedule>[],
      isDateLoading: true,
      loadedDate: targetDay,
      clearDateError: true,
    );

    try {
      final response = await ref.read(calApiProvider).getDateSchedules(
        year: targetDay.year,
        month: targetDay.month,
        date: targetDay.day,
      );

      if (requestId != _dateRequestId) {
        return;
      }

      state = state.copyWith(
        selectedDateSchedules: response.data.items,
        isDateLoading: false,
        clearDateError: true,
      );
    } catch (error) {
      if (requestId != _dateRequestId) {
        return;
      }

      state = state.copyWith(
        isDateLoading: false,
        dateError: _getErrorMessage(error),
      );
    }
  }

  String _getErrorMessage(Object error) {
    if (error is CalApiException) {
      return error.message;
    }

    return '일정을 불러오는 중 오류가 발생했습니다.';
  }
}
