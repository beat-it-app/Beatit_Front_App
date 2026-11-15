import 'dart:ui';

import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_xfile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 시안의 상단 배너 구간. 배경 어둡게·흰 글씨는 라이트/다크 공통 고정 색상이다.
class PerformanceHero extends StatelessWidget {
  const PerformanceHero({
    super.key,
    required this.performance,
    this.isMine = false,
  });

  final PerformanceDetailData performance;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final until = performance.bookingClosesAt ?? performance.startsAt;
    final remaining = DateUtils.dateOnly(
      until,
    ).difference(DateUtils.dateOnly(DateTime.now())).inDays;
    final dayLabel = remaining == 0
        ? 'D-Day'
        : remaining > 0
        ? 'D-$remaining'
        : 'D+${-remaining}';

    final bool hasPoster =
        (performance.posterUrl?.isNotEmpty ?? false) ||
        performance.posterFile != null;

    return SizedBox(
      // 💡 하단 여백 48px 확보를 위해 전체 배너 높이 확장 (600 -> 624)
      height: 624,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 배경 블러 처리
          if (hasPoster)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: _poster(fit: BoxFit.cover),
            )
          else
            const ColoredBox(color: AppColor.gray1),
          ColoredBox(color: AppColor.black.withOpacity(0.8)),

          // 2. 전면 콘텐츠 영역
          SafeArea(
            bottom: false,
            child: Padding(
              // 💡 D-Day 배지 ~ 배너 하단 끝 높이를 48px로 설정
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x20,
                58,
                AppSpacing.x20,
                48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 포스터 카드 (사진이 없을 시 performance.svg 표시)
                  SizedBox(
                    width: 242,
                    child: AspectRatio(
                      aspectRatio: 242 / 307,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: hasPoster
                            ? _poster(fit: BoxFit.cover)
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x24),
                  Text(
                    '${performance.startsAt.year}. ${performance.startsAt.month}. ${performance.startsAt.day}.',
                    style: FontStyles.med15.copyWith(
                      color: AppColor.beatOrange2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x10),
                  Text(
                    performance.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.bold26.copyWith(color: AppColor.white),
                  ),
                  // mine일 때는 중앙 D-day 뱃지 숨김
                  if (!isMine) ...[
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.beatOrange2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        child: Text(
                          dayLabel,
                          style: FontStyles.reg14.copyWith(
                            color: AppColor.beatOrange2,
                          ),
                        ),
                      ),
                    ),
                  ],
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
      performance.posterUrl!,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  /// 사진이 없을 때 표시되는 원래 performance.svg 플레이스홀더
  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/performance/performance.svg',
          width: 60,
          height: 60,
        ),
      ),
    );
  }
}
