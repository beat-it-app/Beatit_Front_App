// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleUpdateRequest _$ScheduleUpdateRequestFromJson(
  Map<String, dynamic> json,
) => _ScheduleUpdateRequest(
  locationId: (json['locationId'] as num?)?.toInt(),
  title: json['title'] as String,
  content: json['content'] as String?,
  startsAt: const KstDateTimeConverter().fromJson(json['startsAt'] as String),
  endsAt: const KstDateTimeConverter().fromJson(json['endsAt'] as String),
  participantUserIds: (json['participantUserIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  musics: (json['musics'] as List<dynamic>?)
      ?.map(
        (e) => ScheduleUpdateMusicRequest.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  retainMusicIds: (json['retainMusicIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  retainFileIds: (json['retainFileIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ScheduleUpdateRequestToJson(
  _ScheduleUpdateRequest instance,
) => <String, dynamic>{
  'locationId': instance.locationId,
  'title': instance.title,
  'content': instance.content,
  'startsAt': const KstDateTimeConverter().toJson(instance.startsAt),
  'endsAt': const KstDateTimeConverter().toJson(instance.endsAt),
  'participantUserIds': instance.participantUserIds,
  'musics': instance.musics,
  'retainMusicIds': instance.retainMusicIds,
  'retainFileIds': instance.retainFileIds,
};

_ScheduleUpdateMusicRequest _$ScheduleUpdateMusicRequestFromJson(
  Map<String, dynamic> json,
) => _ScheduleUpdateMusicRequest(
  musicTitle: json['musicTitle'] as String,
  musicArtist: json['musicArtist'] as String,
  musicPreviewUrl: json['musicPreviewUrl'] as String?,
);

Map<String, dynamic> _$ScheduleUpdateMusicRequestToJson(
  _ScheduleUpdateMusicRequest instance,
) => <String, dynamic>{
  'musicTitle': instance.musicTitle,
  'musicArtist': instance.musicArtist,
  'musicPreviewUrl': instance.musicPreviewUrl,
};
