import 'package:beatit_front_app/src/domain/alarm/provider/alarm_provider.dart';
import 'package:beatit_front_app/src/domain/auth/provider/mypage_provider.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_main_provider.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_list_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_permission_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_storage_provider.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_main_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_archive_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_member_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_upcoming_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인 팀이 바뀐 횟수. MainShell이 구독해 숨겨진 탭을 버리고,
/// 사용자가 다시 들어갈 때 새로 만들어 조회하게 한다.
final teamSwitchProvider = NotifierProvider<TeamSwitchNotifier, int>(
  TeamSwitchNotifier.new,
);

class TeamSwitchNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void notifySwitched() => state++;
}

/// 서버의 로그인 팀이 바뀌거나 없어진 직후에만 호출한다.
/// (팀 선택 화면, 마이페이지 팀 전환, 알림 선택에 의한 팀 전환, 팀 삭제·탈퇴)
///
/// invalidate한 provider는 화면에서 다시 필요해질 때 API를 호출하므로
/// 보지 않는 화면의 요청은 발생하지 않는다.
void refreshTeamData(WidgetRef ref) {
  ref.read(teamSwitchProvider.notifier).notifySwitched();

  // 팀 페이지
  ref.invalidate(currentTeamProvider);
  ref.invalidate(teamDetailProvider);
  ref.invalidate(teamMemberProvider);
  ref.invalidate(teamArchiveProvider);
  ref.invalidate(teamUpcomingPerformancesProvider);
  ref.invalidate(teamUpcomingSchedulesProvider);

  // 공지·투표·밋잇, 일정, 채팅
  ref.invalidate(postMainProvider);
  ref.invalidate(calMainProvider);
  ref.invalidate(chatListProvider);

  // 클라우드
  ref.invalidate(cloudListProvider);
  ref.invalidate(cloudFileDetailProvider);
  ref.invalidate(cloudSearchEntriesProvider);
  ref.invalidate(cloudStorageProvider);
  ref.invalidate(cloudIsStaffProvider);

  // 알림, 마이페이지
  ref.invalidate(alarmProvider);
  ref.read(myPageProvider.notifier).fetchMyPage();
}
