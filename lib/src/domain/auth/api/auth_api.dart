import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../model/auth_session.dart';
import '../model/google_login_request.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/signup_request.dart';
import '../model/signup_response.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  static const String _signupPath = '/auth/signup';
  static const String _loginPath = '/auth/login';
  static const String _googleLoginPath = '/auth/google';

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

  Future<AuthSession> login(LoginRequest request) {
    return _authenticate(path: _loginPath, data: request.toJson());
  }

  Future<AuthSession> loginWithGoogle(GoogleLoginRequest request) {
    return _authenticate(path: _googleLoginPath, data: request.toJson());
  }

  Future<AuthSession> _authenticate({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
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
          fallbackMessage: '로그인에 실패했습니다.',
        );
      }

      final rawData = body['data'];

      debugPrint('[AuthApi] response body: $body');
      debugPrint('[AuthApi] response data: $rawData');

      if (rawData is! Map) {
        throw const AuthApiException(message: '로그인 응답 형식이 올바르지 않습니다.');
      }

      final loginResponse = LoginResponse.fromJson(
        Map<String, dynamic>.from(rawData),
      );

      final authorization = response.headers.value('authorization');
      final accessToken = _extractBearerToken(authorization);

      if (accessToken == null) {
        throw const AuthApiException(message: '로그인 토큰이 응답에 존재하지 않습니다.');
      }

      return AuthSession(
        userId: loginResponse.userId,
        role: loginResponse.role,
        createdProfile: loginResponse.createdProfile,
        socialProvider: loginResponse.socialProvider,
        accessToken: accessToken,
      );
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
