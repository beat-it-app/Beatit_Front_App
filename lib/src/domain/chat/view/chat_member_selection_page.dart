import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/member_selection_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';

class ChatMemberSelectionPage extends ConsumerStatefulWidget {
  const ChatMemberSelectionPage({super.key});

  @override
  ConsumerState<ChatMemberSelectionPage> createState() =>
      _ChatMemberSelectionPageState();
}

class _ChatMemberSelectionPageState
    extends ConsumerState<ChatMemberSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedUserIds = <int>{};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberSelectionProvider.notifier).loadMembers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TeamMemberSearchResult> _selectableMembers(
    MemberSelectionState state,
    int currentUserId,
  ) {
    return state.members
        .where(
          (member) =>
              member.userId != null && member.userId != currentUserId,
        )
        .toList(growable: false);
  }

  List<TeamMemberSearchResult> _visibleMembers(
    List<TeamMemberSearchResult> members,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return members;
    }

    return members
        .where((member) => member.userName.toLowerCase().contains(query))
        .toList(growable: false);
  }

  bool _isAllSelected(List<TeamMemberSearchResult> members) {
    if (members.isEmpty) {
      return false;
    }

    return members.every(
      (member) => _selectedUserIds.contains(member.userId),
    );
  }

  void _toggleMember(int userId) {
    setState(() {
      if (!_selectedUserIds.add(userId)) {
        _selectedUserIds.remove(userId);
      }
    });
  }

  void _toggleAll(List<TeamMemberSearchResult> members) {
    setState(() {
      if (_isAllSelected(members)) {
        _selectedUserIds.clear();
        return;
      }

      _selectedUserIds
        ..clear()
        ..addAll(members.map((member) => member.userId).whereType<int>());
    });
  }

  void _confirm(List<TeamMemberSearchResult> members) {
    final selectedMembers = members
        .where((member) => _selectedUserIds.contains(member.userId))
        .toList(growable: false);

    if (selectedMembers.isEmpty) {
      return;
    }

    Navigator.of(context).pop(selectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(memberSelectionProvider);
    final currentUserId = ref.watch(authProvider).asData?.value?.userId;

    if (currentUserId == null) {
      return Scaffold(
        appBar: AppTopAppBar.backOnly(
          onBackPressed: () => Navigator.of(context).maybePop(),
        ),
        body: Center(
          child: Text(
            '로그인 정보를 확인할 수 없습니다.',
            style: FontStyles.med14.copyWith(color: context.grays.gray5),
          ),
        ),
      );
    }

    final members = _selectableMembers(memberState, currentUserId);
    final visibleMembers = _visibleMembers(members);

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: SearchInputWidget(
                controller: _searchController,
                hintText: '찾고 싶은 멤버를 검색하세요.',
                onSearchPressed: () => FocusScope.of(context).unfocus(),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            _SelectAllRow(
              isSelected: _isAllSelected(members),
              onTap: () => _toggleAll(members),
            ),
            const SizedBox(height: AppSpacing.x8),
            Expanded(
              child: _MemberList(
                state: memberState,
                members: visibleMembers,
                selectedUserIds: _selectedUserIds,
                onToggle: _toggleMember,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x20,
                AppSpacing.x12,
                AppSpacing.x20,
                AppSpacing.x16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: '취소',
                      variant: ButtonVariant.outlined,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: AppButton(
                      text: '확인',
                      isDisabled:
                          memberState.isLoading || _selectedUserIds.isEmpty,
                      onPressed: () => _confirm(members),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberList extends StatelessWidget {
  const _MemberList({
    required this.state,
    required this.members,
    required this.selectedUserIds,
    required this.onToggle,
  });

  final MemberSelectionState state;
  final List<TeamMemberSearchResult> members;
  final Set<int> selectedUserIds;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          textAlign: TextAlign.center,
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    if (members.isEmpty) {
      return Center(
        child: Text(
          '선택할 수 있는 멤버가 없습니다.',
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final userId = member.userId!;

        return Column(
          children: [
            MemberSelectionItem(
              name: member.userName,
              role: MemberSelectionRole.fromApiValue(member.teamRole),
              profileImageUrl: member.profileImageUrl,
              isSelected: selectedUserIds.contains(userId),
              onTap: () => onToggle(userId),
            ),
            const SizedBox(height: AppSpacing.x8),
          ],
        );
      },
    );
  }
}

class _SelectAllRow extends StatelessWidget {
  const _SelectAllRow({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x20,
            vertical: AppSpacing.x8,
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? context.brands.beatOrange1
                      : context.grays.gray7,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/check/check.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    context.grays.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(
                '전체 선택',
                style: FontStyles.semi14.copyWith(color: context.grays.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
