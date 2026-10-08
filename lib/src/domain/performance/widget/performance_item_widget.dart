import 'package:beatit_front_app/src/domain/performance/widget/performance_xfile_image.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';

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
  final DateTime date;
  final VoidCallback? onTap;
  final bool showPastLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.grays.white,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {}, // 상세 페이지 연결 전에도 탭 피드백을 준다.
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
                        border: Border.all(color: context.grays.gray7),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: imageFile != null
                          ? PerformanceXFileImage(file: imageFile!, fit: BoxFit.cover)
                          : imageUrl == null || imageUrl!.trim().isEmpty
                          ? const SizedBox.expand()
                          : Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.expand(),
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
                        child: Text('지난 공연',
                          style: FontStyles.med11.copyWith(
                            color: context.grays.gray2,
                          )),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Text(
              '${date.year}. ${date.month}. ${date.day}.',
              style: FontStyles.reg15.copyWith(color: context.grays.gray4),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.semi18.copyWith(color: context.grays.black),
            ),
          ],
        ),
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

  final List<PerformanceSummary> performances;
  final ValueChanged<PerformanceSummary> onTap;
  final bool showPastLabel;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = (constraints.maxWidth - AppSpacing.x20 * 3) / 2;
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x20, 0, AppSpacing.x20, 90,
        ),
        itemCount: performances.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.x20,
          mainAxisSpacing: AppSpacing.x20,
          mainAxisExtent: width * (210 / 165) + 78,
        ),
        itemBuilder: (context, index) {
          final item = performances[index];
          return PerformanceItem(
            name: item.title,
            date: item.startsAt,
            imageUrl: item.imageUrl ?? item.detail?.posterUrl,
            imageFile: item.detail?.posterFile,
            showPastLabel: showPastLabel && item.startsAt.isBefore(DateTime.now()),
            onTap: () => onTap(item),
          );
        },
      );
    },
  );
}
