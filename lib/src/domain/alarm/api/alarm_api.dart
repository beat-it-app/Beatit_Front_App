import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:dio/dio.dart';

class AlarmApiException implements Exception {
  const AlarmApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AlarmApi {
  const AlarmApi(this._dio);

  final Dio _dio;

  Future<AlarmPageResponse> getNotifications({int page = 0, int size = 20}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/notifications',
        queryParameters: {'page': page, 'size': size},
      );
      final body = _requireSuccessBody(response.data);
      return AlarmListResponse.fromJson(body).data;
    } on DioException catch (error) {
      throw _mapError(error, '알림 목록을 불러오지 못했습니다.');
    } on FormatException {
      throw const AlarmApiException('알림 목록 응답이 올바르지 않습니다.');
    } on TypeError {
      throw const AlarmApiException('알림 목록 응답이 올바르지 않습니다.');
    }
  }

  Future<AlarmClickResponse> markAsRead(int notificationId) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/notifications/$notificationId/read',
      );
      return AlarmActionResponse.fromJson(
        _requireSuccessBody(response.data),
      ).data;
    } on DioException catch (error) {
      throw _mapError(error, '알림을 읽음 처리하지 못했습니다.');
    } on FormatException {
      throw const AlarmApiException('읽음 처리 응답이 올바르지 않습니다.');
    } on TypeError {
      throw const AlarmApiException('읽음 처리 응답이 올바르지 않습니다.');
    }
  }

  /// FCM 푸시 등 다른 팀의 알림 진입에서는 서버의 현재 팀도 변경된다.
  Future<AlarmClickResponse> clickNotification(int notificationId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/notifications/$notificationId/click',
      );
      return AlarmActionResponse.fromJson(
        _requireSuccessBody(response.data),
      ).data;
    } on DioException catch (error) {
      throw _mapError(error, '알림을 처리하지 못했습니다.');
    } on FormatException {
      throw const AlarmApiException('알림 이동 응답이 올바르지 않습니다.');
    } on TypeError {
      throw const AlarmApiException('알림 이동 응답이 올바르지 않습니다.');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/notifications/read-all',
      );
      AlarmReadAllResponse.fromJson(_requireSuccessBody(response.data));
    } on DioException catch (error) {
      throw _mapError(error, '모든 알림을 읽음 처리하지 못했습니다.');
    } on FormatException {
      throw const AlarmApiException('전체 읽음 처리 응답이 올바르지 않습니다.');
    } on TypeError {
      throw const AlarmApiException('전체 읽음 처리 응답이 올바르지 않습니다.');
    }
  }

  Map<String, dynamic> _requireSuccessBody(Map<String, dynamic>? body) {
    if (body == null || body['success'] != true) {
      throw AlarmApiException(
        body?['message']?.toString() ?? '알림 요청을 처리하지 못했습니다.',
      );
    }
    return body;
  }

  AlarmApiException _mapError(DioException error, String fallback) {
    final data = error.response?.data;
    final message = data is Map ? data['message']?.toString() : null;
    return AlarmApiException(message ?? fallback);
  }
}
