import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';

/// 구버전 서버가 상세 응답에 musics를 포함하지 않을 때만 사용하는 세션 캐시입니다.
/// 최신 서버가 내려준 musics가 있으면 항상 서버 데이터를 우선합니다.
final calScheduleMusicCacheProvider = NotifierProvider<
  CalScheduleMusicCacheNotifier,
  Map<int, List<ScheduleDetailMusic>>
>(CalScheduleMusicCacheNotifier.new);

class CalScheduleMusicCacheNotifier
    extends Notifier<Map<int, List<ScheduleDetailMusic>>> {
  @override
  Map<int, List<ScheduleDetailMusic>> build() =>
      const <int, List<ScheduleDetailMusic>>{};

  void setMusics(int scheduleId, List<ScheduleDetailMusic> musics) {
    state = <int, List<ScheduleDetailMusic>>{
      ...state,
      scheduleId: List<ScheduleDetailMusic>.unmodifiable(musics),
    };
  }

  void remove(int scheduleId) {
    if (!state.containsKey(scheduleId)) return;

    final next = Map<int, List<ScheduleDetailMusic>>.from(state)
      ..remove(scheduleId);
    state = next;
  }
}
