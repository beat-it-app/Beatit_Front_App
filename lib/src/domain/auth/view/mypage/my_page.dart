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

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myPageProvider.notifier).fetchMyPage();
    });
  }

  void _openTeamSwitchSheet() {
    TeamSwitchBottomSheet.show(context);
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
        final key = account.toUpperCase().trim();
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
        userProfileUrl != null && userProfileUrl.isNotEmpty;

    // API 변경: teams(List) → team(단일 객체)
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
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.x8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 정보 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: context.colors.primary,
                    child: hasProfileImage
                        ? ClipOval(
                            child: Image.network(
                              userProfileUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.music_note,
                                  color: Colors.black,
                                  size: 28,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.music_note,
                            color: Colors.black,
                            size: 28,
                          ),
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
            const SizedBox(height: AppSpacing.x24),

            Container(
              height: 6,
              width: double.infinity,
              color: context.grays.gray8,
            ),

            const SizedBox(height: AppSpacing.x16),

            // 현재 팀 타이틀
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '현재 팀',
                    style: FontStyles.bold18.copyWith(color: colors.onSurface),
                  ),

                  // 다른 팀 전환 API 연결 전까지 아무 동작도 하지 않음
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
                    onPressed: _openTeamSwitchSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.x12),

            // 현재 팀 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // 배경 이미지
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

                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.x20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTeam?.type ?? 'Band',
                              style: FontStyles.med14.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              currentTeam?.name ?? '소속된 팀이 없습니다',
                              style: FontStyles.bold22.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentTeam != null
                                  ? '${currentTeam.leaderName} 외 ${currentTeam.memberCount > 1 ? currentTeam.memberCount - 1 : 0}명'
                                  : '팀을 생성하거나 참여해보세요',
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

            // 설정 메뉴 리스트
            _SettingTile(title: '알림 설정', onTap: () {}),
            _SettingTile(title: '화면 설정', onTap: () {}),
            _SettingTile(title: '서비스 약관', onTap: () {}),
            _SettingTile(title: '고객 지원', onTap: () {}),
            _SettingTile(title: '로그아웃', onTap: () {}),
            _SettingTile(title: '탈퇴하기', onTap: () {}),

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
