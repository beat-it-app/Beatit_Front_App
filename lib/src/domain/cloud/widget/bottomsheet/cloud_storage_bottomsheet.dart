import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';
import 'package:beatit_front_app/src/domain/cloud/provider/cloud_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showCloudStorageBottomSheet({required BuildContext context}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    barrierColor: context.grays.black.withValues(alpha: 0.55),
    builder: (_) => const CloudStorageBottomSheet(),
  );
}

class CloudStorageBottomSheet extends ConsumerWidget {
  const CloudStorageBottomSheet({super.key});

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
          error: (error, _) => SizedBox(
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
          data: (data) => _CloudStorageContent(data: data),
        ),
      ),
    );
  }
}

class _CloudStorageContent extends StatelessWidget {
  const _CloudStorageContent({required this.data});

  final CloudStorageData data;

  List<_StorageSegment> _segments(BuildContext context) {
    var documentBytes = 0;
    var videoBytes = 0;
    var audioBytes = 0;
    var imageBytes = 0;
    var otherBytes = 0;

    for (final category in data.categories) {
      final label = category.category.trim().toLowerCase();
      if (label == 'pdf' || label == 'document' || label == '문서') {
        documentBytes += category.bytes;
      } else if (label == '영상' || label == 'video') {
        videoBytes += category.bytes;
      } else if (label == 'mp3' || label == 'audio' || label == '음원') {
        audioBytes += category.bytes;
      } else if (label == '이미지' || label == 'image' || label == '사진') {
        imageBytes += category.bytes;
      } else {
        otherBytes += category.bytes;
      }
    }

    return [
      _StorageSegment('문서', documentBytes, context.brands.beatOrange1),
      _StorageSegment('영상', videoBytes, context.brands.beatOrange2),
      _StorageSegment('음원', audioBytes, context.brands.beatOrange3),
      _StorageSegment('사진', imageBytes, context.brands.beatOrange4),
      _StorageSegment('기타', otherBytes, context.grays.gray5),
    ];
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const kb = 1024;
    const mb = 1024 * 1024;
    const gb = 1024 * 1024 * 1024;
    if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(2)} GB';
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(2)} MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(2)} KB';
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    final segments = _segments(context);

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
        _StorageProgressBar(
          segments: segments,
          totalBytes: data.totalStorageBytes,
        ),
        const SizedBox(height: AppSpacing.x20),
        ...segments.map(
          (segment) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x10),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: segment.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                Expanded(
                  child: Text(
                    segment.label,
                    style: FontStyles.reg18.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                ),
                Text(
                  _formatBytes(segment.bytes),
                  style: FontStyles.reg18.copyWith(color: context.grays.black),
                ),
              ],
            ),
          ),
        ),
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

class _StorageProgressBar extends StatelessWidget {
  const _StorageProgressBar({required this.segments, required this.totalBytes});

  final List<_StorageSegment> segments;
  final int totalBytes;

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

            for (final segment in segments) {
              if (segment.bytes <= 0 || usedWidth >= constraints.maxWidth) {
                continue;
              }

              final rawWidth =
                  constraints.maxWidth * (segment.bytes / safeTotal);
              final availableWidth = constraints.maxWidth - usedWidth;
              final width = rawWidth.clamp(0.0, availableWidth).toDouble();
              if (width <= 0) continue;

              usedWidth += width;
              children.add(
                SizedBox(
                  width: width,
                  child: ColoredBox(color: segment.color),
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

class _StorageSegment {
  const _StorageSegment(this.label, this.bytes, this.color);

  final String label;
  final int bytes;
  final Color color;
}
