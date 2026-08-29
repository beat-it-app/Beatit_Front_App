import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:beatit_front_app/src/domain/auth/model/login/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/google_login_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_response.dart';
import 'package:beatit_front_app/src/domain/auth/model/signup/signup_response.dart';
import 'package:beatit_front_app/src/domain/auth/model/signup/signup_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/account/find_id_response.dart';
import 'package:beatit_front_app/src/domain/auth/model/account/reset_password_request.dart';
import 'package:image_picker/image_picker.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  static const String _signupPath = '/auth/signup';
  static const String _checkDuplicationPath = '/auth/check-identifier';
  static const String _verifyEmailPath = '/auth/email-verification/verify';
  static const String _verifyEmailSendPath = '/auth/email-verification/send';

  static const String _loginPath = '/auth/login';
  static const String _googleLoginPath = '/auth/google';
  static const String _logoutPath = '/auth/logout';

  static const String _findIdentifierPath = '/auth/find-identifier/verify';
  static const String _findIdentifierSendPath = '/auth/find-identifier/send';
  static const String _resetPasswordPath = '/auth/reset-password';
  static const String _resetPasswordVerifyPath = '/auth/reset-password/verify';
  static const String _resetPasswordSendPath = '/auth/reset-password/send';

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

  Future<void> sendEmailCode({required String email}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _verifyEmailSendPath,
        queryParameters: {'email': email},
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
          fallbackMessage: '이메일 전송에 실패했습니다.',
        );
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _verifyEmailPath,
        queryParameters: {'email': email, 'code': code},
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
          fallbackMessage: '이메일 인증에 실패했습니다.',
        );
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> checkIdentifier({required String identifier}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _checkDuplicationPath,
        queryParameters: {'identifier': identifier},
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
          fallbackMessage: '아이디 중복 확인에 실패했습니다.',
        );
      }
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

      debugPrint('[AuthApi] response body: $body');

      final loginResponse = LoginResponse.fromJson(body);

      final loginData = loginResponse.data;

      final authorization = response.headers.value('authorization');
      final accessToken = _extractBearerToken(authorization);

      if (accessToken == null) {
        throw const AuthApiException(message: '로그인 토큰이 응답에 존재하지 않습니다.');
      }

      return AuthSession(
        userId: loginData.userId,
        role: loginData.role,
        createdProfile: loginData.createdProfile,
        socialProvider: loginData.socialProvider,
        accessToken: accessToken,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> sendFindIdentifierCode({required String email}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _findIdentifierSendPath,
        queryParameters: {'email': email},
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
          fallbackMessage: '이메일 인증에 실패했습니다.',
        );
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<FindIdentifierData> verifyFindIdentifierCode({
    required String email,
    required String code,
  }) async {
    try {
      debugPrint('[FindId] verify request');
      debugPrint('[FindId] email: $email');
      debugPrint('[FindId] code: $code');

      final response = await _dio.post<Map<String, dynamic>>(
        _findIdentifierPath,
        queryParameters: {'email': email, 'code': code},
        options: _publicRequestOptions(),
      );

      final body = response.data;

      debugPrint('[FindId] statusCode: ${response.statusCode}');
      debugPrint('[FindId] response body: $body');

      if (body == null) {
        throw const AuthApiException(message: '서버 응답이 비어 있습니다.');
      }

      if (body['success'] != true) {
        throw _createApiException(
          body: body,
          statusCode: response.statusCode,
          fallbackMessage: '아이디 조회에 실패했습니다. 다시 시도해주세요.',
        );
      }

      debugPrint('[FindId] parsing start');

      final result = FindIdentifierResponse.fromJson(body);

      debugPrint('[FindId] identifier: ${result.data.identifier}');

      return result.data;
    } on DioException catch (error) {
      debugPrint('[FindId] DioException');
      debugPrint('[FindId] response: ${error.response?.data}');

      throw _mapDioException(error);
    } catch (error, stackTrace) {
      debugPrint('[FindId] unexpected error: $error');
      debugPrint('$stackTrace');

      rethrow;
    }
  }

  Future<void> sendResetPasswordCode({
    required String email,
    required String identifier,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _resetPasswordSendPath,
        queryParameters: {'email': email, 'identifier': identifier},
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
          fallbackMessage: '비밀번호 재설정에 실패했습니다.',
        );
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> verifyResetPasswordCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _resetPasswordVerifyPath,
        queryParameters: {'email': email, 'code': code},
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
          fallbackMessage: '인증번호 확인에 실패했습니다.',
        );
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _resetPasswordPath,
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
          fallbackMessage: '비밀번호 재설정에 실패했습니다.',
        );
      }
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

  Future<void> createProfile({
    required String name,
    XFile? profileImage,
    int? defaultImageId,
  }) async {
    final hasCustomImage = profileImage != null;
    final hasDefaultImage = defaultImageId != null;

    if (hasCustomImage == hasDefaultImage) {
      throw const AuthApiException(message: '프로필 이미지를 하나만 선택해주세요.');
    }

    try {
      final formData = FormData();

      formData.fields.add(MapEntry('name', name));

      if (defaultImageId != null) {
        formData.fields.add(
          MapEntry('defaultImageId', defaultImageId.toString()),
        );
      }

      if (profileImage != null) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(
              profileImage.path,
              filename: profileImage.name,
            ),
          ),
        );
      }

      final response = await _dio.post<Map<String, dynamic>>(
        _profilePath,
        data: formData,
      );

      final body = response.data;

      if (body == null) {
        throw const AuthApiException(message: '서버 응답이 비어 있습니다.');
      }

      if (body['success'] != true) {
        throw _createApiException(
          body: body,
          statusCode: response.statusCode,
          fallbackMessage: '프로필 생성에 실패했습니다.',
        );
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
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
