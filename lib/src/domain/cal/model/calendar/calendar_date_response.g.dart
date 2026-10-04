// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_date_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarDateResponse _$CalendarDateResponseFromJson(
  Map<String, dynamic> json,
) => _CalendarDateResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CalendarDateData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CalendarDateResponseToJson(
  _CalendarDateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_CalendarDateData _$CalendarDateDataFromJson(Map<String, dynamic> json) =>
    _CalendarDateData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => DateSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DateSchedule>[],
    );

Map<String, dynamic> _$CalendarDateDataToJson(_CalendarDateData instance) =>
    <String, dynamic>{'items': instance.items};

_DateSchedule _$DateScheduleFromJson(Map<String, dynamic> json) =>
    _DateSchedule(
      scheduleId: (json['scheduleId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      locationId: (json['locationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DateScheduleToJson(_DateSchedule instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'title': instance.title,
      'content': instance.content,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'locationId': instance.locationId,
    };
