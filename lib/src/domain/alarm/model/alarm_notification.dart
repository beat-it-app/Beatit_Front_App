import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_notification.freezed.dart';
part 'alarm_notification.g.dart';

/// GET /notifications API의 공통 응답 형식.
@freezed
abstract class AlarmListResponse with _$AlarmListResponse {
  const factory AlarmListResponse({
    required bool success,
    required int status,
    String? message,
    required AlarmPageResponse data,
  }) = _AlarmListResponse;

  factory AlarmListResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmListResponseFromJson(json);
}

@freezed
abstract class AlarmPageResponse with _$AlarmPageResponse {
  const factory AlarmPageResponse({
    required int teamId,
    required String teamName,
    required int unreadCount,
    required bool hasUnread,
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool isLast,
    @Default(<AlarmNotification>[]) List<AlarmNotification> notifications,
  }) = _AlarmPageResponse;

  factory AlarmPageResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmPageResponseFromJson(json);
}

@freezed
abstract class AlarmNotification with _$AlarmNotification {
  const factory AlarmNotification({
    @JsonKey(name: 'notificationId') required int id,
    required String category,
    required String type,
    required String title,
    required String content,
    String? directTo,
    int? targetId,
    required bool isRead,
    required DateTime createdAt,
  }) = _AlarmNotification;

  factory AlarmNotification.fromJson(Map<String, dynamic> json) =>
      _$AlarmNotificationFromJson(json);
}

/// PATCH /notifications/{id}/read, POST /notifications/{id}/click.
@freezed
abstract class AlarmActionResponse with _$AlarmActionResponse {
  const factory AlarmActionResponse({
    required bool success,
    required int status,
    String? message,
    required AlarmClickResponse data,
  }) = _AlarmActionResponse;

  factory AlarmActionResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmActionResponseFromJson(json);
}

@freezed
abstract class AlarmClickResponse with _$AlarmClickResponse {
  const factory AlarmClickResponse({
    required int notificationId,
    required int targetTeamId,
    required String targetTeamName,
    String? directTo,
    int? targetId,
    required bool isRead,
  }) = _AlarmClickResponse;

  factory AlarmClickResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmClickResponseFromJson(json);
}

/// PATCH /notifications/read-all은 data = null을 반환한다.
@freezed
abstract class AlarmReadAllResponse with _$AlarmReadAllResponse {
  const factory AlarmReadAllResponse({
    required bool success,
    required int status,
    String? message,
  }) = _AlarmReadAllResponse;

  factory AlarmReadAllResponse.fromJson(Map<String, dynamic> json) =>
      _$AlarmReadAllResponseFromJson(json);
}
