import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// 그리드 너비를 채우고 포스터는 165:210 비율을 유지한다.
class PerformanceItem extends StatelessWidget {
  const PerformanceItem({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.date,
    this.onTap,
  });

  final String name;
  final String? imageUrl;
  final DateTime date;
  final VoidCallback? onTap;

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
              child: Container(
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  border: Border.all(color: context.grays.gray7),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl == null || imageUrl!.trim().isEmpty
                    ? const SizedBox.expand()
                    : Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.expand(),
                      ),
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
