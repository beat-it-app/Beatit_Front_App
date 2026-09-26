import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';

/// 일정 상세 본문만 불러옵니다.
/// 장소/지도 로딩은 상세 페이지 전체 로딩과 분리해 각 영역에서 처리합니다.
final calDetailProvider = FutureProvider.autoDispose
    .family<ScheduleDetailData, int>((ref, scheduleId) async {
      final response = await ref
          .read(calApiProvider)
          .getScheduleDetail(scheduleId: scheduleId);

      return response.data;
    });
