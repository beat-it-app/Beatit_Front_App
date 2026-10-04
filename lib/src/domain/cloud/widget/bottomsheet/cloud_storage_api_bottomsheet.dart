import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 백엔드 `/teams/clouds/storage` 응답을 별도 가공 없이 표시한다.
///
/// 기존 `cloud_storage_bottomsheet.dart`의
/// `문서 / 영상 / 음원 / 사진 / 기타` UI는 추후 확장용으로 그대로 보존한다.
Future<void> showCloudStorageApiBottomSheet({required BuildContext context}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    barrierColor: context.grays.black.withValues(alpha: 0.55),
    builder: (_) => const CloudStorageApiBottomSheet(),
  );
}

class CloudStorageApiBottomSheet extends ConsumerWidget {
  const CloudStorageApiBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(cloudStorageProvider);

    return Material(
      color: context.grays.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x20,
          AppSpacing.x30,
          AppSpacing.x20,
          AppSpacing.x30,
        ),
        child: storage.when(
          loading: () => const SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => SizedBox(
            height: 260,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '저장 용량을 불러오지 못했습니다.',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x8),
                  TextButton(
                    onPressed: () => ref.invalidate(cloudStorageProvider),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
          data: (data) => _CloudStorageApiContent(data: data),
        ),
      ),
    );
  }
}

class _CloudStorageApiContent extends StatelessWidget {
  const _CloudStorageApiContent({required this.data});

  final CloudStorageData data;

  Color _categoryColor(BuildContext context, String category, int index) {
    return switch (category) {
      'PDF' => context.brands.beatOrange1,
      '영상' => context.brands.beatOrange2,
      'MP3' => context.brands.beatOrange3,
      '이미지' => context.brands.beatOrange4,
      _ => switch (index % 5) {
        0 => context.brands.beatOrange1,
        1 => context.brands.beatOrange2,
        2 => context.brands.beatOrange3,
        3 => context.brands.beatOrange4,
        _ => context.grays.gray5,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final categories = data.categories;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '저장 용량',
          textAlign: TextAlign.center,
          style: FontStyles.bold26.copyWith(color: context.grays.black),
        ),
        const SizedBox(height: AppSpacing.x24),
        Text(
          '${data.teamName} 팀 클라우드',
          style: FontStyles.med20.copyWith(color: context.grays.black),
        ),
        const SizedBox(height: AppSpacing.x4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${data.usagePercentage.clamp(0, 100)}%',
              style: FontStyles.med20.copyWith(
                color: context.grays.black,
                fontSize: 50.0,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${data.totalStorageDisplay} 중 ${data.usedStorageDisplay} 사용됨',
                style: FontStyles.med20.copyWith(color: context.grays.gray4),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x8),
        _ApiStorageProgressBar(
          categories: categories,
          totalBytes: data.totalStorageBytes,
          colorFor: (category, index) =>
              _categoryColor(context, category, index),
        ),
        const SizedBox(height: AppSpacing.x20),
        ...List.generate(categories.length, (index) {
          final category = categories[index];
          final color = _categoryColor(context, category.category, index);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x10),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                Expanded(
                  child: Text(
                    category.category,
                    style: FontStyles.reg18.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                ),
                Text(
                  category.displaySize,
                  style: FontStyles.reg18.copyWith(
                    color: context.grays.black,
                  ),
                ),
              ],
            ),
          );
        }),
        const Divider(height: AppSpacing.x20),
        const SizedBox(height: AppSpacing.x10),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: context.grays.gray7,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              child: Text(
                '빈 클라우드 공간',
                style: FontStyles.reg18.copyWith(color: context.grays.gray4),
              ),
            ),
            Text(
              data.remainingStorageDisplay,
              style: FontStyles.reg18.copyWith(color: context.grays.gray4),
            ),
          ],
        ),
      ],
    );
  }
}

class _ApiStorageProgressBar extends StatelessWidget {
  const _ApiStorageProgressBar({
    required this.categories,
    required this.totalBytes,
    required this.colorFor,
  });

  final List<CloudStorageCategoryUsage> categories;
  final int totalBytes;
  final Color Function(String category, int index) colorFor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        height: 38,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final safeTotal = totalBytes <= 0 ? 1 : totalBytes;
            var usedWidth = 0.0;
            final children = <Widget>[];

            for (var index = 0; index < categories.length; index += 1) {
              final category = categories[index];
              if (category.bytes <= 0 || usedWidth >= constraints.maxWidth) {
                continue;
              }

              final rawWidth =
                  constraints.maxWidth * (category.bytes / safeTotal);
              final availableWidth = constraints.maxWidth - usedWidth;
              final width = rawWidth.clamp(0.0, availableWidth).toDouble();
              if (width <= 0) continue;

              usedWidth += width;
              children.add(
                SizedBox(
                  width: width,
                  child: ColoredBox(
                    color: colorFor(category.category, index),
                  ),
                ),
              );
            }

            final remainingWidth = (constraints.maxWidth - usedWidth)
                .clamp(0.0, constraints.maxWidth)
                .toDouble();

            if (remainingWidth > 0) {
              children.add(
                SizedBox(
                  width: remainingWidth,
                  child: ColoredBox(color: context.grays.gray7),
                ),
              );
            }

            return Row(children: children);
          },
        ),
      ),
    );
  }
}
