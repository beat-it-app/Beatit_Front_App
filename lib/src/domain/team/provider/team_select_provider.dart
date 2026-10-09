import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/team_select_api.dart';
import '../model/my_team_model.dart';

class TeamSelectState {
  const TeamSelectState({
    this.isLoading = false,
    this.errorMessage,
    this.teams = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<MyTeamModel> teams;

  TeamSelectState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MyTeamModel>? teams,
    bool clearError = false,
  }) {
    return TeamSelectState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      teams: teams ?? this.teams,
    );
  }
}

class TeamSelectNotifier extends Notifier<TeamSelectState> {
  @override
  TeamSelectState build() {
    return const TeamSelectState();
  }

  /// 소속 팀 전체 목록 조회 (GET /teams/me)
  Future<void> fetchMyTeams() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamSelectApiProvider);
      final response = await api.getMyTeams();
      state = state.copyWith(isLoading: false, teams: response.teams);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error is TeamSelectApiException
            ? error.message
            : '팀 목록을 불러오지 못했습니다.',
      );
    }
  }

  /// 팀 선택 (POST /teams/select/{teamPublicId})
  Future<bool> selectTeam(String teamPublicId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamSelectApiProvider);
      await api.selectTeam(teamPublicId);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error is TeamSelectApiException
            ? error.message
            : '팀 선택에 실패했습니다.',
      );
      return false;
    }
  }

  void reset() => state = const TeamSelectState();
}

final teamSelectProvider =
    NotifierProvider.autoDispose<TeamSelectNotifier, TeamSelectState>(
      TeamSelectNotifier.new,
    );
