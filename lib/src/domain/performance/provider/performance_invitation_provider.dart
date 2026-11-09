import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/domain/performance/api/performance_api.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';

/// 서버에서 등록된 초대장·셋리스트 전체를 조회한다.
final performanceInvitationProvider = FutureProvider.autoDispose
    .family<PerformanceInvitationResponse, String>((ref, publicId) {
  return ref.watch(performanceApiProvider).getPerformanceInvitation(publicId);
});
