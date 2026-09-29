import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

typedef CloudPreviewFileItemBuilder =
    Widget Function(BuildContext context, int index);

Future<int?> showCloudPreviewFileListBottomSheet({
  required BuildContext context,
  required String folderName,
  required int itemCount,
  required CloudPreviewFileItemBuilder itemBuilder,
}) {
  return showModalBottomSheet<int>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    barrierColor: context.grays.black.withValues(alpha: 0.6),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: CloudPreviewFileListBottomSheet(
          folderName: folderName,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
      );
    },
  );
}

class CloudPreviewFileListBottomSheet extends StatelessWidget {
  const CloudPreviewFileListBottomSheet({
    super.key,
    required this.folderName,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String folderName;
  final int itemCount;
  final CloudPreviewFileItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: context.grays.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 100.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  child: Text(
                    folderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: FontStyles.bold26.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                ),
                Positioned(
                  right: AppSpacing.x16,
                  child: Semantics(
                    button: true,
                    label: '파일 목록 닫기',
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: 28.0,
                        color: context.grays.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1.0,
                  thickness: 1.0,
                  indent: AppSpacing.x30,
                  endIndent: AppSpacing.x16,
                  color: Color.alphaBlend(
                    colorScheme.onSurface.withAlpha(18),
                    colorScheme.surface,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
