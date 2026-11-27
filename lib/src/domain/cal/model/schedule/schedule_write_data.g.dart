// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_write_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleWriteData _$ScheduleWriteDataFromJson(Map<String, dynamic> json) =>
    _ScheduleWriteData(
      scheduleId: (json['scheduleId'] as num).toInt(),
      title: json['title'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      locationId: (json['locationId'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ScheduleWriteDataToJson(_ScheduleWriteData instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'title': instance.title,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'locationId': instance.locationId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
