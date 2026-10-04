import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_write_data.dart';

part 'schedule_create_response.freezed.dart';
part 'schedule_create_response.g.dart';

@freezed
abstract class ScheduleCreateResponse with _$ScheduleCreateResponse {
  const factory ScheduleCreateResponse({
    required bool success,
    required int status,
    required String message,
    required ScheduleWriteData data,
  }) = _ScheduleCreateResponse;

  factory ScheduleCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleCreateResponseFromJson(json);
}
