import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_detail_response.freezed.dart';
part 'schedule_detail_response.g.dart';

@freezed
abstract class ScheduleDetailResponse with _$ScheduleDetailResponse {
  const factory ScheduleDetailResponse({
    required bool success,
    required int status,
    required String message,
    required ScheduleDetailData data,
  }) = _ScheduleDetailResponse;

  factory ScheduleDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailResponseFromJson(json);
}

@freezed
abstract class ScheduleDetailData with _$ScheduleDetailData {
  const factory ScheduleDetailData({
    required int scheduleId,
    required int teamId,
    required int userId,
    int? locationId,
    required String title,
    String? content,
    required DateTime startsAt,
    required DateTime endsAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<ScheduleDetailParticipant>[]) List<ScheduleDetailParticipant> participants,
    @Default(<ScheduleDetailFile>[]) List<ScheduleDetailFile> files,

    /// 현재 첨부된 백엔드 ScheduleDetailResponse에는 아직 없는 필드입니다.
    /// 백엔드가 상세 조회 응답에 musics를 추가하면 프론트 수정 없이 표시할 수 있도록
    /// 기본값을 빈 목록으로 둡니다.
    @Default(<ScheduleDetailMusic>[]) List<ScheduleDetailMusic> musics,
  }) = _ScheduleDetailData;

  factory ScheduleDetailData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailDataFromJson(json);
}

@freezed
abstract class ScheduleDetailParticipant with _$ScheduleDetailParticipant {
  const factory ScheduleDetailParticipant({
    required int scheduleParticipantId,
    required int userId,
  }) = _ScheduleDetailParticipant;

  factory ScheduleDetailParticipant.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailParticipantFromJson(json);
}

@freezed
abstract class ScheduleDetailFile with _$ScheduleDetailFile {
  const factory ScheduleDetailFile({
    required int fileId,
    required String originalFileName,
    required String cdnUrl,
  }) = _ScheduleDetailFile;

  factory ScheduleDetailFile.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailFileFromJson(json);
}

@freezed
abstract class ScheduleDetailMusic with _$ScheduleDetailMusic {
  const factory ScheduleDetailMusic({
    required int musicId,
    String? musicTitle,
    String? musicArtist,
    String? musicPreviewUrl,
  }) = _ScheduleDetailMusic;

  factory ScheduleDetailMusic.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailMusicFromJson(json);
}
