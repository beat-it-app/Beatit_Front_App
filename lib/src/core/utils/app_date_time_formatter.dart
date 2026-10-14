/// Formats dates and clock times shown in the app UI.
///
/// Formatting is for display only; keep DateTime values for API requests,
/// sorting, comparisons, and playback durations.
abstract final class AppDateTimeFormatter {
  /// Example: 2026. 1. 2 (no leading zeroes, space after each period).
  static String formatDate(DateTime value) {
    final local = value.toLocal();
    return '${local.year}. ${local.month}. ${local.day}';
  }

  /// 24-hour clock, e.g. 7:05 or 19:05.
  static String formatTime(DateTime value) {
    final local = value.toLocal();
    return '${local.hour}:${local.minute.toString().padLeft(2, '0')}';
  }

  /// 12-hour clock with Korean period, e.g. 오전 7:05 / 오후 7:05.
  static String formatTimeWithPeriod(DateTime value) {
    final local = value.toLocal();
    final period = local.hour < 12 ? '오전' : '오후';
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '$period $hour12:$minute';
  }
}
