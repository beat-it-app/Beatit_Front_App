/// 공지·투표·밋잇 게시글에서 사용하는 한국어 날짜 및 시간 표기.
/// API 전송 형식은 변경하지 않고 화면에 표시하는 값에만 적용한다.
const _weekdays = <String>[
  '월요일',
  '화요일',
  '수요일',
  '목요일',
  '금요일',
  '토요일',
  '일요일',
];

String formatPostDate(DateTime value) {
  final date = value.toLocal();
  return '${date.year}. ${date.month}. ${date.day}. '
      '${_weekdays[date.weekday - 1]}';
}

String formatPostTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:'
    '${minute.toString().padLeft(2, '0')}';

String formatPostDateTime(DateTime value) {
  final date = value.toLocal();
  return '${formatPostDate(date)} ${formatPostTime(date.hour, date.minute)}';
}