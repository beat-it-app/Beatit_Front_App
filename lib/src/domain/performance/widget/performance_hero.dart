import 'dart:ui';

import 'package:beatit_front_app/src/domain/performance/widget/performance_xfile_image.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:flutter/material.dart';

/// 시안의 상단 600px 구간. 배경 어둡게·흰 글씨는 라이트/다크 공통 고정 색상이다.
class PerformanceHero extends StatelessWidget {
  const PerformanceHero({super.key, required this.performance});

  final PerformanceDetailData performance;

  @override
  Widget build(BuildContext context) {
    final until = performance.bookingClosesAt ?? performance.startsAt;
    final remaining = DateUtils.dateOnly(until)
        .difference(DateUtils.dateOnly(DateTime.now())).inDays;
    final dayLabel = remaining == 0 ? 'D-Day'
        : remaining > 0 ? 'D-$remaining' : 'D+${-remaining}';

    return SizedBox(
      height: 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (performance.posterFile != null ||
              (performance.posterUrl?.isNotEmpty ?? false))
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: _poster(fit: BoxFit.cover),
            )
          else
            const ColoredBox(color: AppColor.gray1),
          ColoredBox(color: AppColor.black.withOpacity(0.8)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x20, 68, AppSpacing.x20, AppSpacing.x30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 208,
                    child: AspectRatio(
                      aspectRatio: 165 / 210,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: (performance.posterUrl?.isNotEmpty ?? false) ||
                              performance.posterFile != null
                            ? _poster(fit: BoxFit.cover)
                            : const ColoredBox(color: AppColor.gray8),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x24),
                  Text(
                    '${performance.startsAt.year}. ${performance.startsAt.month}. ${performance.startsAt.day}.',
                    style: FontStyles.med14.copyWith(color: AppColor.beatOrange2),
                  ),
                  const SizedBox(height: AppSpacing.x8),
                  Text(
                    performance.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.bold22.copyWith(color: AppColor.white),
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.beatOrange2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(dayLabel,
                        style: FontStyles.med12.copyWith(color: AppColor.beatOrange2)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _poster({required BoxFit fit}) {
    if (performance.posterFile != null) {
      return PerformanceXFileImage(file: performance.posterFile!, fit: fit);
    }
    return Image.network(
      performance.posterUrl!, fit: fit,
      errorBuilder: (_, __, ___) => const ColoredBox(color: AppColor.gray8),
    );
  }
}
