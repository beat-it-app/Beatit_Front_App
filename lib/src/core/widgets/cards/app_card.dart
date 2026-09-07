import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';

class AppTeamCard extends StatelessWidget {
  const AppTeamCard({
    super.key,
    required this.genre,
    required this.teamName,
    required this.date,
    this.onTap,
    this.height = 280,
    this.titleStyle,
    this.showArrow = false,
  });

  final String genre;
  final String teamName;
  final String date;
  final VoidCallback? onTap;
  final double height;
  final TextStyle? titleStyle;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: const Color(0xFF1C1C1E),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      genre,
                      style: FontStyles.med14.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      teamName,
                      style:
                          titleStyle ??
                          FontStyles.bold34.copyWith(
                            color: context.colors.onPrimary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '$date 개설',
                      style: FontStyles.med14.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/auth/back.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
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
