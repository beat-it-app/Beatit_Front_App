import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_selection_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudFolderWidget extends StatelessWidget {
  const CloudFolderWidget({
    super.key,
    required this.folderName,
    required this.fileCount,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
  });

  final String folderName;
  final int fileCount;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;

  static const double _itemHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = Color.alphaBlend(
      colorScheme.onSurface.withAlpha(18),
      colorScheme.surface,
    );
    final pressedColor = Color.alphaBlend(
      colorScheme.onSurface.withAlpha(28),
      colorScheme.surface,
    );

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$folderName, 파일 $fileCount개',
      child: Material(
        color: isSelected ? selectedColor : colorScheme.surface,
        animationDuration: const Duration(milliseconds: 160),
        child: InkWell(
          onTap: onTap,
          highlightColor: pressedColor,
          splashColor: pressedColor,
          child: SizedBox(
            height: _itemHeight,
            child: Padding(
              padding: EdgeInsets.only(
                left: isSelectionMode ? AppSpacing.x16 : AppSpacing.x30,
                right: AppSpacing.x20,
              ),
              child: Row(
                children: [
                  if (isSelectionMode) ...[
                    const SizedBox(width: AppSpacing.x4),
                    CloudSelectionCheckbox(isSelected: isSelected),
                    const SizedBox(width: AppSpacing.x20),
                  ],
                  SvgPicture.asset(
                    'assets/icons/cloud/folder.svg',
                    width: 20.0,
                    height: 20.0,
                  ),
                  const SizedBox(width: AppSpacing.x16),
                  Expanded(
                    child: Text(
                      folderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med16.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x16),
                  Text(
                    '$fileCount',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  if (!isSelectionMode) ...[
                    SvgPicture.asset(
                      'assets/icons/cloud/back.svg',
                      width: 20.0,
                      height: 20.0,
                      colorFilter: ColorFilter.mode(
                        context.grays.gray6,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                  const SizedBox(width: AppSpacing.x4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
