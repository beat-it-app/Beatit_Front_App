import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/api/cloud_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudApiProvider = Provider<CloudApi>((ref) {
  return CloudApi(ref.watch(dioProvider));
});
