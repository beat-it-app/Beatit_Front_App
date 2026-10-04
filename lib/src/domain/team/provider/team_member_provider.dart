import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/team_member_api.dart';
import '../model/team_member_model.dart';
import '../model/team_member_position_model.dart';

class TeamMemberState {
  final bool isLoading;
  final String? myRole;
  final List<TeamMemberModel> members;
  final List<TeamMemberPositionModel> positionMembers;
  final String? errorMessage;
  final String? errorCode;

  TeamMemberState({
    this.isLoading = false,
    this.myRole,
    this.members = const [],
    this.positionMembers = const [],
    this.errorMessage,
    this.errorCode,
  });

  TeamMemberState copyWith({
    bool? isLoading,
    String? myRole,
    List<TeamMemberModel>? members,
    List<TeamMemberPositionModel>? positionMembers,
    String? errorMessage,
    String? errorCode,
    bool clearError = false,
  }) {
    return TeamMemberState(
      isLoading: isLoading ?? this.isLoading,
      myRole: myRole ?? this.myRole,
      members: members ?? this.members,
      positionMembers: positionMembers ?? this.positionMembers,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
    );
  }
}

class TeamMemberNotifier extends Notifier<TeamMemberState> {
  @override
  TeamMemberState build() {
    return TeamMemberState();
  }

  // 1. 멤버 목록 조회: GET /teams/members
  Future<void> fetchMembers({String? query}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamMemberApiProvider);

      // 💡 myRole과 members를 함께 받아옴
      final result = await api.getTeamMembers(query: query);

      state = state.copyWith(
        isLoading: false,
        myRole: result.myRole, // 👈 myRole 상태 갱신
        members: result.members, // 👈 멤버 리스트 갱신
      );
    } on TeamMemberApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        errorCode: e.code,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // 2. 포지션 목록 조회: GET /teams/members/position
  Future<void> fetchMemberPositions() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamMemberApiProvider);
      final positions = await api.getMemberPositions();
      state = state.copyWith(isLoading: false, positionMembers: positions);
    } on TeamMemberApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        errorCode: e.code,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // 3. 대표 위임: POST /teams/members/{userPublicId} (targetRole: 'LEADER')
  Future<bool> assignLeader(String newLeaderPublicId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamMemberApiProvider);
      final updatedMembers = await api.updateMemberRole(
        userPublicId: newLeaderPublicId,
        targetRole: 'LEADER',
      );

      final currentList = [...state.members];
      for (final updated in updatedMembers) {
        final index = currentList.indexWhere(
          (m) => m.userPublicId == updated.userPublicId,
        );
        if (index != -1) {
          currentList[index] = currentList[index].copyWith(
            teamRole: updated.teamRole,
          );
        }
      }

      state = state.copyWith(isLoading: false, members: currentList);
      return true;
    } on TeamMemberApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        errorCode: e.code,
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  // 4. 운영진 역할 일괄 수정: POST /teams/members/{userPublicId} (MANAGER or MEMBER)
  Future<bool> updateManagerRoles(
    Map<String, bool> changedManagerStates,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamMemberApiProvider);
      final currentList = [...state.members];

      for (final entry in changedManagerStates.entries) {
        final userPublicId = entry.key;
        final isManager = entry.value;
        final targetRole = isManager ? 'MANAGER' : 'MEMBER';

        final updatedMembers = await api.updateMemberRole(
          userPublicId: userPublicId,
          targetRole: targetRole,
        );

        for (final updated in updatedMembers) {
          final index = currentList.indexWhere(
            (m) => m.userPublicId == updated.userPublicId,
          );
          if (index != -1) {
            currentList[index] = currentList[index].copyWith(
              teamRole: updated.teamRole,
            );
          }
        }
      }

      state = state.copyWith(isLoading: false, members: currentList);
      return true;
    } on TeamMemberApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        errorCode: e.code,
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  // 5. 포지션 일괄 수정: PATCH /teams/members/position
  Future<bool> updatePositions(
    List<Map<String, dynamic>> positionPayload,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(teamMemberApiProvider);
      final updatedPositions = await api.updateMemberPositions(positionPayload);

      // positionMembers 업데이트
      state = state.copyWith(
        isLoading: false,
        positionMembers: updatedPositions,
      );

      // 일반 멤버 리스트(members)에도 변경된 포지션 동기화
      final updatedMemberList = state.members.map((m) {
        final match = updatedPositions.firstWhere(
          (pos) => pos.userName == m.name,
          orElse: () => TeamMemberPositionModel(
            userId: -1,
            userName: '',
            position: m.position,
          ),
        );
        return match.userId != -1 ? m.copyWith(position: match.position) : m;
      }).toList();

      state = state.copyWith(members: updatedMemberList);
      return true;
    } on TeamMemberApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        errorCode: e.code,
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final teamMemberProvider =
    NotifierProvider<TeamMemberNotifier, TeamMemberState>(() {
      return TeamMemberNotifier();
    });
