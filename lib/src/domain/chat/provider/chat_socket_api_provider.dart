import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/auth_token_storage.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_socket_api.dart';

final chatSocketApiProvider = Provider<ChatSocketApi>((ref) {
  final dio = ref.watch(dioProvider);
  final tokenStorage = ref.watch(authTokenStorageProvider);

  // REST와 WebSocket은 같은 Backend를 사용하므로 Dio의 실제 baseUrl을
  // 그대로 WebSocket 기준 주소로 사용합니다. 별도 dart-define이 필요 없습니다.
  final socketBaseUrl = dio.options.baseUrl.trim();

  debugPrint(
    '[Chat WS] CONFIG | apiBaseUrl=${dio.options.baseUrl} | '
    'wsBaseUrl=$socketBaseUrl | source=API_BASE_URL',
  );

  return ChatSocketApi(
    baseUrl: socketBaseUrl,
    tokenStorage: tokenStorage,
  );
});
