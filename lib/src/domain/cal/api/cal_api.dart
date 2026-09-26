import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_date_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/calendar/calendar_month_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_create_request.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_create_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_update_request.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_update_response.dart';

class CalApi {
  CalApi(this._dio);

  final Dio _dio;

  static const String _calendarPath = '/calendar';
  static const String _calendarMonthPath = '/calendar/month';
  static const String _calendarDatePath = '/calendar/date';

  // 공통 Dio의 sendTimeout(10초)은 파일이 포함된 multipart 업로드에는 짧습니다.
  // 일정 생성/수정 요청에만 더 긴 timeout을 적용합니다.
  static const Duration _multipartSendTimeout = Duration(minutes: 2);
  static const Duration _multipartReceiveTimeout = Duration(minutes: 1);

  Future<CalendarMonthResponse> getCalendarSchedules({
    required int year,
    required int month,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _calendarMonthPath,
        queryParameters: {
          'year': year,
          'month': month,
        },
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '공유 캘린더를 불러오지 못했습니다.',
      );

      return CalendarMonthResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<CalendarDateResponse> getDateSchedules({
    required int year,
    required int month,
    required int date,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _calendarDatePath,
        queryParameters: {
          'year': year,
          'month': month,
          'date': date,
        },
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '선택한 날짜의 일정을 불러오지 못했습니다.',
      );

      return CalendarDateResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }


  Future<ScheduleDetailResponse> getScheduleDetail({
    required int scheduleId,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_calendarPath/$scheduleId',
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '일정 상세 정보를 불러오지 못했습니다.',
      );

      return ScheduleDetailResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<ScheduleCreateResponse> createSchedule({
    required ScheduleCreateRequest request,
    List<String> filePaths = const <String>[],
    Map<String, String> fileNamesByPath = const <String, String>{},
  }) async {
    try {
      final formData = await _buildScheduleFormData(
        requestJson: request.toJson(),
        filePaths: filePaths,
        fileNamesByPath: fileNamesByPath,
      );

      final response = await _dio.post<Map<String, dynamic>>(
        _calendarPath,
        data: formData,
        options: Options(
          sendTimeout: _multipartSendTimeout,
          receiveTimeout: _multipartReceiveTimeout,
        ),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '일정 생성에 실패했습니다.',
      );

      return ScheduleCreateResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<ScheduleUpdateResponse> updateSchedule({
    required int scheduleId,
    required ScheduleUpdateRequest request,
    List<String> newFilePaths = const <String>[],
    Map<String, String> newFileNamesByPath = const <String, String>{},
  }) async {
    try {
      final formData = await _buildScheduleFormData(
        requestJson: request.toJson(),
        filePaths: newFilePaths,
        fileNamesByPath: newFileNamesByPath,
      );

      final response = await _dio.patch<Map<String, dynamic>>(
        '$_calendarPath/$scheduleId',
        data: formData,
        options: Options(
          sendTimeout: _multipartSendTimeout,
          receiveTimeout: _multipartReceiveTimeout,
        ),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '일정 수정에 실패했습니다.',
      );

      return ScheduleUpdateResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> deleteSchedule({required int scheduleId}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '$_calendarPath/$scheduleId',
      );

      _requireSuccessBody(
        response: response,
        fallbackMessage: '일정 삭제에 실패했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<FormData> _buildScheduleFormData({
    required Map<String, dynamic> requestJson,
    required List<String> filePaths,
    Map<String, String> fileNamesByPath = const <String, String>{},
  }) async {
    final formData = FormData();

    // Spring @RequestPart("request") DTO가 JSON으로 역직렬화될 수 있도록
    // request 파트 자체의 Content-Type을 application/json으로 보냅니다.
    formData.files.add(
      MapEntry(
        'request',
        MultipartFile.fromBytes(
          utf8.encode(jsonEncode(requestJson)),
          filename: 'request.json',
          contentType: DioMediaType.parse(Headers.jsonContentType),
        ),
      ),
    );

    for (final path in filePaths) {
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            path,
            filename: _resolvedUploadFileName(
              path: path,
              fileNamesByPath: fileNamesByPath,
            ),
          ),
        ),
      );
    }

    return formData;
  }


  String _resolvedUploadFileName({
    required String path,
    required Map<String, String> fileNamesByPath,
  }) {
    final editedName = fileNamesByPath[path]?.trim();
    if (editedName != null && editedName.isNotEmpty) {
      return editedName;
    }

    return _fileNameFromPath(path);
  }

  String _fileNameFromPath(String path) {
    final segments = path.split(RegExp(r'[/\\]'));
    return segments.isEmpty ? 'file' : segments.last;
  }

  Map<String, dynamic> _requireSuccessBody({
    required Response<Map<String, dynamic>> response,
    required String fallbackMessage,
  }) {
    final body = response.data;

    if (body == null) {
      throw const CalApiException(message: '서버 응답이 비어 있습니다.');
    }

    if (body['success'] != true) {
      throw _createApiException(
        body: body,
        statusCode: response.statusCode,
        fallbackMessage: fallbackMessage,
      );
    }

    return body;
  }

  CalApiException _createApiException({
    required Map<String, dynamic> body,
    required int? statusCode,
    required String fallbackMessage,
  }) {
    return CalApiException(
      message: body['message']?.toString() ?? fallbackMessage,
      code: body['status']?.toString(),
      statusCode: statusCode,
    );
  }

  CalApiException _mapDioException(DioException error) {
    if (error.type == DioExceptionType.sendTimeout) {
      return const CalApiException(
        message: '파일 업로드 시간이 초과되었습니다. 네트워크 상태를 확인한 뒤 다시 시도해주세요.',
      );
    }

    if (error.type == DioExceptionType.receiveTimeout) {
      return const CalApiException(
        message: '서버 응답이 지연되고 있습니다. 잠시 후 다시 시도해주세요.',
      );
    }

    final rawData = error.response?.data;

    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);

      return CalApiException(
        message: data['message']?.toString() ?? '요청에 실패했습니다.',
        code: data['status']?.toString(),
        statusCode: error.response?.statusCode,
      );
    }

    return CalApiException(
      message: '서버와 통신할 수 없습니다.',
      statusCode: error.response?.statusCode,
    );
  }
}

class CalApiException implements Exception {
  const CalApiException({
    required this.message,
    this.code,
    this.statusCode,
  });

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => message;
}
