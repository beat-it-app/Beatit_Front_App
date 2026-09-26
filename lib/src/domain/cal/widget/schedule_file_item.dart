import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScheduleFileItem extends StatelessWidget {
  const ScheduleFileItem({
    super.key,
    required this.fileName,
    required this.onTap,
    this.fileSize,
    this.onRemove,
  });

  final String fileName;
  final String? fileSize;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x16),
            child: Row(
              children: [
                SvgPicture.asset(
                  _iconPath(fileName),
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    context.colors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyles.med16.copyWith(
                            color: context.colors.onSurface,
                          ),
                        ),
                      ),
                      if (fileSize != null && fileSize!.trim().isNotEmpty) ...[
                        const SizedBox(width: AppSpacing.x4),
                        Text(
                          '(${fileSize!})',
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onRemove != null) ...[
                  const SizedBox(width: AppSpacing.x8),
                  Semantics(
                    button: true,
                    label: '$fileName 삭제',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onRemove,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.x4),
                        child: SvgPicture.asset(
                          'assets/icons/cal/delete.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _iconPath(String name) {
    final extension = _extension(name);

    if (_audioExtensions.contains(extension)) {
      return 'assets/icons/cloud/music_simbol.svg';
    }
    if (extension == 'mp4') {
      return 'assets/icons/cloud/video.svg';
    }
    if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
      return 'assets/icons/cloud/image.svg';
    }

    return 'assets/icons/cloud/file.svg';
  }

  String _extension(String name) {
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) {
      return '';
    }
    return name.substring(index + 1).toLowerCase();
  }

  static const Set<String> _audioExtensions = {
    'mp3',
    'wav',
    'm4a',
    'aac',
    'ogg',
    'flac',
  };
}
