import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import '../api/team_detail_api.dart';
import '../provider/current_team_provider.dart';
import 'team_detail_page.dart';
import 'team_select_page.dart';

// team_entry_page.dart

class TeamEntryPage extends ConsumerWidget {
  const TeamEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(currentTeamProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return teamAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),

      // 🚨 [진짜 시스템 / 네트워크 에러 핸들링]
      error: (error, stackTrace) {
        final message = error is TeamDetailApiException
            ? error.message
            : '팀 정보를 불러오지 못했습니다.';

        return Scaffold(
          backgroundColor: colors.surface,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message, // 👈 500 서버 에러, 연결 끊김 등 실제 에러 메시지 출력
                  style: FontStyles.med16.copyWith(color: context.grays.gray5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => ref.invalidate(currentTeamProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        );
      },

      data: (team) {
        // Case 1: 가입된 팀이 없는 유저 -> 팀 생성/가입 선택 화면 노출
        if (team == null) {
          return const TeamSelectPage();
        }

        // Case 2: 가입된 팀이 있는 유저 -> 팀 상세 대시보드 화면 노출
        return TeamDetailPage(teamDetail: team);
      },
    );
  }
}
