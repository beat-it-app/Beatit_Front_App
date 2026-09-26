import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/etc_api_provider.dart';

final locationDetailProvider = FutureProvider.autoDispose.family<LocationData, int>(
  (ref, locationId) {
    return ref.watch(locationApiProvider).getLocation(locationId);
  },
);
