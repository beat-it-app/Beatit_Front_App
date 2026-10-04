import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_date_response.freezed.dart';
part 'calendar_date_response.g.dart';

@freezed
abstract class CalendarDateResponse with _$CalendarDateResponse {
  const factory CalendarDateResponse({
    required bool success,
    required int status,
    required String message,
    required CalendarDateData data,
  }) = _CalendarDateResponse;

  factory CalendarDateResponse.fromJson(Map<String, dynamic> json) =>
      _$CalendarDateResponseFromJson(json);
}

@freezed
abstract class CalendarDateData with _$CalendarDateData {
  const factory CalendarDateData({
    @Default(<DateSchedule>[]) List<DateSchedule> items,
  }) = _CalendarDateData;

  factory CalendarDateData.fromJson(Map<String, dynamic> json) =>
      _$CalendarDateDataFromJson(json);
}

@freezed
abstract class DateSchedule with _$DateSchedule {
  const factory DateSchedule({
    required int scheduleId,
    required String title,
    required String content,
    required DateTime startsAt,
    required DateTime endsAt,
    int? locationId,
  }) = _DateSchedule;

  factory DateSchedule.fromJson(Map<String, dynamic> json) =>
      _$DateScheduleFromJson(json);
}
