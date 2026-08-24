import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';

class TeamSelectEmptyPage extends StatefulWidget {
  const TeamSelectEmptyPage({super.key});

  @override
  State<TeamSelectEmptyPage> createState() => _TeamSelectEmptyPageState();
}

class _TeamSelectEmptyPageState extends State<TeamSelectEmptyPage> {
  String? _selectedBox;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
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
                style: FontStyles.med16.copyWith(color: context.grays.gray5),
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
                      // TODO: 팀 생성 페이지로 이동하는 로직 추가
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
                      // TODO: 팀 참여 페이지로 이동하는 로직 추가
                    },
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamActionBox extends StatelessWidget {
  const _TeamActionBox({
    required this.isSvg,
    this.iconPath,
    this.iconData,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSvg;
  final String? iconPath;
  final IconData? iconData;
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
      child: Center(
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
                  child: isSvg
                      ? SvgPicture.asset(
                          iconPath!,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        )
                      : Icon(iconData, size: 24, color: iconColor),
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
      ),
    );
  }
}
