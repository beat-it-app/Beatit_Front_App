import 'package:beatit_front_app/src/core/utils/app_date_time_formatter.dart';

/// 공지·투표·밋잇의 화면 표시용 날짜. 요일을 함께 출력하지 않습니다.
/// 서버 API의 날짜나 시간 값은 변경하지 않습니다.
String formatPostDate(DateTime value) => AppDateTimeFormatter.formatDate(value);

String formatPostTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:'
    '${minute.toString().padLeft(2, '0')}';

String formatPostDateTime(DateTime value) {
  final date = value.toLocal();
  return '${formatPostDate(date)} ${formatPostTime(date.hour, date.minute)}';
}
