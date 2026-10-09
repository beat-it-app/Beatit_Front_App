import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/team/model/team_detail_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_member_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_update_page.dart';
import 'package:beatit_front_app/src/domain/team/widget/team_invite_dialog.dart';

class TeamDetailPage extends ConsumerStatefulWidget {
  // 💡 TeamEntryPage에서 이미 가져온 팀 데이터를 직접 주입받을 수 있도록 설정
  final TeamDetailModel? teamDetail;

  const TeamDetailPage({super.key, this.teamDetail});

  @override
  ConsumerState<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends ConsumerState<TeamDetailPage> {
  @override
  void initState() {
    super.initState();
    // 외부에서 데이터를 주입받지 않은 경우(예: 직접 라우팅된 경우)에만 자체 API 호출
    if (widget.teamDetail == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(teamDetailProvider.notifier).fetchTeamDetail();
      });
    }
  }

  Future<void> _launchUrlString(String urlStr) async {
    final uri = Uri.tryParse(urlStr);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // 💡 주입받은 데이터가 있으면 사용하고, 없으면 teamDetailProvider 상태 사용
    final state = ref.watch(teamDetailProvider);
    final TeamDetailModel? detail = widget.teamDetail ?? state.teamDetail;

    if (detail == null && state.isLoading) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (detail == null) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: Center(
          child: Text(
            state.errorMessage ?? '팀 정보를 찾을 수 없습니다.',
            style: FontStyles.med16.copyWith(color: context.grays.gray4),
          ),
        ),
      );
    }

    // myRole 권한 검사 (LEADER, MANAGER만 수정/공유 버튼 노출)
    final role = detail.myRole?.toUpperCase();
    final bool isManagerOrLeader = role == 'LEADER' || role == 'MANAGER';

    return Scaffold(
      backgroundColor: colors.surface,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64.0),
        child: AppTopAppBar.alarmOnly(
          onEditPressed: isManagerOrLeader
              ? () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const TeamUpdatePage(),
                        ),
                      )
                      .then((_) {
                        // 수정 후 복귀 시 최신 데이터 갱신
                        ref.invalidate(currentTeamProvider);
                        ref.read(teamDetailProvider.notifier).fetchTeamDetail();
                      });
                }
              : null,
          onSharePressed: isManagerOrLeader
              ? () {
                  showTeamInviteDialog(
                    context: context,
                    teamName: detail.teamName,
                    inviteCode: detail.inviteCode,
                  );
                }
              : null,
          onAlarmPressed: () {
            // 알림 액션
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 상단 프로필 헤더 (배경, 팀명, 개설일, SNS 링크)
            _buildHeader(context, detail),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.x24),

                  // 2. 밴드 소개 영역
                  _buildSectionTitle(context, '밴드 소개'),
                  const SizedBox(height: AppSpacing.x8),
                  Text(
                    detail.description != null &&
                            detail.description!.trim().isNotEmpty
                        ? detail.description!
                        : '등록된 소개글이 없습니다.',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray3,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.x20),

                  // 3. 멤버 목록 영역
                  _buildSectionTitle(
                    context,
                    '멤버 목록 (${detail.memberCount})',
                    trailingText: '더보기',
                    onTrailingTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TeamMemberPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  _buildMemberList(context, detail),

                  const SizedBox(height: AppSpacing.x30),

                  // 4. 다가오는 일정 영역
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/team/title.svg',
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          context.grays.gray4,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '다가오는 일정',
                        style: FontStyles.semi24.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x20),
                  _buildScheduleSection(context),

                  const SizedBox(height: AppSpacing.x30),

                  // 5. 다가오는 LIVE 공연 영역
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/team/title.svg',
                            width: 18,
                            height: 18,
                            colorFilter: ColorFilter.mode(
                              context.grays.gray4,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '다가오는 LIVE 공연',
                            style: FontStyles.semi24.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/icons/auth/back.svg',
                        width: 15,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                          colors.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  _buildLiveConcertList(context),

                  const SizedBox(height: AppSpacing.x30),

                  // 6. 하단 액션 버튼
                  _buildActionButton(
                    context,
                    svgPath: 'assets/icons/team/archive.svg',
                    title: '합주실/연습실 기록하기',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TeamArchiveListPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  _buildActionButton(
                    context,
                    svgPath: 'assets/icons/team/cloud.svg',
                    title: '팀 클라우드',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.x40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상단 프로필 헤더
  Widget _buildHeader(BuildContext context, TeamDetailModel detail) {
    final colors = Theme.of(context).colorScheme;
    final bool hasImage =
        detail.teamImageUrl != null && detail.teamImageUrl!.trim().isNotEmpty;

    // 개설일 포맷팅 (YYYY.MM.DD)
    String dateDisplay = '-';
    if (detail.establishedOn != null &&
        detail.establishedOn!.trim().isNotEmpty) {
      final raw = detail.establishedOn!.trim();
      dateDisplay = raw.length >= 10
          ? raw.substring(0, 10).replaceAll('-', '.')
          : raw;
    }

    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: hasImage
                ? Image.network(
                    detail.teamImageUrl!,
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'band',
                  style: FontStyles.reg12.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  detail.teamName,
                  style: FontStyles.bold28.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  '개설일  |  $dateDisplay',
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
                const SizedBox(height: 18),
                _buildDynamicSocialLinks(detail.links),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 등록된 SNS 링크 동적 생성
  Widget _buildDynamicSocialLinks(List<TeamLinkModel> links) {
    final validLinks = links
        .where((link) => link.linkUrl.trim().isNotEmpty)
        .toList();

    if (validLinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: validLinks.map((link) {
        String svgPath = 'assets/icons/team/link.svg';
        final code = link.platformCode.toUpperCase();

        if (code == 'INSTAGRAM') {
          svgPath = 'assets/icons/team/instagram.svg';
        } else if (code == 'YOUTUBE') {
          svgPath = 'assets/icons/team/youtube.svg';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: _buildSocialCircle(
            svgPath,
            onTap: () => _launchUrlString(link.linkUrl),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSocialCircle(String svgPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    String? trailingText,
    bool showArrow = false,
    VoidCallback? onTrailingTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/team/title.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                context.grays.gray4,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: FontStyles.reg14.copyWith(color: context.grays.gray4),
            ),
          ],
        ),
        if (trailingText != null || showArrow)
          GestureDetector(
            onTap: onTrailingTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (trailingText != null)
                  Text(
                    trailingText,
                    style: FontStyles.reg12.copyWith(
                      color: context.grays.gray4,
                    ),
                  ),
                if (showArrow || trailingText != null) ...[
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/auth/back.svg',
                    width: 12,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      context.grays.gray4,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // 멤버 목록 가로 스크롤
  Widget _buildMemberList(BuildContext context, TeamDetailModel detail) {
    if (detail.members.isEmpty) {
      return SizedBox(
        height: 110,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFF2C2C2E),
                  backgroundImage: AssetImage(
                    'assets/images/team/team_view_profile.png',
                  ),
                ),
                const SizedBox(height: 6),
                Text('미지정', style: FontStyles.semi16),
                const SizedBox(height: 2),
                Text(
                  '멤버',
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: detail.members.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final member = detail.members[index];
          final bool hasImage =
              member.profileImageUrl != null &&
              member.profileImageUrl!.trim().isNotEmpty;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF2C2C2E),
                backgroundImage: hasImage
                    ? NetworkImage(member.profileImageUrl!)
                    : const AssetImage(
                            'assets/images/team/team_view_profile.png',
                          )
                          as ImageProvider,
              ),
              const SizedBox(height: 6),
              Text(
                member.userName.isNotEmpty ? member.userName : '이름 없음',
                style: FontStyles.semi16.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                (member.position != null && member.position!.trim().isNotEmpty)
                    ? member.position!
                    : '',
                style: FontStyles.reg12.copyWith(color: context.grays.gray4),
              ),
            ],
          );
        },
      ),
    );
  }

  // 다가오는 일정 섹션 (빈 상태)
  Widget _buildScheduleSection(BuildContext context) {
    return _buildEmptyBox(
      context,
      iconBgColor: context.brands.beatOrange3,
      iconWidget: SvgPicture.asset(
        'assets/icons/cal/calendar.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      title: '등록된 일정이 없습니다.',
      subtitle: '캘린더에서 일정을 추가해보세요.',
    );
  }

  // 다가오는 LIVE 공연 섹션 (빈 상태)
  Widget _buildLiveConcertList(BuildContext context) {
    return _buildEmptyBox(
      context,
      iconBgColor: context.grays.gray1,
      iconWidget: SvgPicture.asset(
        'assets/icons/team/mic.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      title: '등록된 LIVE 공연이 없습니다.',
      subtitle: '가장 먼저 공연을 등록해보세요.',
    );
  }

  Widget _buildEmptyBox(
    BuildContext context, {
    required Widget iconWidget,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: FontStyles.med16.copyWith(color: context.grays.gray4),
                ),
                Text(
                  subtitle,
                  style: FontStyles.semi18.copyWith(color: colors.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String svgPath,
    required String title,
    double height = 60,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.grays.gray1,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: FontStyles.med16.copyWith(color: Colors.white),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/auth/back.svg',
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
