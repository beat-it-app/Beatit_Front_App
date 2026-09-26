import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/etc_api_provider.dart';

final memberSelectionProvider =
    NotifierProvider.autoDispose<MemberSelectionNotifier, MemberSelectionState>(
      MemberSelectionNotifier.new,
    );

class MemberSelectionState {
  const MemberSelectionState({
    this.members = const <TeamMemberSearchResult>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<TeamMemberSearchResult> members;
  final bool isLoading;
  final String? errorMessage;

  MemberSelectionState copyWith({
    List<TeamMemberSearchResult>? members,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MemberSelectionState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class MemberSelectionNotifier extends Notifier<MemberSelectionState> {
  static const int _pageSize = 100;
  int _requestId = 0;

  @override
  MemberSelectionState build() => const MemberSelectionState();

  Future<void> loadMembers({bool force = false}) async {
    if (!force && state.members.isNotEmpty && state.errorMessage == null) {
      return;
    }

    final requestId = ++_requestId;
    state = state.copyWith(
      members: const <TeamMemberSearchResult>[],
      isLoading: true,
      clearErrorMessage: true,
    );

    try {
      final allMembers = <TeamMemberSearchResult>[];
      var page = 0;
      var hasNext = true;

      while (hasNext) {
        final response = await ref.read(memberApiProvider).getMembers(
          page: page,
          size: _pageSize,
        );

        if (requestId != _requestId) {
          return;
        }

        allMembers.addAll(response.members);
        hasNext = response.hasNext && response.members.isNotEmpty;
        page++;
      }

      state = state.copyWith(
        members: List<TeamMemberSearchResult>.unmodifiable(allMembers),
        isLoading: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      if (requestId != _requestId) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: error is EtcApiException
            ? error.message
            : '팀 멤버 목록을 불러오지 못했습니다.',
      );
    }
  }
}
