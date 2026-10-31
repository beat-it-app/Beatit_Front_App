import 'package:beatit_front_app/src/domain/cloud/provider/cloud_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/domain/team/api/team_member_api.dart';

/// Team Cloud API가 작성자 ID/isMine을 내려주지 않아 UI 권한 표시에만 사용하는 임시 provider다.
/// 백엔드에 isMine 또는 uploaderId/creatorId가 추가되면 이름 비교를 제거해야 한다.
final cloudCurrentUserNameProvider = FutureProvider<String>((ref) async {
  return ref.watch(cloudApiProvider).getCurrentUserName();
});

/// 팀 대표/운영진도 클라우드 관리 메뉴를 사용할 수 있도록 현재 팀 역할을 확인합니다.
/// 화면의 메뉴 노출 정책이며, 최종 권한 검증은 서버에서 수행해야 합니다.
final cloudIsStaffProvider = FutureProvider<bool>((ref) async {
  final result = await ref.watch(teamMemberApiProvider).getTeamMembers();
  final role = result.myRole?.trim().toUpperCase();
  return role == 'LEADER' || role == 'MANAGER';
});
