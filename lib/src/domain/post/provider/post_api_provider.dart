import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/post/api/post_api.dart';

final postApiProvider = Provider<PostApi>((ref) {
  return PostApi(ref.watch(dioProvider));
});
