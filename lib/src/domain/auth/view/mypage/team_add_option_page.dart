import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/domain/team/view/team_create_start_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_join_page.dart';

class TeamAddOptionPage extends StatefulWidget {
  const TeamAddOptionPage({super.key});

  @override
  State<TeamAddOptionPage> createState() => _TeamAddOptionPageState();
}

class _TeamAddOptionPageState extends State<TeamAddOptionPage> {
  String? _selectedBox;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colors.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Text(
                '팀을 추가하시겠습니까?',
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
              const Spacer(flex: 3),
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
