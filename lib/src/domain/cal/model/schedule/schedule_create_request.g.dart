// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleCreateRequest _$ScheduleCreateRequestFromJson(
  Map<String, dynamic> json,
) => _ScheduleCreateRequest(
  locationId: (json['locationId'] as num?)?.toInt(),
  title: json['title'] as String,
  content: json['content'] as String?,
  startsAt: const KstDateTimeConverter().fromJson(json['startsAt'] as String),
  endsAt: const KstDateTimeConverter().fromJson(json['endsAt'] as String),
  participantUserIds:
      (json['participantUserIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  musics:
      (json['musics'] as List<dynamic>?)
          ?.map(
            (e) =>
                ScheduleCreateMusicRequest.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ScheduleCreateMusicRequest>[],
);

Map<String, dynamic> _$ScheduleCreateRequestToJson(
  _ScheduleCreateRequest instance,
) => <String, dynamic>{
  'locationId': instance.locationId,
  'title': instance.title,
  'content': instance.content,
  'startsAt': const KstDateTimeConverter().toJson(instance.startsAt),
  'endsAt': const KstDateTimeConverter().toJson(instance.endsAt),
  'participantUserIds': instance.participantUserIds,
  'musics': instance.musics,
};

_ScheduleCreateMusicRequest _$ScheduleCreateMusicRequestFromJson(
  Map<String, dynamic> json,
) => _ScheduleCreateMusicRequest(
  musicTitle: json['musicTitle'] as String?,
  musicArtist: json['musicArtist'] as String?,
  musicPreviewUrl: json['musicPreviewUrl'] as String?,
);

Map<String, dynamic> _$ScheduleCreateMusicRequestToJson(
  _ScheduleCreateMusicRequest instance,
) => <String, dynamic>{
  'musicTitle': instance.musicTitle,
  'musicArtist': instance.musicArtist,
  'musicPreviewUrl': instance.musicPreviewUrl,
};
