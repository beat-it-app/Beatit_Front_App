import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/team_select_api.dart';
import '../model/my_team_model.dart';

class TeamSelectState {
  const TeamSelectState({
    this.isLoading = false,
    this.errorMessage,
    this.hasActiveTeam = false,
    this.teams = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final bool hasActiveTeam; // 활성 팀이 있으면 true -> 상세 페이지로 이동
  final List<MyTeamModel> teams;

  TeamSelectState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? hasActiveTeam,
    List<MyTeamModel>? teams,
    bool clearError = false,
  }) {
    return TeamSelectState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasActiveTeam: hasActiveTeam ?? this.hasActiveTeam,
      teams: teams ?? this.teams,
    );
  }
}

class TeamSelectNotifier extends Notifier<TeamSelectState> {
  @override
  TeamSelectState build() {
    return const TeamSelectState();
  }

  /// 팀 목록 조회 및 1, 2, 3번 시나리오 분기
  Future<void> fetchMyTeams({int? currentTeamId}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    // 클라이언트에 이미 currentTeamId가 보관되어 있는 경우 바로 활성 팀 처리
    if (currentTeamId != null && currentTeamId > 0) {
      state = state.copyWith(isLoading: false, hasActiveTeam: true);
      return;
    }

    try {
      final api = ref.read(teamSelectApiProvider);
      final response = await api.getMyTeams();

      // 💡 백엔드 응답이 '선택된 팀 있음(상세 데이터)'인지, '선택된 팀 없음(teams 목록)'인지에 따라 분기
      if (response.hasActiveTeam) {
        // 3번 시나리오: 이미 선택된 팀이 있으므로 TeamDetailPage로 이동 트리거
        state = state.copyWith(
          isLoading: false,
          hasActiveTeam: true,
          teams: const [],
        );
      } else {
        // 1번(teams.isEmpty) 또는 2번(teams.isNotEmpty)
        state = state.copyWith(
          isLoading: false,
          hasActiveTeam: false,
          teams: response.teams,
        );
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(error),
      );
    }
  }

  /// 팀 카드 클릭 시 팀 활성화 API 호출 (POST /teams/select/{teamPublicId})
  Future<bool> selectTeam(String teamPublicId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamSelectApiProvider);
      await api.selectTeam(teamPublicId);

      // 💡 팀 선택이 성공했으므로 이제 활성 팀이 존재하는 상태로 변경
      state = state.copyWith(isLoading: false, hasActiveTeam: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(error),
      );
      return false;
    }
  }

  void reset() {
    state = const TeamSelectState();
  }

  String _getErrorMessage(Object error) {
    if (error is TeamSelectApiException) {
      return error.message;
    }
    return '요청 처리 중 오류가 발생했습니다.';
  }
}

final teamSelectProvider =
    NotifierProvider.autoDispose<TeamSelectNotifier, TeamSelectState>(
      TeamSelectNotifier.new,
    );
