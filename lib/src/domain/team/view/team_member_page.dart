import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';

class TeamMemberPage extends StatefulWidget {
  const TeamMemberPage({super.key});

  @override
  State<TeamMemberPage> createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends State<TeamMemberPage> {
  // 모드 구분: 'normal' (기본 화면), 'manager' (운영진 수정), 'leader' (대표 수정), 'position' (포지션 수정)
  String _currentMode = 'normal';

  final TextEditingController _searchController = TextEditingController();

  // 예시 멤버 데이터 구조
  final List<Map<String, dynamic>> _members = [
    {
      'name': '권우혁',
      'part': '보컬 1',
      'isManager': true,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '김지영',
      'part': '일렉',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '김지원',
      'part': '보컬 2',
      'isManager': true,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '노영서',
      'part': '드럼',
      'isManager': false,
      'isLeader': true,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '박소연',
      'part': '건반',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '이기주',
      'part': '기타',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '이희빈',
      'part': '베이스',
      'isManager': true,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '전주현',
      'part': '기타',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '전주희',
      'part': '기타',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '김다인',
      'part': '기타',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '송하은',
      'part': '기타',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
    {
      'name': '이현영',
      'part': '기타',
      'isManager': false,
      'isLeader': false,
      'profileImage': 'assets/images/team/team_view_profile.png',
    },
  ];

  // 수정 모드 진입 시 임시로 변경 사항을 들고 있을 상태값들
  final Map<String, bool> _tempManagerStates = {};
  String? _tempLeaderName;
  final Map<String, TextEditingController> _tempPositionControllers = {};

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in _tempPositionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // 수정 모드로 진입할 때 초기 임시 데이터 세팅
  void _startEditing(String mode) {
    setState(() {
      _currentMode = mode;
      if (mode == 'manager') {
        _tempManagerStates.clear();
        for (var m in _members) {
          _tempManagerStates[m['name']] = m['isManager'];
        }
      } else if (mode == 'leader') {
        final currentLeader = _members.firstWhere(
          (m) => m['isLeader'] == true,
          orElse: () => _members.first,
        );
        _tempLeaderName = currentLeader['name'];
      } else if (mode == 'position') {
        for (var controller in _tempPositionControllers.values) {
          controller.dispose();
        }
        _tempPositionControllers.clear();
        for (var m in _members) {
          _tempPositionControllers[m['name']] = TextEditingController(
            text: m['part'],
          );
        }
      }
    });
  }

  // 실제 데이터 적용 로직 분리
  void _applyChanges() {
    setState(() {
      if (_currentMode == 'manager') {
        for (var m in _members) {
          if (_tempManagerStates.containsKey(m['name'])) {
            m['isManager'] = _tempManagerStates[m['name']]!;
          }
        }
      } else if (_currentMode == 'leader') {
        if (_tempLeaderName != null) {
          for (var m in _members) {
            m['isLeader'] = (m['name'] == _tempLeaderName);
          }
        }
      } else if (_currentMode == 'position') {
        for (var m in _members) {
          final name = m['name'];
          if (_tempPositionControllers.containsKey(name)) {
            m['part'] = _tempPositionControllers[name]!.text;
          }
        }
      }
      _currentMode = 'normal';
    });
  }

  // 팝업 표시 함수 (대표 변경 모드에서만 사용)
  Future<void> _showLeaderPopup({required VoidCallback onConfirm}) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final originalLeader = _members.firstWhere(
      (m) => m['isLeader'] == true,
      orElse: () => _members.first,
    );

    // 대표를 아무것도 바꾸지 않았거나 기존과 동일하다면 팝업 없이 바로 정상 복귀
    if (originalLeader['name'] == _tempLeaderName) {
      setState(() {
        _currentMode = 'normal';
      });
      return;
    }

    // 변경된 경우에만 대표 변경 팝업 노출
    final targetMember = _members.firstWhere(
      (m) => m['name'] == _tempLeaderName,
      orElse: () => _members.first,
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
                  child: Image.asset(
                    targetMember['profileImage'] ??
                        'assets/images/team/team_view_profile.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
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
                  text: _tempLeaderName,
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

  // 우측 하단 체크 버튼(반영하기) 눌렀을 때
  void _onFabPressed() {
    if (_currentMode == 'leader') {
      _showLeaderPopup(
        onConfirm: () {
          _applyChanges();
        },
      );
    } else {
      _applyChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppTopAppBar.backMore(
        onMorePressed: () {},
        moreMenuOffset: const Offset(-20, 56),
        moreMenuItems: [
          AppDropdownItem(
            label: '운영진 수정',
            onPressed: () {
              if (_currentMode == 'manager') {
                setState(() => _currentMode = 'normal');
              } else {
                _startEditing('manager');
              }
            },
          ),
          AppDropdownItem(
            label: '대표 수정',
            onPressed: () {
              if (_currentMode == 'leader') {
                setState(() => _currentMode = 'normal');
              } else {
                _startEditing('leader');
              }
            },
          ),
          AppDropdownItem(
            label: '포지션 수정',
            onPressed: () {
              if (_currentMode == 'position') {
                setState(() => _currentMode = 'normal');
              } else {
                _startEditing('position');
              }
            },
          ),
        ],
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

              // 검색창
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

              // 멤버 리스트
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: _currentMode != 'normal' ? 96.0 : 16.0,
                  ),
                  itemCount: _members.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.x16),
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    final name = member['name'] as String;
                    final part = member['part'] as String;
                    final isLeader = member['isLeader'] as bool;
                    final profileImage = member['profileImage'] as String;

                    Widget? rightWidget;

                    if (_currentMode == 'normal') {
                      if (isLeader) {
                        rightWidget = Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.grays.gray1,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '대표',
                            style: FontStyles.med14.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (member['isManager'] == true) {
                        rightWidget = Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.grays.gray8,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '운영진',
                            style: FontStyles.med14.copyWith(
                              color: context.grays.gray1,
                            ),
                          ),
                        );
                      }
                    } else if (_currentMode == 'leader') {
                      final isTempLeader = (_tempLeaderName == name);

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
                                style: FontStyles.med14.copyWith(
                                  color: Colors.white,
                                ),
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
                            setState(() {
                              _tempLeaderName = name;
                            });
                          },
                          child: Text(
                            '+ 대표',
                            style: FontStyles.med14.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        );
                      }
                    } else if (_currentMode == 'manager') {
                      if (isLeader) {
                        rightWidget = Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.grays.gray2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '대표',
                            style: FontStyles.med12.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        final isTempManager = _tempManagerStates[name] ?? false;

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
                              setState(() {
                                _tempManagerStates[name] = false;
                              });
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
                                  style: FontStyles.med14.copyWith(
                                    color: colors.primary,
                                  ),
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
                              setState(() {
                                _tempManagerStates[name] = true;
                              });
                            },
                            child: Text(
                              '+ 운영진',
                              style: FontStyles.med14.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                          );
                        }
                      }
                    } else if (_currentMode == 'position') {
                      final controller = _tempPositionControllers[name];
                      rightWidget = SizedBox(
                        width: 140,
                        height: 46,
                        child: TextField(
                          controller: controller,
                          style: FontStyles.reg18.copyWith(
                            color: colors.onSurface,
                          ),
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
                              borderSide: BorderSide(
                                color: context.grays.gray6,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: context.grays.gray6,
                              ),
                            ),
                            isDense: true,
                          ),
                        ),
                      );
                    }

                    return Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            profileImage,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: FontStyles.semi20.copyWith(
                                  color: colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              if (_currentMode != 'position')
                                Text(
                                  part,
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
                ),
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
                  onPressed: _onFabPressed,
                  child: SvgPicture.asset(
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
}
