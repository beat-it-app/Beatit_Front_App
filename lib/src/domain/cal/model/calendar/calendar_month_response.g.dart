// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_month_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarMonthResponse _$CalendarMonthResponseFromJson(
  Map<String, dynamic> json,
) => _CalendarMonthResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CalendarMonthData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CalendarMonthResponseToJson(
  _CalendarMonthResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_CalendarMonthData _$CalendarMonthDataFromJson(Map<String, dynamic> json) =>
    _CalendarMonthData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CalendarSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CalendarSchedule>[],
    );

Map<String, dynamic> _$CalendarMonthDataToJson(_CalendarMonthData instance) =>
    <String, dynamic>{'items': instance.items};

_CalendarSchedule _$CalendarScheduleFromJson(Map<String, dynamic> json) =>
    _CalendarSchedule(
      scheduleId: (json['scheduleId'] as num).toInt(),
      title: json['title'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
    );

Map<String, dynamic> _$CalendarScheduleToJson(_CalendarSchedule instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'title': instance.title,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
    };
