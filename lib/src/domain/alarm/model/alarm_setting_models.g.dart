// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_setting_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlarmSettingsResponse _$AlarmSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _AlarmSettingsResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String?,
  data: AlarmSettingsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AlarmSettingsResponseToJson(
  _AlarmSettingsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_AlarmSettingsData _$AlarmSettingsDataFromJson(Map<String, dynamic> json) =>
    _AlarmSettingsData(
      allNotification: json['allNotification'] as bool,
      activitySection: json['activitySection'] as bool,
      calendarSchedule: json['calendarSchedule'] as bool,
      teamActivitySpace: json['teamActivitySpace'] as bool,
      activityCommentMention: json['activityCommentMention'] as bool,
      collaborationSection: json['collaborationSection'] as bool,
      notice: json['notice'] as bool,
      pollAndMeetit: json['pollAndMeetit'] as bool,
      progressResult: json['progressResult'] as bool,
      collaborationCommentMention: json['collaborationCommentMention'] as bool,
      chatMessage: json['chatMessage'] as bool,
      teamManageSection: json['teamManageSection'] as bool,
      positionChange: json['positionChange'] as bool,
      memberChange: json['memberChange'] as bool?,
      isManager: _readIsManager(json, 'isManager') as bool,
    );

Map<String, dynamic> _$AlarmSettingsDataToJson(_AlarmSettingsData instance) =>
    <String, dynamic>{
      'allNotification': instance.allNotification,
      'activitySection': instance.activitySection,
      'calendarSchedule': instance.calendarSchedule,
      'teamActivitySpace': instance.teamActivitySpace,
      'activityCommentMention': instance.activityCommentMention,
      'collaborationSection': instance.collaborationSection,
      'notice': instance.notice,
      'pollAndMeetit': instance.pollAndMeetit,
      'progressResult': instance.progressResult,
      'collaborationCommentMention': instance.collaborationCommentMention,
      'chatMessage': instance.chatMessage,
      'teamManageSection': instance.teamManageSection,
      'positionChange': instance.positionChange,
      'memberChange': instance.memberChange,
      'isManager': instance.isManager,
    };
