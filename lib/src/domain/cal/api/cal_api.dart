import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/auth/model/signup/signup_response.dart';
import 'package:beatit_front_app/src/domain/auth/model/signup/signup_request.dart';

class CalApi {
  CalApi(this._dio);

  final Dio _dio;

  static const String _signupPath = '/auth/signup';

  static const String _profilePath = '/users/profile';

  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _signupPath,
        data: request.toJson(),
        options: _publicRequestOptions(),
      );

      final body = response.data;

      if (body == null) {
        throw const AuthApiException(message: '서버 응답이 비어 있습니다.');
      }

      if (body['success'] != true) {
        throw _createApiException(
          body: body,
          statusCode: response.statusCode,
          fallbackMessage: '회원가입에 실패했습니다.',
        );
      }

      return SignupResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Options _publicRequestOptions() {
    return Options(extra: const {'requiresAuth': false});
  }

  String? _extractBearerToken(String? authorization) {
    if (authorization == null || authorization.isEmpty) {
      return null;
    }

    final bearerPattern = RegExp(r'^Bearer\s+', caseSensitive: false);

    final token = authorization.replaceFirst(bearerPattern, '').trim();

    return token.isEmpty ? null : token;
  }

  AuthApiException _createApiException({
    required Map<String, dynamic> body,
    required int? statusCode,
    required String fallbackMessage,
  }) {
    return AuthApiException(
      message: body['message']?.toString() ?? fallbackMessage,
      code: body['status']?.toString(),
      statusCode: statusCode,
    );
  }

  AuthApiException _mapDioException(DioException error) {
    final rawData = error.response?.data;

    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);

      return AuthApiException(
        message: data['message']?.toString() ?? '요청에 실패했습니다.',
        code: data['status']?.toString(),
        statusCode: error.response?.statusCode,
      );
    }

    return AuthApiException(
      message: '서버와 통신할 수 없습니다.',
      statusCode: error.response?.statusCode,
    );
  }
}

class AuthApiException implements Exception {
  const AuthApiException({required this.message, this.code, this.statusCode});

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => message;
}
