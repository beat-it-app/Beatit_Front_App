import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import '../api/team_archive_api.dart';
import '../model/team_archive_model.dart';

class TeamArchiveState {
  final bool isLoading;
  final List<TeamArchiveItemModel> items;
  final int totalCount;
  final bool hasNext;
  final String? errorMessage;

  TeamArchiveState({
    this.isLoading = false,
    this.items = const [],
    this.totalCount = 0,
    this.hasNext = false,
    this.errorMessage,
  });

  TeamArchiveState copyWith({
    bool? isLoading,
    List<TeamArchiveItemModel>? items,
    int? totalCount,
    bool? hasNext,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TeamArchiveState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasNext: hasNext ?? this.hasNext,
      // 💡 항상 기본 false 또는 기존 bool 유지
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class TeamArchiveNotifier extends Notifier<TeamArchiveState> {
  @override
  TeamArchiveState build() {
    return TeamArchiveState();
  }

  /// 아카이브 목록 조회 (GET /teams/archives)
  Future<void> fetchArchives({int? teamId, String? keyword}) async {
    // 💡 초기 로딩 진입 시 hasNext에 null이 들어가지 않도록 방어
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final resolvedTeamId =
          teamId ?? ref.read(teamDetailProvider).teamDetail?.teamId ?? 10;

      final api = ref.read(teamArchiveApiProvider);
      final items = await api.getArchives(
        teamId: resolvedTeamId,
        keyword: keyword?.trim(),
      );

      state = state.copyWith(
        isLoading: false,
        items: items,
        totalCount: items.length,
        hasNext: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// 아카이브 등록 (POST /teams/archives)
  Future<bool> createArchive({
    required String title,
    required int locationId,
    required String description,
    List<File>? images,
    int? teamId,
  }) async {
    try {
      final api = ref.read(teamArchiveApiProvider);
      await api.createArchive(
        title: title,
        locationId: locationId,
        description: description,
        images: images,
      );

      // 등록 성공 시 최신 목록 재조회
      await fetchArchives(teamId: teamId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final teamArchiveProvider =
    NotifierProvider<TeamArchiveNotifier, TeamArchiveState>(() {
      return TeamArchiveNotifier();
    });
