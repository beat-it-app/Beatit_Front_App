import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/team_detail_api.dart';
import '../model/team_detail_model.dart';

final currentTeamProvider = FutureProvider.autoDispose<TeamDetailModel>((
  ref,
) async {
  final api = ref.watch(teamDetailApiProvider);
  final result = await api.getActiveTeamDetail();

  if (result.hasNoSelectedTeam) {
    throw TeamDetailApiException(
      '현재 선택된 팀이 없습니다. 팀을 먼저 선택해주세요.',
      code: 'TEAM-012',
    );
  }

  if (result.detail != null) {
    return result.detail!;
  }

  throw TeamDetailApiException('팀 정보를 불러올 수 없습니다.');
});
