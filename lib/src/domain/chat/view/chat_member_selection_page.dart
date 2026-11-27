import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';
import 'package:beatit_front_app/src/domain/chat/provider/chat_list_provider.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/member_selection_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';

/// 멤버 선택 후 새 대화 시작 또는 이미 존재하는 대화방 이동을 구분합니다.
class ChatMemberSelectionResult {
  const ChatMemberSelectionResult({required this.members, this.existingChatId});

  final List<TeamMemberSearchResult> members;
  final int? existingChatId;
}

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
  bool _isCheckingDuplicate = false;

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
          (member) => member.userId != null && member.userId != currentUserId,
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

    return members.every((member) => _selectedUserIds.contains(member.userId));
  }

  void _toggleMember(int userId) {
    if (_isCheckingDuplicate) return;
    setState(() {
      if (!_selectedUserIds.add(userId)) {
        _selectedUserIds.remove(userId);
      }
    });
  }

  void _toggleAll(List<TeamMemberSearchResult> members) {
    if (_isCheckingDuplicate) return;
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

  Future<void> _confirm(List<TeamMemberSearchResult> members) async {
    if (_isCheckingDuplicate) return;

    final selectedMembers = members
        .where((member) => _selectedUserIds.contains(member.userId))
        .toList(growable: false);
    if (selectedMembers.isEmpty) return;

    final participantIds = selectedMembers
        .map((member) => member.userId)
        .whereType<int>()
        .toList(growable: false);
    if (participantIds.length != selectedMembers.length) {
      _showError('멤버 정보를 확인할 수 없습니다.');
      return;
    }

    setState(() => _isCheckingDuplicate = true);
    try {
      final duplicate = await ref
          .read(chatListProvider.notifier)
          .checkDuplicateChatRoom(participantIds: participantIds);
      if (!mounted) return;

      if (!duplicate.exists) {
        Navigator.of(
          context,
        ).pop(ChatMemberSelectionResult(members: selectedMembers));
        return;
      }

      if (duplicate.existingChatIds.isEmpty) {
        _showError('기존 채팅방 정보를 확인할 수 없습니다.');
        return;
      }

      // 동일 멤버 단체방이 여러 개면 현재 채팅 목록에서 가장 최근에
      // 사용한 방을 선택합니다. 목록에 없으면 서버가 반환한 첫 ID를 사용합니다.
      final roomIds = duplicate.existingChatIds;
      final currentRooms = ref.read(chatListProvider).rooms;
      var existingChatId = roomIds.first;
      for (final room in currentRooms) {
        if (roomIds.contains(room.chatId)) {
          existingChatId = room.chatId;
          break;
        }
      }

      if (duplicate.roomType == ChatRoomType.direct) {
        Navigator.of(context).pop(
          ChatMemberSelectionResult(
            members: selectedMembers,
            existingChatId: existingChatId,
          ),
        );
        return;
      }

      final createNew = await AppPopup.show(
        context,
        title: '이미 존재하는 채팅방입니다.',
        content: '동일한 멤버가 참여 중인 채팅방이 이미 있습니다. 새 채팅방을 생성하시겠어요?',
        warningType: WarningType.circle,
        buttonNum: ButtonNum.two,
        cancelText: '취소',
        confirmText: '확인',
        barrierDismissible: true,
      );
      if (!mounted || createNew == null) return;
      Navigator.of(context).pop(
        ChatMemberSelectionResult(
          members: selectedMembers,
          existingChatId: createNew ? null : existingChatId,
        ),
      );
    } on ChatApiException catch (error) {
      if (mounted) _showError(error.message);
    } catch (_) {
      if (mounted) _showError('채팅방 중복 여부를 확인하지 못했습니다.');
    } finally {
      if (mounted) setState(() => _isCheckingDuplicate = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                      isLoading: _isCheckingDuplicate,
                      isDisabled:
                          memberState.isLoading ||
                          _isCheckingDuplicate ||
                          _selectedUserIds.isEmpty,
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
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
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
