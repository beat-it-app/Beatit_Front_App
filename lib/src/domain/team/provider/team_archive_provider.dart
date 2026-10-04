import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import '../model/team_archive_model.dart';

class TeamArchiveState {
  final bool isLoading;
  final List<TeamArchiveItemModel> items;
  final int totalCount;
  final String? errorMessage;

  TeamArchiveState({
    this.isLoading = false,
    this.items = const [],
    this.totalCount = 0,
    this.errorMessage,
  });

  TeamArchiveState copyWith({
    bool? isLoading,
    List<TeamArchiveItemModel>? items,
    int? totalCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TeamArchiveState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class TeamArchiveNotifier extends Notifier<TeamArchiveState> {
  @override
  TeamArchiveState build() {
    return TeamArchiveState();
  }

  Future<void> fetchArchives({String? keyword}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = ref.read(dioProvider);

      // 현재 활성화된 팀 ID 가져오기
      final currentTeamId = ref.read(teamDetailProvider).teamDetail?.teamId;

      final response = await dio.get(
        '/teams/archives',
        queryParameters: {
          if (currentTeamId != null) 'teamId': currentTeamId,
          if (keyword != null && keyword.trim().isNotEmpty)
            'keyword': keyword.trim(),
          'page': 0,
          'size': 50,
        },
      );

      final resData = response.data;
      if (resData is Map<String, dynamic> && resData['data'] != null) {
        final archiveData = TeamArchiveResponseModel.fromJson(
          resData['data'] as Map<String, dynamic>,
        );
        state = state.copyWith(
          isLoading: false,
          items: archiveData.items,
          totalCount: archiveData.totalCount,
        );
      } else {
        state = state.copyWith(isLoading: false, items: []);
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? '연습실 기록을 불러오지 못했습니다.';
      state = state.copyWith(isLoading: false, errorMessage: msg);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final teamArchiveProvider =
    NotifierProvider<TeamArchiveNotifier, TeamArchiveState>(() {
      return TeamArchiveNotifier();
    });
