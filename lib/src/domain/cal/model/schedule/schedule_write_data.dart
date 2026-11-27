import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_write_data.freezed.dart';
part 'schedule_write_data.g.dart';

@freezed
abstract class ScheduleWriteData with _$ScheduleWriteData {
  const factory ScheduleWriteData({
    required int scheduleId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    int? locationId,
    required DateTime createdAt,
  }) = _ScheduleWriteData;

  factory ScheduleWriteData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleWriteDataFromJson(json);
}
