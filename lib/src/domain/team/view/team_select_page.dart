import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/cards/app_card.dart';
import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/team/view/team_create_start_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_join_page.dart';

class TeamSelectPage extends StatefulWidget {
  const TeamSelectPage({super.key});

  @override
  State<TeamSelectPage> createState() => _TeamSelectPageState();
}

class _TeamSelectPageState extends State<TeamSelectPage> {
  bool _hasTeam = false;

  String? _selectedBox;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: _hasTeam
          ? AppTwoAppBar.add(
              title: '',
              onAddPressed: () {
                print('+ 버튼 클릭됨');
              },
            )
          : null,
      body: SafeArea(
        child: _hasTeam
            ? _buildTeamExistBody(context)
            : _buildTeamEmptyBody(context),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          print('네비게이션 탭 이동: $index');
          //TODO: 각 탭별 페이지 이동 로직
        },
      ),
    );
  }

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
                isSvg: true,
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
                isSvg: true,
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

  Widget _buildTeamExistBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.x12),
          Expanded(
            child: ListView(
              children: [
                AppTeamCard(
                  genre: 'Band',
                  teamName: '잘 나가는 밴드',
                  date: '2026.04.26',
                  height: 158,
                  showArrow: true,
                  titleStyle: FontStyles.bold28.copyWith(
                    color: context.colors.onPrimary,
                  ),
                  onTap: () {
                    print('잘 나가는 밴드 선택!');
                  },
                ),
                const SizedBox(height: AppSpacing.x16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamActionBox extends StatelessWidget {
  const _TeamActionBox({
    required this.isSvg,
    this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSvg;
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
                child: SvgPicture.asset(
                  iconPath!,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
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
