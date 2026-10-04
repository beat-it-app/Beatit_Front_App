import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:beatit_front_app/src/domain/cal/model/cal_datetime_converter.dart';

part 'schedule_update_request.freezed.dart';
part 'schedule_update_request.g.dart';

@freezed
abstract class ScheduleUpdateRequest with _$ScheduleUpdateRequest {
  const factory ScheduleUpdateRequest({
    int? locationId,
    required String title,
    String? content,
    @KstDateTimeConverter() required DateTime startsAt,
    @KstDateTimeConverter() required DateTime endsAt,

    /// null이면 기존 참여자를 유지합니다.
    List<int>? participantUserIds,

    /// 새로 추가할 음원입니다.
    List<ScheduleUpdateMusicRequest>? musics,

    /// 기존 음원 중 유지할 ID 목록입니다.
    /// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 음원이 삭제됩니다.
    List<int>? retainMusicIds,

    /// 기존 파일 중 유지할 ID 목록입니다.
    /// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 파일이 삭제됩니다.
    List<int>? retainFileIds,
  }) = _ScheduleUpdateRequest;

  factory ScheduleUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleUpdateRequestFromJson(json);
}

@freezed
abstract class ScheduleUpdateMusicRequest with _$ScheduleUpdateMusicRequest {
  const factory ScheduleUpdateMusicRequest({
    required String musicTitle,
    required String musicArtist,
    String? musicPreviewUrl,
  }) = _ScheduleUpdateMusicRequest;

  factory ScheduleUpdateMusicRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleUpdateMusicRequestFromJson(json);
}
