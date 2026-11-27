// lib/src/domain/team/provider/current_team_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/team_detail_api.dart';
import '../model/team_detail_model.dart';

final currentTeamProvider = FutureProvider<TeamDetailModel?>((ref) async {
  final api = ref.watch(teamDetailApiProvider);

  final result = await api.getActiveTeamDetail();

  if (result.hasNoSelectedTeam) {
    return null;
  }
  
  if (result.detail != null) {
    return result.detail!;
  }

  // 4. [진짜 에러]: 200이 왔는데 규격이 이상한 경우
  throw TeamDetailApiException('팀 정보를 불러올 수 없습니다.');
});
