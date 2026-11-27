import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/team_detail_api.dart';
import '../model/team_detail_model.dart';

class TeamDetailState {
  final bool isLoading;
  final TeamDetailModel? teamDetail;
  final bool navigateToSelectPage;
  final String? errorMessage;

  TeamDetailState({
    this.isLoading = false,
    this.teamDetail,
    this.navigateToSelectPage = false,
    this.errorMessage,
  });

  TeamDetailState copyWith({
    bool? isLoading,
    TeamDetailModel? teamDetail,
    bool? navigateToSelectPage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TeamDetailState(
      isLoading: isLoading ?? this.isLoading,
      teamDetail: teamDetail ?? this.teamDetail,
      navigateToSelectPage: navigateToSelectPage ?? this.navigateToSelectPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class TeamDetailNotifier extends Notifier<TeamDetailState> {
  @override
  TeamDetailState build() {
    return TeamDetailState();
  }

  /// 1. 팀 상세 정보 조회
  Future<void> fetchTeamDetail() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final api = ref.read(teamDetailApiProvider);
      final result = await api.getActiveTeamDetail();

      if (result.hasNoSelectedTeam) {
        // TEAM-012 (선택된 팀 없음) 발생 시 -> TeamSelectPage로 이동 트리거
        state = state.copyWith(isLoading: false, navigateToSelectPage: true);
      } else {
        // 정상 상세 정보 수신
        state = state.copyWith(
          isLoading: false,
          teamDetail: result.detail,
          navigateToSelectPage: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// 2. 팀 정보 수정 (PATCH /teams)
  Future<void> updateTeamDetail({
    required String teamName,
    String? description,
    String? teamType,
    String? establishedOn,
    File? teamImageFile,
    List<Map<String, String>>? links,
  }) async {
    final api = ref.read(teamDetailApiProvider);

    await api.updateTeam(
      teamName: teamName,
      description: description,
      teamType: teamType,
      establishedOn: establishedOn,
      teamImageFile: teamImageFile,
      links: links,
    );

    // 수정 완료 후 최신 상세 정보 갱신
    await fetchTeamDetail();
  }
}

final teamDetailProvider =
    NotifierProvider<TeamDetailNotifier, TeamDetailState>(() {
      return TeamDetailNotifier();
    });
