// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlarmListResponse _$AlarmListResponseFromJson(Map<String, dynamic> json) =>
    _AlarmListResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String?,
      data: AlarmPageResponse.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlarmListResponseToJson(_AlarmListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_AlarmPageResponse _$AlarmPageResponseFromJson(Map<String, dynamic> json) =>
    _AlarmPageResponse(
      teamId: (json['teamId'] as num).toInt(),
      teamName: json['teamName'] as String,
      unreadCount: (json['unreadCount'] as num).toInt(),
      hasUnread: json['hasUnread'] as bool,
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      isLast: json['isLast'] as bool,
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map(
                (e) => AlarmNotification.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <AlarmNotification>[],
    );

Map<String, dynamic> _$AlarmPageResponseToJson(_AlarmPageResponse instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'unreadCount': instance.unreadCount,
      'hasUnread': instance.hasUnread,
      'page': instance.page,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'isLast': instance.isLast,
      'notifications': instance.notifications,
    };

_AlarmNotification _$AlarmNotificationFromJson(Map<String, dynamic> json) =>
    _AlarmNotification(
      id: (json['notificationId'] as num).toInt(),
      category: json['category'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      directTo: json['directTo'] as String?,
      targetId: (json['targetId'] as num?)?.toInt(),
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AlarmNotificationToJson(_AlarmNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.id,
      'category': instance.category,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'directTo': instance.directTo,
      'targetId': instance.targetId,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_AlarmActionResponse _$AlarmActionResponseFromJson(Map<String, dynamic> json) =>
    _AlarmActionResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String?,
      data: AlarmClickResponse.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlarmActionResponseToJson(
  _AlarmActionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_AlarmClickResponse _$AlarmClickResponseFromJson(Map<String, dynamic> json) =>
    _AlarmClickResponse(
      notificationId: (json['notificationId'] as num).toInt(),
      targetTeamId: (json['targetTeamId'] as num).toInt(),
      targetTeamName: json['targetTeamName'] as String,
      directTo: json['directTo'] as String?,
      targetId: (json['targetId'] as num?)?.toInt(),
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$AlarmClickResponseToJson(_AlarmClickResponse instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'targetTeamId': instance.targetTeamId,
      'targetTeamName': instance.targetTeamName,
      'directTo': instance.directTo,
      'targetId': instance.targetId,
      'isRead': instance.isRead,
    };

_AlarmReadAllResponse _$AlarmReadAllResponseFromJson(
  Map<String, dynamic> json,
) => _AlarmReadAllResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$AlarmReadAllResponseToJson(
  _AlarmReadAllResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
};
