import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_month_response.freezed.dart';
part 'calendar_month_response.g.dart';

@freezed
abstract class CalendarMonthResponse with _$CalendarMonthResponse {
  const factory CalendarMonthResponse({
    required bool success,
    required int status,
    required String message,
    required CalendarMonthData data,
  }) = _CalendarMonthResponse;

  factory CalendarMonthResponse.fromJson(Map<String, dynamic> json) =>
      _$CalendarMonthResponseFromJson(json);
}

@freezed
abstract class CalendarMonthData with _$CalendarMonthData {
  const factory CalendarMonthData({
    @Default(<CalendarSchedule>[]) List<CalendarSchedule> items,
  }) = _CalendarMonthData;

  factory CalendarMonthData.fromJson(Map<String, dynamic> json) =>
      _$CalendarMonthDataFromJson(json);
}

@freezed
abstract class CalendarSchedule with _$CalendarSchedule {
  const factory CalendarSchedule({
    required int scheduleId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
  }) = _CalendarSchedule;

  factory CalendarSchedule.fromJson(Map<String, dynamic> json) =>
      _$CalendarScheduleFromJson(json);
}
