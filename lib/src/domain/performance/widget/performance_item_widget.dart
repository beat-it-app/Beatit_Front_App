import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_xfile_image.dart';

/// 그리드 너비를 채우고 포스터는 165:210 비율을 유지한다.
class PerformanceItem extends StatelessWidget {
  const PerformanceItem({
    super.key,
    required this.name,
    required this.imageUrl,
    this.imageFile,
    required this.date,
    this.onTap,
    this.showPastLabel = false,
  });

  final String name;
  final String? imageUrl;
  final XFile? imageFile;
  final DateTime? date;
  final VoidCallback? onTap;
  final bool showPastLabel;

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;
    final bool hasFileImage = imageFile != null;
    final bool hasValidImage = hasNetworkImage || hasFileImage;

    final String dateStr = date != null
        ? '${date!.year}. ${date!.month}. ${date!.day}.'
        : '-';

    return Material(
      color: context.grays.white,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 165 / 210,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: showPastLabel ? 0.5 : 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.grays.gray8,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      // 💡 이미지 위에 테두리를 전경(foregroundDecoration)으로 그려 모서리 끊김 방지
                      foregroundDecoration: BoxDecoration(
                        border: Border.all(
                          color: context.grays.gray6,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: hasValidImage
                            ? (hasFileImage
                                  ? PerformanceXFileImage(
                                      file: imageFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildPlaceholder(),
                                    ))
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                  if (showPastLabel)
                    Positioned(
                      bottom: AppSpacing.x8,
                      right: AppSpacing.x8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x8,
                          vertical: AppSpacing.x4,
                        ),
                        color: context.grays.white,
                        child: Text(
                          '지난 공연',
                          style: FontStyles.med11.copyWith(
                            color: context.grays.gray2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Text(
              dateStr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.reg15.copyWith(
                color: context.grays.gray4,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Expanded(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FontStyles.semi18.copyWith(
                  color: context.grays.black,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 사진이 없거나 로드 실패 시 중앙에 표시되는 플레이스홀더 아이콘
  Widget _buildPlaceholder() {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/performance/performance.svg',
        width: 48,
        height: 48,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// 공연 메인과 나의 공연에서 동일한 2열 그리드 규칙을 공유한다.
class PerformanceGrid extends StatelessWidget {
  const PerformanceGrid({
    super.key,
    required this.performances,
    required this.onTap,
    this.showPastLabel = false,
  });

  final List<PerformanceModel> performances;
  final ValueChanged<PerformanceModel> onTap;
  final bool showPastLabel;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = (constraints.maxWidth - AppSpacing.x20 * 3) / 2;

      final direction = Directionality.of(context);
      final scaler = MediaQuery.textScalerOf(context);
      final titleStyle = FontStyles.semi18.copyWith(height: 1.25);
      final dateStyle = FontStyles.reg15.copyWith(height: 1.2);

      final titleMeasure = TextPainter(
        text: TextSpan(text: '공연 이름\n공연 이름', style: titleStyle),
        textDirection: direction,
        textScaler: scaler,
        maxLines: 2,
      )..layout(maxWidth: width);
      final dateMeasure = TextPainter(
        text: TextSpan(text: '2026. 11. 10.', style: dateStyle),
        textDirection: direction,
        textScaler: scaler,
        maxLines: 1,
      )..layout(maxWidth: width);

      final detailsHeight =
          AppSpacing.x8 +
          dateMeasure.height +
          AppSpacing.x4 +
          titleMeasure.height +
          AppSpacing.x12;
      titleMeasure.dispose();
      dateMeasure.dispose();

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x20,
          0,
          AppSpacing.x20,
          90,
        ),
        itemCount: performances.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.x20,
          mainAxisSpacing: AppSpacing.x20,
          mainAxisExtent: width * (210 / 165) + detailsHeight,
        ),
        itemBuilder: (context, index) {
          final item = performances[index];
          final isPast =
              item.performanceDateTime != null &&
              item.performanceDateTime!.isBefore(DateTime.now());

          return PerformanceItem(
            name: item.title,
            date: item.performanceDateTime,
            imageUrl: item.posterImageUrl,
            imageFile: null,
            showPastLabel: showPastLabel && isPast,
            onTap: () => onTap(item),
          );
        },
      );
    },
  );
}
