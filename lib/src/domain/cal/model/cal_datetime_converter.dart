import 'package:freezed_annotation/freezed_annotation.dart';

/// Calendar API는 백엔드에서 OffsetDateTime(+09:00)을 사용합니다.
///
/// 서버에서 받은 offset datetime은 DateTime.parse로 읽고,
/// 서버로 보낼 때는 한국 시간(+09:00) offset이 포함된 문자열로 직렬화합니다.
class KstDateTimeConverter implements JsonConverter<DateTime, String> {
  const KstDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime value) {
    final kst = value.isUtc
        ? value.add(const Duration(hours: 9))
        : value;

    String twoDigits(int number) => number.toString().padLeft(2, '0');
    String threeDigits(int number) => number.toString().padLeft(3, '0');

    return '${kst.year.toString().padLeft(4, '0')}-'
        '${twoDigits(kst.month)}-'
        '${twoDigits(kst.day)}T'
        '${twoDigits(kst.hour)}:'
        '${twoDigits(kst.minute)}:'
        '${twoDigits(kst.second)}.'
        '${threeDigits(kst.millisecond)}+09:00';
  }
}
