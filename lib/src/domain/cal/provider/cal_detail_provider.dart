import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_schedule_music_cache_provider.dart';

/// 일정 상세 본문만 불러옵니다.
/// 장소/지도 로딩은 상세 페이지 전체 로딩과 분리해 각 영역에서 처리합니다.
final calDetailProvider = FutureProvider.autoDispose
    .family<ScheduleDetailData, int>((ref, scheduleId) async {
      final cachedMusics = ref.watch(calScheduleMusicCacheProvider)[scheduleId];
      final response = await ref
          .read(calApiProvider)
          .getScheduleDetail(scheduleId: scheduleId);
      final serverData = response.data;

      // 현재 백엔드 ScheduleDetailResponse에는 musics가 빠져 있어 생성 직후에도
      // 상세 화면에서는 빈 목록으로 보입니다. 서버가 musics를 내려주는 경우에는
      // 서버 응답을 우선하고, 그렇지 않을 때만 현재 세션의 생성/수정 값을 보완합니다.
      if (serverData.musics.isNotEmpty || cachedMusics == null) {
        return serverData;
      }

      return serverData.copyWith(musics: cachedMusics);
    });
