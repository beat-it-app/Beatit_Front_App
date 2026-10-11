import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_schedule_music_cache_provider.dart';

/// 일정 상세 본문만 불러옵니다.
/// 장소/지도 로딩은 상세 페이지 전체 로딩과 분리해 각 영역에서 처리합니다.
final calDetailProvider = FutureProvider.autoDispose
    .family<ScheduleDetailData, int>((ref, scheduleId) async {
      final cachedMusics = ref.read(calScheduleMusicCacheProvider)[scheduleId];
      final response = await ref
          .read(calApiProvider)
          .getScheduleDetail(scheduleId: scheduleId);
      final serverData = response.data;

      // 상세 API가 musics를 반환하면 서버 값이 우선입니다.
      // 이전 서버 버전과 연동할 때만 현재 세션 캐시로 보완합니다.
      // 캐시 변화로 상세 API 요청이 불필요하게 반복되지 않도록 read를 사용합니다.
      if (serverData.musics.isNotEmpty || cachedMusics == null) {
        return serverData;
      }

      return serverData.copyWith(musics: cachedMusics);
    });
