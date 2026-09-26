// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_create_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleCreateResponse _$ScheduleCreateResponseFromJson(
  Map<String, dynamic> json,
) => _ScheduleCreateResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: ScheduleWriteData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleCreateResponseToJson(
  _ScheduleCreateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
