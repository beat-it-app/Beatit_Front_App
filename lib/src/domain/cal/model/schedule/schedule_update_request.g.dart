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
  startsAt: _$JsonConverterFromJson<String, DateTime>(
    json['startsAt'],
    const KstDateTimeConverter().fromJson,
  ),
  endsAt: _$JsonConverterFromJson<String, DateTime>(
    json['endsAt'],
    const KstDateTimeConverter().fromJson,
  ),
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
  'startsAt': _$JsonConverterToJson<String, DateTime>(
    instance.startsAt,
    const KstDateTimeConverter().toJson,
  ),
  'endsAt': _$JsonConverterToJson<String, DateTime>(
    instance.endsAt,
    const KstDateTimeConverter().toJson,
  ),
  'participantUserIds': instance.participantUserIds,
  'musics': instance.musics,
  'retainMusicIds': instance.retainMusicIds,
  'retainFileIds': instance.retainFileIds,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

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
