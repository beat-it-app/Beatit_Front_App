// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleDetailResponse _$ScheduleDetailResponseFromJson(
  Map<String, dynamic> json,
) => _ScheduleDetailResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: ScheduleDetailData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleDetailResponseToJson(
  _ScheduleDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_ScheduleDetailData _$ScheduleDetailDataFromJson(
  Map<String, dynamic> json,
) => _ScheduleDetailData(
  scheduleId: (json['scheduleId'] as num).toInt(),
  teamId: (json['teamId'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  locationId: (json['locationId'] as num?)?.toInt(),
  title: json['title'] as String,
  content: json['content'] as String?,
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map(
            (e) =>
                ScheduleDetailParticipant.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ScheduleDetailParticipant>[],
  files:
      (json['files'] as List<dynamic>?)
          ?.map((e) => ScheduleDetailFile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ScheduleDetailFile>[],
  musics:
      (json['musics'] as List<dynamic>?)
          ?.map((e) => ScheduleDetailMusic.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ScheduleDetailMusic>[],
);

Map<String, dynamic> _$ScheduleDetailDataToJson(_ScheduleDetailData instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'teamId': instance.teamId,
      'userId': instance.userId,
      'locationId': instance.locationId,
      'title': instance.title,
      'content': instance.content,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'participants': instance.participants,
      'files': instance.files,
      'musics': instance.musics,
    };

_ScheduleDetailParticipant _$ScheduleDetailParticipantFromJson(
  Map<String, dynamic> json,
) => _ScheduleDetailParticipant(
  scheduleParticipantId: (json['scheduleParticipantId'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$ScheduleDetailParticipantToJson(
  _ScheduleDetailParticipant instance,
) => <String, dynamic>{
  'scheduleParticipantId': instance.scheduleParticipantId,
  'userId': instance.userId,
};

_ScheduleDetailFile _$ScheduleDetailFileFromJson(Map<String, dynamic> json) =>
    _ScheduleDetailFile(
      fileId: (json['fileId'] as num).toInt(),
      originalFileName: json['originalFileName'] as String,
      cdnUrl: json['cdnUrl'] as String,
    );

Map<String, dynamic> _$ScheduleDetailFileToJson(_ScheduleDetailFile instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'originalFileName': instance.originalFileName,
      'cdnUrl': instance.cdnUrl,
    };

_ScheduleDetailMusic _$ScheduleDetailMusicFromJson(Map<String, dynamic> json) =>
    _ScheduleDetailMusic(
      musicId: (json['musicId'] as num).toInt(),
      musicTitle: json['musicTitle'] as String?,
      musicArtist: json['musicArtist'] as String?,
      musicPreviewUrl: json['musicPreviewUrl'] as String?,
    );

Map<String, dynamic> _$ScheduleDetailMusicToJson(
  _ScheduleDetailMusic instance,
) => <String, dynamic>{
  'musicId': instance.musicId,
  'musicTitle': instance.musicTitle,
  'musicArtist': instance.musicArtist,
  'musicPreviewUrl': instance.musicPreviewUrl,
};
