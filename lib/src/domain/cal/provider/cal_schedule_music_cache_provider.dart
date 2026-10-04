import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';

/// 백엔드 일정 상세 응답에 musics가 포함되기 전까지, 현재 앱 세션에서 생성/수정한
/// 일정의 음원을 상세 화면에 즉시 반영하기 위한 임시 캐시입니다.
///
/// 서버가 musics를 내려주기 시작하면 calDetailProvider가 서버 값을 우선 사용하므로
/// 이 캐시는 자연스럽게 fallback 역할만 하게 됩니다.
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
