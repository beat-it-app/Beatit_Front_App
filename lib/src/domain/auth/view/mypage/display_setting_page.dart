import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

import '../../../../core/theme/theme_mode_provider.dart';

class DisplaySettingPage extends ConsumerWidget {
  const DisplaySettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x16),
              Text(
                '화면 설정',
                style: FontStyles.bold34.copyWith(
                  color: colors.onSurface,
                  letterSpacing: -0.68,
                ),
              ),
              const SizedBox(height: AppSpacing.x24),

              // 1. 라이트 모드 카드
              _DisplayModeCard(
                title: '라이트 모드',
                description: '시스템 화면 설정과 상관없이\n항상 화면이 라이트 모드로\n설정됩니다.',
                svgIconPath: 'assets/icons/auth/sun.svg',
                imagePath: 'assets/images/auth/lightmode.png',
                isSelected: currentThemeMode == ThemeMode.light,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                },
              ),
              const SizedBox(height: AppSpacing.x16),

              // 2. 다크 모드 카드
              _DisplayModeCard(
                title: '다크 모드',
                description: '시스템 화면 설정과 상관없이\n항상 화면이 다크 모드로\n설정됩니다.',
                svgIconPath: 'assets/icons/auth/night.svg',
                imagePath: 'assets/images/auth/darkmode.png',
                isSelected: currentThemeMode == ThemeMode.dark,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                },
              ),
              const SizedBox(height: AppSpacing.x16),

              // 3. 시스템 화면 모드 카드
              _DisplayModeCard(
                title: '시스템 화면 모드',
                description: '시스템 화면 설정에 따라\n화면 모드가 설정됩니다.',
                svgIconPath: 'assets/icons/auth/system.svg',
                imagePath: 'assets/images/auth/systemmode.png',
                isSelected: currentThemeMode == ThemeMode.system,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                },
              ),
              const SizedBox(height: AppSpacing.x30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisplayModeCard extends StatelessWidget {
  final String title;
  final String description;
  final String svgIconPath;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _DisplayModeCard({
    required this.title,
    required this.description,
    required this.svgIconPath,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final borderColor = isSelected
        ? context.colors.primary
        : context.grays.gray7;
    final headerBgColor = isSelected
        ? context.colors.primary.withOpacity(0.08)
        : context.grays.gray8;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 카드 상단 헤더 (SVG 아이콘 + 타이틀 + 토글 스위치) ──
              Container(
                color: headerBgColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      svgIconPath,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        colors.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: FontStyles.bold20.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const Spacer(),

                    // 토글 스위치 형태
                    _CustomSwitch(value: isSelected, onChanged: (_) => onTap()),
                  ],
                ),
              ),

              // ── 카드 하단 내용 (에셋 이미지 프리뷰 + 설명 문구) ──
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 좌측 UI 이미지 프리뷰
                    SizedBox(
                      width: 110,
                      height: 130,
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),

                    const SizedBox(width: AppSpacing.x20),

                    // 우측 설명 텍스트
                    Expanded(
                      child: Text(
                        description,
                        style: FontStyles.med14.copyWith(
                          color: context.grays.gray4,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 주황색 체크 스위치 버튼
class _CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? context.colors.primary : context.grays.gray6,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: value
                ? Icon(Icons.check, size: 14, color: context.colors.primary)
                : null,
          ),
        ),
      ),
    );
  }
}
