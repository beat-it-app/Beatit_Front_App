import 'package:dio/dio.dart';

class EtcApiException implements Exception {
  const EtcApiException({
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

Map<String, dynamic> requireEtcSuccessBody({
  required Response<Map<String, dynamic>> response,
  required String fallbackMessage,
}) {
  final body = response.data;

  if (body == null) {
    throw const EtcApiException(message: '서버 응답이 비어 있습니다.');
  }

  if (body['success'] != true) {
    throw EtcApiException(
      message: body['message']?.toString() ?? fallbackMessage,
      code: body['status']?.toString(),
      statusCode: response.statusCode,
    );
  }

  return body;
}

EtcApiException mapEtcDioException(DioException error) {
  final rawData = error.response?.data;

  if (rawData is Map) {
    final data = Map<String, dynamic>.from(rawData);

    return EtcApiException(
      message: data['message']?.toString() ?? '요청에 실패했습니다.',
      code: data['status']?.toString(),
      statusCode: error.response?.statusCode,
    );
  }

  return EtcApiException(
    message: '서버와 통신할 수 없습니다.',
    statusCode: error.response?.statusCode,
  );
}
