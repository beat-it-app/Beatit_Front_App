// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetit_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetitCreateRequest _$MeetitCreateRequestFromJson(Map<String, dynamic> json) =>
    _MeetitCreateRequest(
      title: json['title'] as String,
      candidateDates: (json['candidateDates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      dateOnly: json['dateOnly'] as bool,
      participantUserIds: (json['participantUserIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MeetitCreateRequestToJson(
  _MeetitCreateRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'candidateDates': instance.candidateDates,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'dateOnly': instance.dateOnly,
  'participantUserIds': instance.participantUserIds,
};
