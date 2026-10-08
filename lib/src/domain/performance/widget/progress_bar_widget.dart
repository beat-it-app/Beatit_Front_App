import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PerformanceProgressBar extends StatelessWidget {
  const PerformanceProgressBar({
    super.key,
    required this.step,
    this.totalSteps = 2,
  }) : assert(totalSteps > 0),
       assert(step > 0 && step <= totalSteps);

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: 22,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    color: context.grays.gray7,
                  ),
                ),
                Container(
                  height: 6,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    color: context.brands.beatOrange2,
                  ),
                ),
                Positioned(
                  left: (constraints.maxWidth * progress - 9)
                      .clamp(0.0, constraints.maxWidth - 22)
                      .toDouble(),
                  child: Container(
                    width: 22,
                    height: 22,
                    padding: EdgeInsets.only(left: 2.0),
                    decoration: BoxDecoration(
                      color: context.brands.beatOrange1,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/performance/play.svg',
                        width: 9.0,
                        height: 9.0,
                        colorFilter: ColorFilter.mode(
                          context.grays.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: step == 1 ? '공연 정보를 입력해주세요.' : '공연 상세 정보를 입력해주세요.',
              ),
              TextSpan(
                text: ' *',
                style: FontStyles.bold22.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          style: FontStyles.bold22.copyWith(color: context.colors.onSurface),
        ),
      ],
    );
  }
}
