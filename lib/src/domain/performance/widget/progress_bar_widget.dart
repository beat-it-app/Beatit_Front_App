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
    this.totalSteps = 3,
  }) : assert(totalSteps > 0),
       assert(step > 0 && step <= totalSteps);

  final int step;
  final int totalSteps;

  String get _titleText {
    switch (step) {
      case 1:
        return '공연 정보를 입력해주세요.';
      case 2:
        return '공연 상세 정보를 입력해주세요.';
      case 3:
      default:
        return '모바일 초대장';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 💡 ExcludeSemantics로 감싸 LayoutBuilder/Stack의 접근성 트리 충돌을 완전히 방지
        ExcludeSemantics(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double barWidth = constraints.maxWidth;
              final double knobLeft = (barWidth * progress - 11)
                  .clamp(0.0, barWidth - 22)
                  .toDouble();

              return SizedBox(
                height: 22,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // 배경 바
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        color: context.grays.gray7,
                      ),
                    ),
                    // 주황색 진행 바
                    Container(
                      height: 6,
                      width: barWidth * progress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        color: context.brands.beatOrange2,
                      ),
                    ),
                    // 주황색 재생 아이콘 손잡이
                    Positioned(
                      left: knobLeft,
                      child: Container(
                        width: 22,
                        height: 22,
                        padding: const EdgeInsets.only(left: 2.0),
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
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.x12),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: _titleText),
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
