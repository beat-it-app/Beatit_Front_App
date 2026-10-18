import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/api/alarm_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alarmApiProvider = Provider<AlarmApi>((ref) {
  return AlarmApi(ref.watch(dioProvider));
});
