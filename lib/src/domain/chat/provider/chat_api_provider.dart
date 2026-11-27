import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_api.dart';

final chatApiProvider = Provider<ChatApi>((ref) {
  return ChatApi(ref.watch(dioProvider));
});
