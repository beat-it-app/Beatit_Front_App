import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_interceptor.dart';
import 'auth_token_storage.dart';

const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://3.34.225.157:8083',
);

BaseOptions _createBaseOptions() {
  return BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    contentType: Headers.jsonContentType,
    headers: const {
      'Accept': 'application/json',
    },
  );
}

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(authTokenStorageProvider);

  final dio = Dio(_createBaseOptions());

  // refresh 요청은 AuthInterceptor를 다시 타면 안 되므로
  // 재발급 전용 Dio는 interceptor 없이 분리한다.
  final refreshDio = Dio(_createBaseOptions());

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      dio: dio,
      refreshDio: refreshDio,
    ),
  );

  ref.onDispose(() {
    dio.close(force: true);
    refreshDio.close(force: true);
  });

  return dio;
});
