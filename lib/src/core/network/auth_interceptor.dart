import 'package:dio/dio.dart';

import 'auth_token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AuthTokenStorage tokenStorage,
    required Dio dio,
    required Dio refreshDio,
  }) : _tokenStorage = tokenStorage,
       _dio = dio,
       _refreshDio = refreshDio;

  static const String _reissuePath = '/auth/reissue';
  static const String _requiresAuthKey = 'requiresAuth';
  static const String _retriedAfterRefreshKey = 'retriedAfterRefresh';

  final AuthTokenStorage _tokenStorage;
  final Dio _dio;
  final Dio _refreshDio;

  Future<String>? _refreshFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra[_requiresAuthKey] != false;

    if (!requiresAuth) {
      handler.next(options);
      return;
    }

    final accessToken = await _tokenStorage.readAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = error.requestOptions;

    final requiresAuth = requestOptions.extra[_requiresAuthKey] != false;
    final alreadyRetried =
        requestOptions.extra[_retriedAfterRefreshKey] == true;
    final isUnauthorized = error.response?.statusCode == 401;

    if (!requiresAuth || alreadyRetried || !isUnauthorized) {
      handler.next(error);
      return;
    }

    final String accessToken;

    try {
      accessToken = await _getAccessTokenAfterUnauthorized(requestOptions);
    } catch (_) {
      // refresh token이 없거나 재발급에 실패하면 현재 401을 그대로 전달한다.
      // 로그인 화면 이동/세션 복구 정책은 여기서 처리하지 않는다.
      handler.next(error);
      return;
    }

    try {
      final retryOptions = requestOptions;

      retryOptions.headers['Authorization'] = 'Bearer $accessToken';
      retryOptions.extra[_retriedAfterRefreshKey] = true;

      final requestData = retryOptions.data;

      // multipart/form-data는 한 번 전송되면 finalize되므로 재시도 전에 clone한다.
      if (requestData is FormData) {
        retryOptions.data = requestData.clone();
      }

      final response = await _dio.fetch<dynamic>(retryOptions);

      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    } catch (_) {
      handler.next(error);
    }
  }

  Future<String> _getAccessTokenAfterUnauthorized(
    RequestOptions requestOptions,
  ) async {
    final failedAccessToken = _extractBearerToken(
      requestOptions.headers['Authorization']?.toString(),
    );

    final storedAccessToken = await _tokenStorage.readAccessToken();

    // 다른 요청이 먼저 refresh를 완료한 경우에는 다시 reissue하지 않고
    // 이미 교체된 access token으로 현재 요청만 재시도한다.
    if (failedAccessToken != null &&
        storedAccessToken != null &&
        storedAccessToken.isNotEmpty &&
        storedAccessToken != failedAccessToken) {
      return storedAccessToken;
    }

    return _refreshAccessToken();
  }

  Future<String> _refreshAccessToken() async {
    final ongoingRefresh = _refreshFuture;

    if (ongoingRefresh != null) {
      return ongoingRefresh;
    }

    final refreshFuture = _performRefresh();
    _refreshFuture = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }
    }
  }

  Future<String> _performRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('Refresh token is missing.');
    }

    final response = await _refreshDio.post<Map<String, dynamic>>(
      _reissuePath,
      options: Options(
        headers: {
          'Refresh-Token': refreshToken,
        },
      ),
    );

    final body = response.data;
    final data = body?['data'];

    final bodyData = data is Map
        ? Map<String, dynamic>.from(data)
        : const <String, dynamic>{};

    final newAccessToken =
        _extractBearerToken(response.headers.value('authorization')) ??
        bodyData['accessToken']?.toString();

    final newRefreshToken =
        response.headers.value('refresh-token')?.trim() ??
        bodyData['refreshToken']?.toString();

    if (newAccessToken == null ||
        newAccessToken.isEmpty ||
        newRefreshToken == null ||
        newRefreshToken.isEmpty) {
      throw StateError('Reissued tokens are missing.');
    }

    await _tokenStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );

    return newAccessToken;
  }

  String? _extractBearerToken(String? authorization) {
    if (authorization == null || authorization.isEmpty) {
      return null;
    }

    final bearerPattern = RegExp(
      r'^Bearer\s+',
      caseSensitive: false,
    );

    final token = authorization
        .replaceFirst(bearerPattern, '')
        .trim();

    return token.isEmpty ? null : token;
  }
}
