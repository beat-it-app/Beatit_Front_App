import 'package:beatit_front_app/src/domain/alarm/view/alarm_main_page.dart';
import 'package:beatit_front_app/src/domain/alarm/view/alarm_setting_page.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/mypage/team_manage_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/mypage/withdrawal_type_select_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';

import '../../model/mypage/mypage_model.dart';
import '../../provider/mypage_provider.dart';
import '../../widget/team_switch_bottom_sheet.dart';
import 'display_setting_page.dart';
import 'profile_edit_page.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);

    try {
      await ref.read(authProvider.notifier).logout();
      ref.invalidate(myPageProvider);
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SigninPage()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myPageProvider.notifier).fetchMyPage();
    });
  }

  Future<void> _openTeamSwitchSheet(int? currentTeamId) async {
    await TeamSwitchBottomSheet.show(context, currentTeamId: currentTeamId);
    if (mounted) {
      ref.read(myPageProvider.notifier).fetchMyPage();
    }
  }

  Future<void> _openProfileEditPage() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileEditPage()));
    if (mounted) {
      ref.read(myPageProvider.notifier).fetchMyPage();
    }
  }

  Widget _buildSocialBadges(List<String> socialAccounts) {
    if (socialAccounts.isEmpty) return const SizedBox.shrink();

    final Map<String, String> socialIconPaths = {
      'APPLE': 'assets/icons/auth/apple_profile.svg',
      'GOOGLE': 'assets/icons/auth/google_profile.svg',
      'KAKAO': 'assets/icons/auth/kakao_profile.svg',
      'NAVER': 'assets/icons/auth/naver_profile.svg',
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: socialAccounts.map((account) {
        final key = account.trim().toUpperCase();
        final iconPath = socialIconPaths[key];

        if (iconPath == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: SvgPicture.asset(iconPath, width: 14, height: 14),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(myPageProvider);

    if (state.isLoading && state.data == null) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final data = state.data;

    final userProfileUrl = data?.profileImageUrl?.trim();
    final bool hasProfileImage =
        userProfileUrl != null &&
        userProfileUrl.isNotEmpty &&
        userProfileUrl != 'string';

    final currentTeam = data?.team;
    final teamImageUrl = currentTeam?.imageUrl?.trim();
    final bool hasTeamImage =
        teamImageUrl != null &&
        teamImageUrl.isNotEmpty &&
        teamImageUrl != 'string';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/appbar/bell.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AlarmMainPage()));
            },
          ),
          const SizedBox(width: AppSpacing.x8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 정보 영역
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _openProfileEditPage,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: context.colors.primary,
                      backgroundImage: hasProfileImage
                          ? NetworkImage(userProfileUrl)
                          : null,
                      child: !hasProfileImage
                          ? const Icon(
                              Icons.music_note,
                              color: Colors.black,
                              size: 28,
                            )
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.x16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data?.userName ?? '사용자',
                            style: FontStyles.semi20.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildSocialBadges(data?.socialAccounts ?? []),
                              Text(
                                data?.email ?? '',
                                style: FontStyles.reg16.copyWith(
                                  color: context.grays.gray3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/auth/back.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        colors.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x24),

            Container(
              height: 6,
              width: double.infinity,
              color: context.grays.gray8,
            ),

            const SizedBox(height: AppSpacing.x16),

            // 현재 팀 타이틀 & 전환 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '현재 팀',
                    style: FontStyles.bold18.copyWith(color: colors.onSurface),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: SvgPicture.asset(
                      'assets/icons/auth/team_change.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        colors.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => _openTeamSwitchSheet(currentTeam?.teamId),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.x12),

            // 현재 팀 카드 (클릭 불가)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: const Color(0xFF1C1C1E),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: hasTeamImage
                            ? Image.network(
                                teamImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/team/team_view_profile.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/team/team_view_profile.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned.fill(
                        child: Container(color: Colors.black.withOpacity(0.5)),
                      ),
                      Positioned(
                        top: AppSpacing.x20,
                        right: AppSpacing.x20,
                        child: Image.asset(
                          'assets/images/auth/profile_orange.png',
                          width: 46,
                          height: 46,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.x20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTeam?.type ?? '',
                              style: FontStyles.med14.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              currentTeam?.name ?? '현재 참여 중인 팀이 없습니다.',
                              style: FontStyles.bold22.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentTeam != null
                                  ? '${currentTeam.leaderName} 외 ${currentTeam.memberCount > 1 ? currentTeam.memberCount - 1 : 0}명'
                                  : '+ 버튼을 눌러 팀을 생성해보세요.',
                              style: FontStyles.reg16.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.x24),

            Container(
              height: 6,
              width: double.infinity,
              color: context.grays.gray8,
            ),

            // 설정 목록
            _SettingTile(
              title: '알림 설정',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AlarmSettingPage()),
                );
              },
            ),
            _SettingTile(
              title: '화면 설정',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DisplaySettingPage()),
                );
              },
            ),

            // 💡 myRole이 LEADER 또는 MANAGER일 때만 노출
            if (currentTeam?.isLeaderOrManager ?? false)
              _SettingTile(
                title: '팀 관리하기',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TeamManagePage(
                        establishedOn: currentTeam?.establishedOn,
                      ),
                    ),
                  );
                },
              ),

            _SettingTile(title: '서비스 약관', onTap: () {}),
            _SettingTile(title: '고객 지원', onTap: () {}),
            _SettingTile(
              title: _isLoggingOut ? '로그아웃 중...' : '로그아웃',
              onTap: _logout,
            ),
            _SettingTile(
              title: '탈퇴하기',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const WithdrawalTypeSelectPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.x30),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x20,
        vertical: 2,
      ),
      title: Text(
        title,
        style: FontStyles.semi16.copyWith(color: colors.onSurface),
      ),
      trailing: SvgPicture.asset(
        'assets/icons/auth/back.svg',
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(
          context.colors.onSurface,
          BlendMode.srcIn,
        ),
      ),
      onTap: onTap,
    );
  }
}
