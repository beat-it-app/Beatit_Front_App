// lib/src/domain/mypage/view/team_manage_page.dart
import 'package:beatit_front_app/src/domain/auth/view/mypage/team_delete_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_member_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

import '../../../team/provider/team_detail_provider.dart';
import '../../provider/mypage_provider.dart';

class TeamManagePage extends ConsumerWidget {
  final String? establishedOn;

  const TeamManagePage({super.key, this.establishedOn});

  String _formatEstablishedDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return '개설일 미등록';
    }
    final clean = rawDate.trim();
    if (clean.length >= 10) {
      final ymd = clean.substring(0, 10);
      final parts = ymd.split('-');
      if (parts.length == 3) {
        return '${parts[0]}. ${parts[1]}. ${parts[2]} 개설';
      }
      return '${ymd.replaceAll('-', '.')} 개설';
    }
    return '$clean 개설';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final team = ref.watch(myPageProvider).data?.team;

    final teamName = team?.name ?? '현재 팀';
    final teamType = team?.type ?? 'Band';
    final rawDate = team?.establishedOn ?? establishedOn;

    // 💡 권한 체크
    final bool isLeader = team?.isLeader ?? false;
    final bool isLeaderOrManager = team?.isLeaderOrManager ?? false;

    final imageUrl = team?.imageUrl?.trim();
    final bool hasImage =
        imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'string';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
                child: Text(
                  '팀 관리하기',
                  style: FontStyles.bold34.copyWith(
                    color: colors.onSurface,
                    letterSpacing: -0.68,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x20),

              // ── 상단 팀 정보 배너 ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF140D0B),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: hasImage
                            ? Image.network(
                                imageUrl,
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
                        child: Container(color: Colors.black.withOpacity(0.55)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.x20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teamType,
                              style: FontStyles.med14.copyWith(
                                color: context.brands.beatOrange2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x16),
                            Text(
                              teamName,
                              style: FontStyles.bold28.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatEstablishedDate(rawDate),
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x30),

              Container(
                height: 6,
                width: double.infinity,
                color: context.grays.gray8,
              ),

              // ── 메뉴 목록 ──
              // 1. 팀 페이지 수정: 매니저 or 리더 가능
              if (isLeaderOrManager)
                _ManageMenuTile(
                  title: '팀 페이지 수정',
                  onTap: () async {
                    if (ref.read(teamDetailProvider).teamDetail == null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                      try {
                        await ref
                            .read(teamDetailProvider.notifier)
                            .fetchTeamDetail();
                      } finally {
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    }

                    if (!context.mounted) return;

                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const TeamUpdatePage(),
                          ),
                        )
                        .then((_) {
                          ref.read(myPageProvider.notifier).fetchMyPage();
                          ref
                              .read(teamDetailProvider.notifier)
                              .fetchTeamDetail();
                        });
                  },
                ),

              // 2. 멤버 관리하기: 매니저 or 리더 가능
              if (isLeaderOrManager)
                _ManageMenuTile(
                  title: '멤버 관리하기',
                  subtitle: '팀 대표, 운영진, 포지션을 수정할 수 있어요.',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TeamMemberPage()),
                    );
                  },
                ),

              // 3. 팀 삭제하기: 오직 리더(LEADER)만 가능
              if (isLeader)
                _ManageMenuTile(
                  title: '팀 삭제하기',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TeamDeletePage(teamName: teamName),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManageMenuTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ManageMenuTile({
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x20,
          vertical: 18,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontStyles.semi16.copyWith(color: colors.onSurface),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/auth/back.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
