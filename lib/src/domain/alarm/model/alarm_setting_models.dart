import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_setting_models.freezed.dart';
part 'alarm_setting_models.g.dart';

// Kotlin Boolean getter (isManager)의 Jackson 직렬화가 manager가 되는
// 서버 버전도 있으므로, 응답 키 호환만 이 지점에서 처리한다.
Object? _readIsManager(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? json['manager'];

@freezed
abstract class AlarmSettingsResponse with _$AlarmSettingsResponse {
  const factory AlarmSettingsResponse({
    required bool success,
    required int status,
    String? message,
    required AlarmSettingsData data,
  }) = _AlarmSettingsResponse;

  factory AlarmSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmSettingsResponseFromJson(json);
}

/// GET/PATCH /notifications/settings의 data DTO.
@freezed
abstract class AlarmSettingsData with _$AlarmSettingsData {
  const factory AlarmSettingsData({
    required bool allNotification,
    required bool activitySection,
    required bool calendarSchedule,
    required bool teamActivitySpace,
    required bool activityCommentMention,
    required bool collaborationSection,
    required bool notice,
    required bool pollAndMeetit,
    required bool progressResult,
    required bool collaborationCommentMention,
    required bool chatMessage,
    required bool teamManageSection,
    required bool positionChange,
    bool? memberChange,
    @JsonKey(name: 'isManager', readValue: _readIsManager)
    required bool isManager,
  }) = _AlarmSettingsData;

  factory AlarmSettingsData.fromJson(Map<String, dynamic> json) =>
      _$AlarmSettingsDataFromJson(json);
}
