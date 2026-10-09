import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import '../api/team_detail_api.dart';
import '../provider/current_team_provider.dart';
import 'team_detail_page.dart';
import 'team_select_page.dart';

class TeamEntryPage extends ConsumerWidget {
  const TeamEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(currentTeamProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return teamState.when(
      loading: () => Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),

      error: (error, stackTrace) {
        // TEAM-012 (현재 선택된 팀이 없는 경우) -> 팀 선택/목록 화면 노출
        if (error is TeamDetailApiException && error.code == 'TEAM-012') {
          return const TeamSelectPage();
        }

        // 그 외 일반 네트워크/서버 에러 화면
        return Scaffold(
          backgroundColor: colors.surface,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  error is TeamDetailApiException
                      ? error.message
                      : '팀 정보를 불러오지 못했습니다.',
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
        return TeamDetailPage(teamDetail: team);
      },
    );
  }
}
