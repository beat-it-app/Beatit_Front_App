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
import 'package:beatit_front_app/src/domain/team/model/team_performance_model.dart';
import 'package:beatit_front_app/src/domain/team/model/team_schedule_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_upcoming_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_member_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_update_page.dart';
import 'package:beatit_front_app/src/domain/team/widget/team_invite_dialog.dart';
import 'package:beatit_front_app/src/domain/alarm/view/alarm_main_page.dart';

import '../../cloud/view/cloud_main_page.dart';

class TeamDetailPage extends ConsumerStatefulWidget {
  final TeamDetailModel? teamDetail;

  const TeamDetailPage({super.key, this.teamDetail});

  @override
  ConsumerState<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends ConsumerState<TeamDetailPage> {
  @override
  void initState() {
    super.initState();
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

  void _refreshAll() {
    ref.invalidate(currentTeamProvider);
    ref.read(teamDetailProvider.notifier).fetchTeamDetail();
    ref.invalidate(teamUpcomingPerformancesProvider);
    ref.invalidate(teamUpcomingSchedulesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final state = ref.watch(teamDetailProvider);
    final detail = widget.teamDetail ?? state.teamDetail;

    if (detail == null) {
      if (state.isLoading) {
        return Scaffold(
          backgroundColor: colors.surface,
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        backgroundColor: colors.surface,
        body: Center(
          child: Text(
            state.errorMessage ?? '팀 정보를 불러오는 중입니다...',
            style: FontStyles.med16.copyWith(color: context.grays.gray4),
          ),
        ),
      );
    }

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
                      .then((_) => _refreshAll());
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AlarmMainPage()));
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

                  // 4. 다가오는 일정 타이틀
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/team/title.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          context.colors.onSurface,
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

                  // 5. 다가오는 LIVE 공연 타이틀
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/team/title.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              context.colors.onSurface,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CloudMainPage(),
                        ),
                      );
                    },
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

