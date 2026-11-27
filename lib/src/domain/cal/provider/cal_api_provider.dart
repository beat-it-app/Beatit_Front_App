import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/cal/api/cal_api.dart';

final calApiProvider = Provider<CalApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CalApi(dio);
});
