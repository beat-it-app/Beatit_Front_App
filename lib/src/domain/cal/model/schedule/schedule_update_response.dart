import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_write_data.dart';

part 'schedule_update_response.freezed.dart';
part 'schedule_update_response.g.dart';

@freezed
abstract class ScheduleUpdateResponse with _$ScheduleUpdateResponse {
  const factory ScheduleUpdateResponse({
    required bool success,
    required int status,
    required String message,
    required ScheduleWriteData data,
  }) = _ScheduleUpdateResponse;

  factory ScheduleUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleUpdateResponseFromJson(json);
}