  // 4. 다가오는 일정 섹션 (API 연동)
  Widget _buildScheduleSection(BuildContext context) {
    final scheduleAsync = ref.watch(teamUpcomingSchedulesProvider);

    return scheduleAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildScheduleEmpty(context),
      data: (schedules) {
        if (schedules.isEmpty) {
          return _buildScheduleEmpty(context);
        }

        // 전체 일정 중 가장 빠른 첫 번째 일정의 ID 확인
        final int earliestScheduleId = schedules.first.scheduleId;

        // 날짜(YYYY.MM.DD)별로 일정 그룹화
        final Map<String, List<TeamScheduleModel>> groupedByDate = {};
        for (final item in schedules) {
          final dt = item.startsAt;
          final dateKey = dt != null
              ? '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}'
              : '미정';
          groupedByDate.putIfAbsent(dateKey, () => []).add(item);
        }

        return Column(
          children: groupedByDate.entries.map((entry) {
            final firstDate = entry.value.first.startsAt;
            final dDayInfo = _calculateDDay(firstDate);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildScheduleDateGroup(
                context,
                dDayText: dDayInfo.dDayText,
                dateText: dDayInfo.dateDisplay,
                items: entry.value,
                earliestScheduleId: earliestScheduleId,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildScheduleEmpty(BuildContext context) {
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

  Widget _buildScheduleDateGroup(
    BuildContext context, {
    required String dDayText,
    required String dateText,
    required List<TeamScheduleModel> items,
    required int earliestScheduleId,
    Color? overrideColor,
  }) {
    final colors = Theme.of(context).colorScheme;
    final bool isTodayDDay = dDayText.trim().toUpperCase() == 'D-D';
    final Color badgeColor =
        overrideColor ?? (isTodayDDay ? colors.primary : colors.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                dDayText,
                style: FontStyles.semi10.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(dateText, style: FontStyles.med16),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          final bool isEarliest = item.scheduleId == earliestScheduleId;
          return _buildScheduleCard(
            context,
            item,
            isTodayDDay: isTodayDDay,
            isEarliest: isEarliest,
          );
        }),
      ],
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    TeamScheduleModel data, {
    required bool isTodayDDay,
    required bool isEarliest,
  }) {
    final colors = Theme.of(context).colorScheme;
    final bool isDimmed = !isTodayDDay;

    final String startTime = data.startsAt != null
        ? '${data.startsAt!.hour < 12 ? '오전' : '오후'}    ${(data.startsAt!.hour % 12 == 0 ? 12 : data.startsAt!.hour % 12).toString().padLeft(2, '0')}:${data.startsAt!.minute.toString().padLeft(2, '0')}'
        : '-';
    final String endTime = data.endsAt != null
        ? '${data.endsAt!.hour < 12 ? '오전' : '오후'}    ${(data.endsAt!.hour % 12 == 0 ? 12 : data.endsAt!.hour % 12).toString().padLeft(2, '0')}:${data.endsAt!.minute.toString().padLeft(2, '0')}'
        : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 4),
            // 1. 시간 컬럼
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  startTime,
                  style: FontStyles.reg14.copyWith(color: context.grays.gray2),
                ),
                Text(
                  endTime,
                  style: FontStyles.reg14.copyWith(color: context.grays.gray5),
                ),
              ],
            ),
            const SizedBox(width: 10),
            // 2. 세로 구분선
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(width: 1, color: context.grays.gray7),
            ),
            const SizedBox(width: 10),
            // 3. 3:1 비율 박스 카드
            Expanded(
              child: AspectRatio(
                aspectRatio: 3 / 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDimmed
                        ? context.grays.gray8.withOpacity(0.5)
                        : context.grays.gray8,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FontStyles.semi18.copyWith(
                                color: isDimmed
                                    ? context.grays.gray4
                                    : colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.locationName.isNotEmpty
                                  ? data.locationName
                                  : '장소 미지정',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FontStyles.med12.copyWith(
                                color: isDimmed
                                    ? context.grays.gray6
                                    : context.grays.gray4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Center(
                        child: _buildCheckIcon(
                          context,
                          isTodayDDay: isTodayDDay,
                          isEarliest: isEarliest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckIcon(
    BuildContext context, {
    required bool isTodayDDay,
    required bool isEarliest,
  }) {
    final colors = Theme.of(context).colorScheme;

    // 1. D-D(오늘)이고 가장 빠른 첫 일정: 채워진 주황색 원
    if (isTodayDDay && isEarliest) {
      return SvgPicture.asset(
        'assets/icons/check/check_round_on.svg',
        width: 25,
        height: 25,
        fit: BoxFit.contain,
      );
    }

    // 2. D-D(오늘)이고 당일 나머지 일정들: 주황색 점선 체크
    if (isTodayDDay && !isEarliest) {
      return SvgPicture.asset(
        'assets/icons/check/check_dot.svg',
        width: 25,
        height: 25,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          context.brands.beatOrange4,
          BlendMode.srcIn,
        ),
      );
    }

    // 3. D-숫자(미래 일정): 회색/검정 점선 체크
    return SvgPicture.asset(
      'assets/icons/check/check_dot.svg',
      width: 25,
      height: 25,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(context.grays.gray5, BlendMode.srcIn),
    );
  }

  ({String dDayText, String dateDisplay}) _calculateDDay(DateTime? date) {
    if (date == null) {
      return (dDayText: 'D-?', dateDisplay: '날짜 미정');
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final diffDays = targetDate.difference(today).inDays;

    final String dateDisplay =
        '${date.year}. ${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.'
        '${diffDays == 0 ? ' (오늘)' : ''}';

    String dDayText;
    if (diffDays == 0) {
      dDayText = 'D-D';
    } else if (diffDays > 0) {
      dDayText = 'D-$diffDays';
    } else {
      dDayText = 'D+${diffDays.abs()}';
    }

    return (dDayText: dDayText, dateDisplay: dateDisplay);
  }

  // 5. 다가오는 LIVE 공연 섹션 (API 연동)
  Widget _buildLiveConcertList(BuildContext context) {
    final performanceAsync = ref.watch(teamUpcomingPerformancesProvider);

    return performanceAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildLiveConcertEmpty(context),
      data: (performances) {
        if (performances.isEmpty) {
          return _buildLiveConcertEmpty(context);
        }
        return SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: performances.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildPerformanceCard(context, performances[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildLiveConcertEmpty(BuildContext context) {
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

  Widget _buildPerformanceCard(
    BuildContext context,
    TeamPerformanceModel performance,
  ) {
    final colors = Theme.of(context).colorScheme;
    final date = performance.performanceDateTime;
    final String dateStr = date != null
        ? '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}'
        : '-';

    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                (performance.posterImageUrl != null &&
                    performance.posterImageUrl!.isNotEmpty)
                ? Image.network(
                    performance.posterImageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: context.grays.gray7,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 24),
                      ),
                    ),
                  )
                : Container(
                    color: context.grays.gray7,
                    child: const Center(
                      child: Icon(Icons.music_note, size: 28),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performance.title,
                  style: FontStyles.semi14.copyWith(color: colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 상단 프로필 헤더
  Widget _buildHeader(BuildContext context, TeamDetailModel detail) {
    final colors = Theme.of(context).colorScheme;
    final bool hasImage =
        detail.teamImageUrl != null && detail.teamImageUrl!.trim().isNotEmpty;

    String dateDisplay = '-';
    if (detail.establishedOn != null &&
        detail.establishedOn!.trim().isNotEmpty) {
      final raw = detail.establishedOn!.trim();
      dateDisplay = raw.length >= 10
          ? raw.substring(0, 10).replaceAll('-', '.')
          : raw;
    }

    final bool hasLinks = detail.links.any(
      (link) => link.linkUrl.trim().isNotEmpty,
    );

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
            bottom: 42,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'band',
                    style: FontStyles.reg12.copyWith(color: Colors.white),
                  ),
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
                if (hasLinks) ...[
                  const SizedBox(height: 18),
                  _buildDynamicSocialLinks(detail.links),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              width: 11,
              height: 11,
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
                    width: 10,
                    height: 10,
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
                Text('', style: FontStyles.semi16),
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
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 68),
                child: Text(
                  member.userName.isNotEmpty ? member.userName : '이름 없음',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: FontStyles.semi16.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 68),
                child: Text(
                  (member.position != null &&
                          member.position!.trim().isNotEmpty)
                      ? member.position!
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
              ),
            ],
          );
        },
      ),
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
