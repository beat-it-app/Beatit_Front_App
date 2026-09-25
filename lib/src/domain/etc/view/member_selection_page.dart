import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/domain/etc/provider/member_selection_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MemberSelectionMember {
  const MemberSelectionMember({
    required this.id,
    required this.name,
    required this.role,
    this.profileImageUrl,
  });

  final String id;
  final String name;
  final MemberSelectionRole role;
  final String? profileImageUrl;
}

class MemberSelectionPage extends ConsumerStatefulWidget {
  const MemberSelectionPage({
    super.key,
    this.members = const <MemberSelectionMember>[],
    this.initialSelectedMemberIds = const <String>{},
    this.onConfirm,
  });

  /// 기존 호출부 호환을 위해 유지한다.
  /// 실제 화면 목록은 /teams/members API 응답을 사용한다.
  final List<MemberSelectionMember> members;
  final Set<String> initialSelectedMemberIds;
  final ValueChanged<List<MemberSelectionMember>>? onConfirm;

  @override
  ConsumerState<MemberSelectionPage> createState() =>
      _MemberSelectionPageState();
}

class _MemberSelectionPageState extends ConsumerState<MemberSelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  late Set<String> _selectedMemberIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedMemberIds = Set<String>.from(widget.initialSelectedMemberIds);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMembers();
    });
  }

  Future<void> _loadMembers() async {
    await ref.read(memberSelectionProvider.notifier).loadMembers();

    if (!mounted) {
      return;
    }

    final validIds = ref
        .read(memberSelectionProvider)
        .members
        .map((member) => member.userPublicId)
        .toSet();

    setState(() {
      _selectedMemberIds = _selectedMemberIds.intersection(validIds);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MemberSelectionMember> _toViewMembers(MemberSelectionState state) {
    return state.members
        .map(
          (member) => MemberSelectionMember(
            id: member.userPublicId,
            name: member.userName,
            role: MemberSelectionRole.fromApiValue(member.teamRole),
            profileImageUrl: member.profileImageUrl,
          ),
        )
        .toList(growable: false);
  }

  List<MemberSelectionMember> _visibleMembers(
    List<MemberSelectionMember> members,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return members;
    }

    return members.where((member) {
      return member.name.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  bool _isAllSelected(List<MemberSelectionMember> members) {
    if (members.isEmpty) {
      return false;
    }

    return members.every(
      (member) => _selectedMemberIds.contains(member.id),
    );
  }

  void _handleSearch() {
    FocusScope.of(context).unfocus();
  }

  void _handleSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _toggleMember(String memberId) {
    setState(() {
      if (_selectedMemberIds.contains(memberId)) {
        _selectedMemberIds.remove(memberId);
      } else {
        _selectedMemberIds.add(memberId);
      }
    });
  }

  void _toggleAll(List<MemberSelectionMember> members) {
    setState(() {
      if (_isAllSelected(members)) {
        _selectedMemberIds.clear();
      } else {
        _selectedMemberIds = members.map((member) => member.id).toSet();
      }
    });
  }

  void _handleConfirm(List<MemberSelectionMember> members) {
    final selectedMembers = members
        .where((member) => _selectedMemberIds.contains(member.id))
        .toList(growable: false);

    if (widget.onConfirm != null) {
      widget.onConfirm!(selectedMembers);
      return;
    }

    Navigator.of(context).pop(selectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(memberSelectionProvider);
    final members = _toViewMembers(memberState);
    final visibleMembers = _visibleMembers(members);
    final isAllSelected = _isAllSelected(members);

    return Scaffold(
      backgroundColor: context.grays.white,
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
                onSearchPressed: _handleSearch,
                onChanged: _handleSearchChanged,
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            _SelectAllRow(
              isSelected: isAllSelected,
              onTap: () => _toggleAll(members),
            ),
            const SizedBox(height: AppSpacing.x8),
            Expanded(
              child: _buildMemberContent(
                state: memberState,
                visibleMembers: visibleMembers,
              ),
            ),
            _BottomActions(
              canConfirm: _selectedMemberIds.isNotEmpty,
              onCancel: () => Navigator.of(context).maybePop(),
              onConfirm: () => _handleConfirm(members),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberContent({
    required MemberSelectionState state,
    required List<MemberSelectionMember> visibleMembers,
  }) {
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

    if (visibleMembers.isEmpty) {
      return Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: visibleMembers.length,
      itemBuilder: (context, index) {
        final member = visibleMembers[index];

        return Column(
          children: [
            MemberSelectionItem(
              name: member.name,
              role: member.role,
              profileImageUrl: member.profileImageUrl,
              isSelected: _selectedMemberIds.contains(member.id),
              onTap: () => _toggleMember(member.id),
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
                width: 18.0,
                height: 18.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? context.brands.beatOrange1
                      : context.grays.gray7,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/check/check.svg',
                    width: 18.0,
                    height: 18.0,
                    colorFilter: ColorFilter.mode(
                      context.grays.white,
                      BlendMode.srcIn,
                    ),
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

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.canConfirm,
    required this.onCancel,
    required this.onConfirm,
  });

  final bool canConfirm;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              height: ButtonHeight.normal,
              onPressed: onCancel,
            ),
          ),
          const SizedBox(width: AppSpacing.x8),
          Expanded(
            child: AppButton(
              text: '확인',
              height: ButtonHeight.normal,
              isDisabled: !canConfirm,
              onPressed: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
