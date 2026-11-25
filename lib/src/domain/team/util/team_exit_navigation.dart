import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_switch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 팀 삭제·탈퇴 직후 팀 탭(TeamEntryPage)으로 다시 진입한다.
/// 선택된 팀이 없으므로 entry는 팀 선택 화면을 보여주고,
/// 공지·일정·채팅 탭은 '현재 로그인된 팀이 없습니다.' 토스트를 띄운다.
Future<void> returnToTeamEntry(BuildContext context, WidgetRef ref) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  refreshTeamData(ref);

  // 이전 팀 정보가 남은 채로 이동하지 않도록 새 응답을 기다린다.
  // 조회가 실패하거나 늦어지면 entry의 로딩·재시도 화면에 맡긴다.
  try {
    await ref
        .read(currentTeamProvider.future)
        .timeout(const Duration(seconds: 5));
  } catch (error) {
    debugPrint('[TeamExit] current team refresh failed: $error');
  }
  if (!navigator.mounted) return;

  navigator.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const MainShell()),
    (route) => false,
  );
}
