import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_interceptor.dart';
import 'auth_token_storage.dart';

const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://3.34.225.157:8083',
);

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(authTokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(AuthInterceptor(tokenStorage));

  return dio;
});
