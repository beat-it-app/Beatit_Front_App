import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/team/model/team_member_model.dart';
import 'package:beatit_front_app/src/domain/team/model/team_member_position_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_member_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_select_page.dart';

class TeamMemberPage extends ConsumerStatefulWidget {
  const TeamMemberPage({super.key});

  @override
  ConsumerState<TeamMemberPage> createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends ConsumerState<TeamMemberPage> {
  // 모드 구분: 'normal', 'manager', 'leader', 'position'
  String _currentMode = 'normal';

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // 수정 모드 상태값
  final Map<String, bool> _tempManagerStates = {};
  String? _tempLeaderPublicId;
  final Map<int, TextEditingController> _tempPositionControllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamMemberProvider.notifier).fetchMembers();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    for (var controller in _tempPositionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(teamMemberProvider.notifier).fetchMembers(query: query);
    });
  }

  // 대표/운영진 수정 모드 진입
  void _startEditing(String mode, List<TeamMemberModel> members) {
    setState(() {
      _currentMode = mode;
      if (mode == 'manager') {
        _tempManagerStates.clear();
        for (var m in members) {
          _tempManagerStates[m.userPublicId] = m.isManager;
        }
      } else if (mode == 'leader') {
        final currentLeader = members.firstWhere(
          (m) => m.isLeader,
          orElse: () => members.first,
        );
        _tempLeaderPublicId = currentLeader.userPublicId;
      }
    });
  }

  // 포지션 수정 모드 진입 (GET /teams/members/position 호출)
  Future<void> _startPositionEditing() async {
    setState(() => _currentMode = 'position');
    await ref.read(teamMemberProvider.notifier).fetchMemberPositions();

    final positionMembers = ref.read(teamMemberProvider).positionMembers;
    for (var controller in _tempPositionControllers.values) {
      controller.dispose();
    }
    _tempPositionControllers.clear();

    for (var m in positionMembers) {
      _tempPositionControllers[m.userId] = TextEditingController(
        text: m.position ?? '',
      );
    }
    setState(() {});
  }

  // FAB 버튼을 눌렀을 때 API 호출 처리
  Future<void> _handleSave() async {
    final notifier = ref.read(teamMemberProvider.notifier);
    final state = ref.read(teamMemberProvider);
    bool isSuccess = true;

    if (_currentMode == 'leader') {
      if (_tempLeaderPublicId != null) {
        isSuccess = await notifier.assignLeader(_tempLeaderPublicId!);
      }
    } else if (_currentMode == 'manager') {
      final Map<String, bool> changed = {};
      for (var m in state.members) {
        final original = m.isManager;
        final temp = _tempManagerStates[m.userPublicId] ?? original;
        if (original != temp) {
          changed[m.userPublicId] = temp;
        }
      }

      if (changed.isNotEmpty) {
        isSuccess = await notifier.updateManagerRoles(changed);
      }
    } else if (_currentMode == 'position') {
      final List<Map<String, dynamic>> positionPayload = [];
      for (var m in state.positionMembers) {
        final text = _tempPositionControllers[m.userId]?.text.trim();
        positionPayload.add({
          'userId': m.userId,
          'position': (text == null || text.isEmpty) ? null : text,
        });
      }

      isSuccess = await notifier.updatePositions(positionPayload);
    }

    if (!mounted) return;

    if (!isSuccess) {
      final updatedState = ref.read(teamMemberProvider);
      final errorMsg = updatedState.errorMessage ?? '변경에 실패했습니다.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));

      if (updatedState.errorCode == 'TEAM-012') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TeamSelectPage()),
          (route) => false,
        );
        return;
      }
    } else {
      await notifier.fetchMembers();
      if (!mounted) return;
      setState(() {
        _currentMode = 'normal';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('변경 사항이 성공적으로 저장되었습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 대표 변경 팝업
  Future<void> _showLeaderPopup({
    required List<TeamMemberModel> members,
    required VoidCallback onConfirm,
  }) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final originalLeader = members.firstWhere(
      (m) => m.isLeader,
      orElse: () => members.first,
    );

    if (originalLeader.userPublicId == _tempLeaderPublicId) {
      setState(() => _currentMode = 'normal');
      return;
    }

    final targetMember = members.firstWhere(
      (m) => m.userPublicId == _tempLeaderPublicId,
      orElse: () => members.first,
    );

    final confirmed = await AppPopup.show(
      context,
      title: '대표 변경',
      warningType: WarningType.none,
      contentType: ContentType.large,
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.vertical,
      confirmText: '확인',
      cancelText: '취소',
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 90,
            height: 104,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ClipOval(
                  child: _buildProfileImage(
                    targetMember.profileImageUrl,
                    size: 90,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.grays.gray1,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '대표',
                      style: FontStyles.med14.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: FontStyles.semi18.copyWith(color: colorScheme.onSurface),
              children: [
                TextSpan(
                  text: targetMember.name,
                  style: FontStyles.semi18.copyWith(color: colorScheme.primary),
                ),
                TextSpan(
                  text: ' 님으로\n대표를 변경하시겠습니까?',
                  style: FontStyles.semi18.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirmed == true) {
      onConfirm();
    }
  }

  void _onFabPressed(List<TeamMemberModel> members) {
    if (_currentMode == 'leader') {
      _showLeaderPopup(members: members, onConfirm: () => _handleSave());
    } else {
      _handleSave();
    }
  }

  Widget _buildProfileImage(String? url, {double size = 56}) {
    if (url != null && url.trim().isNotEmpty) {
      return Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/team/team_view_profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      'assets/images/team/team_view_profile.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(teamMemberProvider);
    final members = state.members;
    final positionMembers = state.positionMembers;

    // 💡 myRole에 따른 권한 계산
    final String myRole = (state.myRole ?? '').trim().toUpperCase();
    final bool isLeader = myRole == 'LEADER';
    final bool isManager = myRole == 'MANAGER';
    final bool canEdit = isLeader || isManager;

    // 💡 권한별 드롭다운 메뉴 리스트 동적 구성
    final List<AppDropdownItem> menuItems = [];

    // 1. 운영진 수정 (LEADER, MANAGER 가능)
    if (isLeader || isManager) {
      menuItems.add(
        AppDropdownItem(
          label: '운영진 수정',
          onPressed: () {
            if (_currentMode == 'manager') {
              setState(() => _currentMode = 'normal');
            } else {
              _startEditing('manager', members);
            }
          },
        ),
      );
    }

    // 2. 대표 수정 (LEADER만 가능)
    if (isLeader) {
      menuItems.add(
        AppDropdownItem(
          label: '대표 수정',
          onPressed: () {
            if (_currentMode == 'leader') {
              setState(() => _currentMode = 'normal');
            } else {
              _startEditing('leader', members);
            }
          },
        ),
      );
    }

    // 3. 포지션 수정 (LEADER, MANAGER 가능)
    if (isLeader || isManager) {
      menuItems.add(
        AppDropdownItem(
          label: '포지션 수정',
          onPressed: () {
            if (_currentMode == 'position') {
              setState(() => _currentMode = 'normal');
            } else {
              _startPositionEditing();
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 💡 일반 멤버(MEMBER)인 경우 더보기 메뉴 자체를 숨기거나(backOnly), 편집 권한이 있을 때만 backMore 노출
      appBar: canEdit
          ? AppTopAppBar.backMore(
              onBackPressed: () {
                if (_currentMode != 'normal') {
                  setState(() => _currentMode = 'normal');
                } else {
                  Navigator.of(context).pop();
                }
              },
              onMorePressed: () {},
              moreMenuOffset: const Offset(-20, 56),
              moreMenuItems: menuItems,
            )
          : AppTopAppBar.backOnly(
              onBackPressed: () => Navigator.of(context).pop(),
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x12),
              Text(
                '멤버 목록',
                style: FontStyles.bold34.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.x16),

              // 포지션 수정 모드가 아닐 때만 검색창 노출
              if (_currentMode != 'position') ...[
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.grays.gray8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: '찾고 싶은 멤버를 검색하세요.',
                            hintStyle: FontStyles.reg18.copyWith(
                              color: context.grays.gray5,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/icons/cal/search.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          context.grays.gray5,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x20),
              ],

              // 멤버 리스트 (모드에 따라 분기)
              Expanded(
                child:
                    state.isLoading &&
                        (_currentMode == 'position'
                            ? positionMembers.isEmpty
                            : members.isEmpty)
                    ? const Center(child: CircularProgressIndicator())
                    : _currentMode == 'position'
                    ? _buildPositionListView(positionMembers, colors)
                    : _buildStandardListView(members, colors),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentMode != 'normal'
          ? Opacity(
              opacity: 0.9,
              child: SizedBox(
                width: 70,
                height: 58,
                child: FloatingActionButton(
                  backgroundColor: colors.primary,
                  elevation: 4,
                  onPressed: () => _onFabPressed(members),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/icons/check/check.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
            )
          : null,
    );
  }

  // 1. 일반 / 대표 수정 / 운영진 수정 목록 렌더링
  Widget _buildStandardListView(
    List<TeamMemberModel> members,
    ColorScheme colors,
  ) {
    if (members.isEmpty) {
      return Center(
        child: Text(
          '멤버가 없습니다.',
          style: FontStyles.med16.copyWith(color: context.grays.gray5),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: _currentMode != 'normal' ? 96.0 : 16.0),
      itemCount: members.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.x16),
      itemBuilder: (context, index) {
        final member = members[index];
        final id = member.userPublicId;
        final name = member.name;
        final isLeader = member.isLeader;
        final isManager = member.isManager;
        final positionText = member.position ?? '미지정';

        Widget? rightWidget;

        if (_currentMode == 'normal') {
          if (isLeader) {
            rightWidget = Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: context.grays.gray1,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '대표',
                style: FontStyles.med14.copyWith(color: Colors.white),
              ),
            );
          } else if (isManager) {
            rightWidget = Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: context.grays.gray8,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '운영진',
                style: FontStyles.med14.copyWith(color: context.grays.gray1),
              ),
            );
          }
        } else if (_currentMode == 'leader') {
          final isTempLeader = (_tempLeaderPublicId == id);

          if (isTempLeader) {
            rightWidget = OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: context.grays.gray1,
                side: BorderSide(color: context.grays.gray1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/check/check.svg',
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '대표',
                    style: FontStyles.med14.copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          } else {
            rightWidget = OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.grays.gray7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                setState(() => _tempLeaderPublicId = id);
              },
              child: Text(
                '+ 대표',
                style: FontStyles.med14.copyWith(color: colors.onSurface),
              ),
            );
          }
        } else if (_currentMode == 'manager') {
          if (isLeader) {
            rightWidget = Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: context.grays.gray2,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '대표',
                style: FontStyles.med12.copyWith(color: Colors.white),
              ),
            );
          } else {
            final isTempManager = _tempManagerStates[id] ?? false;

            if (isTempManager) {
              rightWidget = OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() => _tempManagerStates[id] = false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/check/check.svg',
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        colors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '운영진',
                      style: FontStyles.med14.copyWith(color: colors.primary),
                    ),
                  ],
                ),
              );
            } else {
              rightWidget = OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.grays.gray7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() => _tempManagerStates[id] = true);
                },
                child: Text(
                  '+ 운영진',
                  style: FontStyles.med14.copyWith(color: colors.onSurface),
                ),
              );
            }
          }
        }

        return Row(
          children: [
            ClipOval(
              child: _buildProfileImage(member.profileImageUrl, size: 56),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: FontStyles.semi20.copyWith(color: colors.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    positionText,
                    style: FontStyles.reg16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ],
              ),
            ),
            if (rightWidget != null) rightWidget,
          ],
        );
      },
    );
  }

  // 2. 포지션 수정 모드 전용 리스트 렌더링 (GET /teams/members/position 바인딩)
  Widget _buildPositionListView(
    List<TeamMemberPositionModel> positionMembers,
    ColorScheme colors,
  ) {
    if (positionMembers.isEmpty) {
      return Center(
        child: Text(
          '포지션을 수정할 멤버가 없습니다.',
          style: FontStyles.med16.copyWith(color: context.grays.gray5),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 96.0),
      itemCount: positionMembers.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.x16),
      itemBuilder: (context, index) {
        final member = positionMembers[index];
        final controller = _tempPositionControllers[member.userId];

        return Row(
          children: [
            ClipOval(
              child: _buildProfileImage(member.profileImageUrl, size: 56),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                member.userName,
                style: FontStyles.semi20.copyWith(color: colors.onSurface),
              ),
            ),
            SizedBox(
              width: 140,
              height: 46,
              child: TextField(
                controller: controller,
                maxLength: 10,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) => null,
                style: FontStyles.reg18.copyWith(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: '없음',
                  hintStyle: FontStyles.reg18.copyWith(
                    color: context.grays.gray5,
                  ),
                  filled: true,
                  fillColor: context.grays.gray8,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: context.grays.gray6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: context.grays.gray6),
                  ),
                  isDense: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
