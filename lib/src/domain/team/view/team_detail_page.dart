import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart'; // 💡 AppTopAppBar 경로 확인 후 사용

class TeamDetailPage extends StatelessWidget {
  const TeamDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      extendBodyBehindAppBar: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64.0),
        child: Theme(
          data: theme.copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
          ),
          child: AppTopAppBar.alarmOnly(
            onAlarmPressed: () {
              print('알림 클릭됨');
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 상단 프로필 헤더 영역
            _buildHeader(context),

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
                    '안녕하세요, 잘나가는 밴드입니다.\n소소하고 행복한 음악을 즐기는 대학생 연합 밴드입니다.\n함께 즐거운 공연해요\n\n정기 공연일: 매달 둘째주 토요일 18시\n장소 공지: 전주 금요일 14시',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray3,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.x20),

                  // 3. 멤버 목록 영역
                  _buildSectionTitle(
                    context,
                    '멤버 목록 (10)',
                    trailingText: '더보기',
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  _buildMemberList(context),

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
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  _buildActionButton(
                    context,
                    svgPath: 'assets/icons/team/cloud.svg',
                    title: '팀 클라우드',
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

  // 상단 프로필 헤더 (기존 내부 알림 버튼 아이콘은 제거되고 AppTopAppBar로 통합)
  Widget _buildHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. 프로필 배경 사진
          Positioned.fill(
            child: Image.asset(
              'assets/images/team/team_view_profile.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. 어두운 그라데이션 오버레이
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

          // 3. 고정 프로필 타이틀 영역
          Positioned(
            top: 200,
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
                  '잘나가는 밴드',
                  style: FontStyles.bold28.copyWith(color: colors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  '개설일  |  2026.04.06',
                  style: FontStyles.reg12.copyWith(color: context.grays.gray4),
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialCircle('assets/icons/team/instagram.svg'),
                    const SizedBox(width: 12),
                    _buildSocialCircle('assets/icons/team/youtube.svg'),
                    const SizedBox(width: 12),
                    _buildSocialCircle('assets/icons/team/link.svg'),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SNS 로고 원형 아이콘 생성 함수
  Widget _buildSocialCircle(String svgPath) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: SvgPicture.asset(
          svgPath,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.6),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  // 섹션 타이틀
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

  // 멤버 목록
  Widget _buildMemberList(BuildContext context) {
    final members = [
      {'name': '송하은', 'role': '베이스'},
      {'name': '노영서', 'role': '드럼'},
      {'name': '김지원', 'role': '보컬 1'},
      {'name': '이기주', 'role': '기타'},
      {'name': '박민수', 'role': '키보드'},
      {'name': '최유진', 'role': '보컬 2'},
      {'name': '정현우', 'role': '세컨 기타'},
      {'name': '한소희', 'role': '퍼커션'},
      {'name': '윤도현', 'role': '작곡/서브'},
      {'name': '강하늘', 'role': '매니저'},
    ];

    final displayMembers = members.take(10).toList();

    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: displayMembers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 28),
        itemBuilder: (context, index) {
          final member = displayMembers[index];

          return Column(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(
                  'assets/images/team/team_view_profile.png',
                ),
              ),
              const SizedBox(height: 4),
              Text(member['name']!, style: FontStyles.semi18),
              Text(
                member['role']!,
                style: FontStyles.reg14.copyWith(color: context.grays.gray4),
              ),
            ],
          );
        },
      ),
    );
  }

  // 일정 섹션
  Widget _buildScheduleSection(BuildContext context) {
    return Column(
      children: [
        _buildScheduleDateGroup(
          context,
          dDayText: 'D-D',
          dateText: '2026. 04. 14 (오늘)',
          items: [
            _ScheduleCardData(
              title: '04.14 두 번째 합주',
              location: '그라운드 합주일 본점 A3',
              startTime: '오전    11:00',
              endTime: '오후    13:00',
              isChecked: true,
            ),
            _ScheduleCardData(
              title: '04.14 세 번째 합주',
              location: '그라운드 합주일 본점 A3',
              startTime: '오후    14:00',
              endTime: '오후    16:00',
              isChecked: false,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildScheduleDateGroup(
          context,
          dDayText: 'D-1',
          dateText: '2026. 04. 15',
          items: [
            _ScheduleCardData(
              title: '04.14 네 번째 합주',
              location: '그라운드 합주일 본점 A3',
              startTime: '오전    10:00',
              endTime: '오전    12:00',
              isChecked: false,
              isDimmed: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleDateGroup(
    BuildContext context, {
    required String dDayText,
    required String dateText,
    required List<_ScheduleCardData> items,
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
        ...items.map((item) => _buildScheduleCard(context, item, isTodayDDay)),
      ],
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    _ScheduleCardData data,
    bool isTodayDDay,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 4),
            // 1. 시간 영역 (상단 정렬)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.startTime,
                  style: FontStyles.reg14.copyWith(color: context.grays.gray2),
                ),
                Text(
                  data.endTime,
                  style: FontStyles.reg14.copyWith(color: context.grays.gray5),
                ),
              ],
            ),

            const SizedBox(width: 10),

            // 2. 구분선 막대
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(width: 1, color: context.grays.gray7),
            ),

            const SizedBox(width: 10),

            // 3. 카드 박스 영역 (3:1 비율)
            Expanded(
              child: AspectRatio(
                aspectRatio: 3 / 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: data.isDimmed
                        ? context.grays.gray8.withOpacity(0.5)
                        : context.grays.gray8,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.title,
                            style: FontStyles.semi18.copyWith(
                              color: data.isDimmed
                                  ? context.grays.gray4
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            data.location,
                            style: FontStyles.med12.copyWith(
                              color: data.isDimmed
                                  ? context.grays.gray4
                                  : context.grays.gray6,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: SvgPicture.asset(
                          data.isChecked
                              ? 'assets/icons/check/check_round_on.svg'
                              : 'assets/icons/check/check_dot.svg',
                          width: 25,
                          height: 25,
                          fit: BoxFit.contain,
                          colorFilter: (!data.isChecked && !isTodayDDay)
                              ? ColorFilter.mode(
                                  context.grays.gray5,
                                  BlendMode.srcIn,
                                )
                              : null,
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

  Widget _buildLiveConcertList(BuildContext context) {
    final concerts = [
      {'date': '2026. 04. 14', 'title': '뭔가 공연의 제목이겠지요 빗잇 빗잇'},
      {'date': '2026. 04. 14', 'title': '뭔가 공연의 제목'},
      {'date': '2026. 04. 14', 'title': '뭔가 공연의 제목이겠지요 빗잇 빗잇'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: concerts.map((concert) {
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 166,
                  decoration: BoxDecoration(
                    color: context.grays.gray8,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: context.grays.gray6, width: 1),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  concert['date']!,
                  style: FontStyles.reg16.copyWith(color: context.grays.gray4),
                ),
                Text(
                  concert['title']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.semi18,
                ),
              ],
            ),
          );
        }).toList(),
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

// 일정 카드 데이터 모델
class _ScheduleCardData {
  final String title;
  final String location;
  final String startTime;
  final String endTime;
  final bool isChecked;
  final bool isDimmed;

  _ScheduleCardData({
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    this.isChecked = false,
    this.isDimmed = false,
  });
}
