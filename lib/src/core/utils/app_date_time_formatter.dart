/// Formats dates and clock times shown in the app UI.
///
/// Formatting is for display only; keep DateTime values for API requests,
/// sorting, comparisons, and playback durations.
abstract final class AppDateTimeFormatter {
  /// Example: 2026. 1. 2. (no leading zeroes, including the final period).
  static String formatDate(DateTime value) {
    final local = value.toLocal();
    return _dateParts(local);
  }

  static DateTime _kstClock(DateTime value) =>
      value.toUtc().add(const Duration(hours: 9));

  static String _dateParts(DateTime date) =>
      '${date.year}. ${date.month}. ${date.day}.';

  static String _timeParts(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  // 일정에서 오전 12시대는 0:nn 대신 12:nn로 보여줍니다.
  // 시간 비교/저장은 실제 0시로 유지합니다.
  static String _scheduleTimeParts(DateTime time) =>
      '${time.hour == 0 ? 12 : time.hour}:${time.minute.toString().padLeft(2, '0')}';

  static const List<String> _weekdays = <String>[
    '월요일',
    '화요일',
    '수요일',
    '목요일',
    '금요일',
    '토요일',
    '일요일',
  ];

  /// 일정 API의 OffsetDateTime은 항상 한국 시각을 기준으로 표시합니다.
  static String formatKstDateTime(DateTime value) {
    final kst = _kstClock(value);
    return '${_dateParts(kst)} ${_timeParts(kst)}';
  }

  /// 캘린더 목록과 상세에서 동일한 날짜·시간 범위를 표현합니다.
  /// 날짜가 달라지는 일정은 종료 날짜도 함께 표시합니다.
  static String formatScheduleTimeRange(
    DateTime startsAt,
    DateTime endsAt, {
    bool includeWeekday = false,
  }) {
    final start = _kstClock(startsAt);
    final end = _kstClock(endsAt);

    String dateLabel(DateTime date) {
      final formatted = _dateParts(date);
      return includeWeekday
          ? '$formatted ${_weekdays[date.weekday - 1]}'
          : formatted;
    }

    final startLabel = '${dateLabel(start)} ${_scheduleTimeParts(start)}';
    final isSameDate =
        start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    if (isSameDate) {
      return '$startLabel - ${_scheduleTimeParts(end)}';
    }
    return '$startLabel - ${dateLabel(end)} ${_scheduleTimeParts(end)}';
  }

  /// 문자열의 앞 10자리(yyyy-MM-dd)를 [formatDate] 형식으로 바꿉니다.
  /// 시간대 변환은 하지 않으며, 날짜로 읽을 수 없으면 원문을 반환합니다.
  static String formatDateString(String raw) {
    final trimmed = raw.trim();
    final date = trimmed.length >= 10
        ? DateTime.tryParse(trimmed.substring(0, 10))
        : null;
    return date == null ? trimmed : _dateParts(date);
  }

  /// Example: 2026. 1. 2. 9:05
  static String formatDateTime(DateTime value) =>
      '${formatDate(value)} ${formatTime(value)}';

  /// 24-hour clock, e.g. 7:05 or 19:05.
  static String formatTime(DateTime value) => _timeParts(value.toLocal());

  /// [formatTime]과 같은 형식이며, 시·분 값만 있을 때 사용합니다.
  static String formatHourMinute(int hour, int minute) =>
      formatTime(DateTime(2000, 1, 1, hour, minute));

  /// 12-hour clock with Korean period, e.g. 오전 7:05 / 오후 7:05.
  static String formatTimeWithPeriod(DateTime value) {
    final local = value.toLocal();
    final period = local.hour < 12 ? '오전' : '오후';
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '$period $hour12:$minute';
  }
}
