import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/etc/api/location_api.dart';
import 'package:beatit_front_app/src/domain/etc/api/member_api.dart';
import 'package:beatit_front_app/src/domain/etc/api/music_api.dart';

final locationApiProvider = Provider<LocationApi>((ref) {
  return LocationApi(ref.watch(dioProvider));
});

final musicApiProvider = Provider<MusicApi>((ref) {
  return MusicApi(ref.watch(dioProvider));
});

final memberApiProvider = Provider<MemberApi>((ref) {
  return MemberApi(ref.watch(dioProvider));
});
