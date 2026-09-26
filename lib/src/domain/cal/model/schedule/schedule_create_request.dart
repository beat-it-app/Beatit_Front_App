import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:beatit_front_app/src/domain/cal/model/cal_datetime_converter.dart';

part 'schedule_create_request.freezed.dart';
part 'schedule_create_request.g.dart';

@freezed
abstract class ScheduleCreateRequest with _$ScheduleCreateRequest {
  const factory ScheduleCreateRequest({
    int? locationId,
    required String title,
    String? content,
    @KstDateTimeConverter() required DateTime startsAt,
    @KstDateTimeConverter() required DateTime endsAt,
    @Default(<int>[]) List<int> participantUserIds,
    @Default(<ScheduleCreateMusicRequest>[]) List<ScheduleCreateMusicRequest> musics,
  }) = _ScheduleCreateRequest;

  factory ScheduleCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleCreateRequestFromJson(json);
}

@freezed
abstract class ScheduleCreateMusicRequest with _$ScheduleCreateMusicRequest {
  const factory ScheduleCreateMusicRequest({
    String? musicTitle,
    String? musicArtist,
    String? musicPreviewUrl,
  }) = _ScheduleCreateMusicRequest;

  factory ScheduleCreateMusicRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleCreateMusicRequestFromJson(json);
}
