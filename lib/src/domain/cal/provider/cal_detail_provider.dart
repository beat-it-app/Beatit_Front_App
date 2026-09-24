import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';

final calDetailProvider = FutureProvider.autoDispose
    .family<ScheduleDetailData, int>((ref, scheduleId) async {
      final response = await ref
          .read(calApiProvider)
          .getScheduleDetail(scheduleId: scheduleId);

      return response.data;
    });
