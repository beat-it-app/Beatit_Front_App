import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/cards/app_card.dart';
import 'package:beatit_front_app/src/domain/team/model/my_team_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_select_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_create_start_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_join_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_detail_page.dart';

class TeamSelectPage extends ConsumerStatefulWidget {
  const TeamSelectPage({super.key});

  @override
  ConsumerState<TeamSelectPage> createState() => _TeamSelectPageState();
}

class _TeamSelectPageState extends ConsumerState<TeamSelectPage> {
  String? _selectedBox;
  bool _isNavigating = false; // 중복 화면 이동 방지 가드

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamSelectProvider.notifier).fetchMyTeams();
    });
  }

  // 카드 클릭 시 팀 활성화 API(POST /teams/select/{teamPublicId}) 호출 후 이동
  Future<void> _handleTeamCardTap(MyTeamModel team) async {
    if (_isNavigating) return;

    final success = await ref
        .read(teamSelectProvider.notifier)
        .selectTeam(team.teamPublicId);

    if (!mounted) return;

    if (success) {
      _isNavigating = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TeamDetailPage()),
      );
    } else {
      final errorMsg = ref.read(teamSelectProvider).errorMessage;
      if (errorMsg != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // 초기 진입 시 이미 활성 팀이 설정되어 있는 경우에만 자동 이동
    ref.listen<TeamSelectState>(teamSelectProvider, (previous, next) {
      if (next.hasActiveTeam && !_isNavigating && mounted) {
        _isNavigating = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TeamDetailPage()),
        );
      }
    });

    final state = ref.watch(teamSelectProvider);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: colors.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final List<MyTeamModel> myTeams = state.teams;
    final bool hasTeam = myTeams.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: hasTeam
          ? AppTopAppBar.backMore(
              title: '',
              onMorePressed: () {},
              moreMenuOffset: const Offset(-20, 56),
              moreMenuItems: [
                AppDropdownItem(
                  label: '팀 생성하기',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TeamCreatePage(),
                      ),
                    );
                  },
                ),
                AppDropdownItem(
                  label: '팀 참여하기',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TeamJoinPage(),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: hasTeam
            ? _buildTeamExistBody(context, myTeams)
            : _buildTeamEmptyBody(context),
      ),
    );
  }

  // 가입된 팀이 없을 때 빈 화면
  Widget _buildTeamEmptyBody(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            '아직 참여 중인 팀이 없습니다.',
            style: FontStyles.bold22.copyWith(color: colors.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x10),
          Text(
            '버튼을 눌러 팀을 생성하거나 참여해보세요.',
            style: FontStyles.med14.copyWith(color: context.grays.gray5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TeamActionBox(
                iconPath: 'assets/icons/cal/plus.svg',
                label: '팀 생성하기',
                isSelected: _selectedBox == 'create',
                onTap: () {
                  setState(() {
                    _selectedBox = 'create';
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TeamCreatePage(),
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.x10),
              _TeamActionBox(
                iconPath: 'assets/icons/team/plus_team.svg',
                label: '팀 참여하기',
                isSelected: _selectedBox == 'join',
                onTap: () {
                  setState(() {
                    _selectedBox = 'join';
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TeamJoinPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // 가입된 팀 목록 렌더링
  Widget _buildTeamExistBody(BuildContext context, List<MyTeamModel> teams) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.x12),
          Expanded(
            child: ListView.separated(
              itemCount: teams.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.x16),
              itemBuilder: (context, index) {
                return _buildTeamItemCard(context, teams[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 팀 카드 위젯 빌더
  Widget _buildTeamItemCard(BuildContext context, MyTeamModel team) {
    final rawDate = team.createdAt;
    final formattedDate = rawDate.length >= 10
        ? rawDate.substring(0, 10).replaceAll('-', '.')
        : rawDate;

    final String? imageUrl = team.teamImageUrl;
    final bool hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    // 이미지가 없을 때 기본 카드
    if (!hasImage) {
      return AppTeamCard(
        genre: team.teamType,
        teamName: team.teamName,
        date: formattedDate,
        height: 158,
        showArrow: true,
        titleStyle: FontStyles.bold28.copyWith(color: context.colors.onPrimary),
        onTap: () => _handleTeamCardTap(team),
      );
    }

    // 이미지가 있을 때 배경 이미지 렌더링
    return GestureDetector(
      onTap: () => _handleTeamCardTap(team),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 158,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: const Color(0xFF1C1C1E)),
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.45)),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.teamType,
                      style: FontStyles.med14.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      team.teamName,
                      style: FontStyles.bold28.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '$formattedDate 개설',
                      style: FontStyles.med14.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/auth/back.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamActionBox extends StatelessWidget {
  const _TeamActionBox({
    this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String? iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final boxBackgroundColor = isSelected
        ? context.grays.gray8
        : colors.surface;
    final circleBackgroundColor = isSelected
        ? colors.primary
        : context.grays.gray8;
    final iconColor = isSelected ? Colors.white : context.grays.gray5;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 134,
        height: 158,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.x20,
          horizontal: AppSpacing.x12,
        ),
        decoration: BoxDecoration(
          color: boxBackgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: context.grays.gray7, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleBackgroundColor,
              ),
              child: Center(
                child: iconPath != null
                    ? SvgPicture.asset(
                        iconPath!,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text(
              label,
              style: FontStyles.med16.copyWith(color: colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
