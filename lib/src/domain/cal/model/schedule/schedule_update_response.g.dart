// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleUpdateResponse _$ScheduleUpdateResponseFromJson(
  Map<String, dynamic> json,
) => _ScheduleUpdateResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: ScheduleWriteData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleUpdateResponseToJson(
  _ScheduleUpdateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};
