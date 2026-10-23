import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 앱 내부에서 사진/영상/파일 보관함 중 하나를 선택하는 공통 팝업입니다.
/// 선택 후 실제 보관함 화면은 image_picker / file_picker가 엽니다.
enum AppMediaSource { photoLibrary, videoLibrary, fileBrowser }

class AppMediaSourcePopup {
  const AppMediaSourcePopup._();

  static Future<AppMediaSource?> show(
    BuildContext context, {
    required List<AppMediaSource> sources,
  }) {
    assert(sources.isNotEmpty && sources.length <= 2);
    return showDialog<AppMediaSource>(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x16,
              AppSpacing.x40,
              AppSpacing.x16,
              AppSpacing.x30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '작업 선택',
                  style: FontStyles.bold22.copyWith(
                    color: dialogContext.grays.black,
                  ),
                ),
                const SizedBox(height: AppSpacing.x12),
                Text(
                  '보관함을 선택해주세요.',
                  style: FontStyles.semi16.copyWith(
                    color: dialogContext.grays.gray4,
                  ),
                ),
                const SizedBox(height: AppSpacing.x24),
                Row(
                  children: [
                    for (var index = 0; index < sources.length; index++) ...[
                      if (index > 0) const SizedBox(width: AppSpacing.x10),
                      Expanded(
                        child: _AppMediaSourceTile(
                          source: sources[index],
                          onTap: () =>
                              Navigator.of(dialogContext).pop(sources[index]),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppMediaSourceTile extends StatelessWidget {
  const _AppMediaSourceTile({required this.source, required this.onTap});

  final AppMediaSource source;
  final VoidCallback onTap;

  String get _label => switch (source) {
    AppMediaSource.photoLibrary => '사진 보관함',
    AppMediaSource.videoLibrary => '동영상 보관함',
    AppMediaSource.fileBrowser => '파일 탐색기',
  };

  String get _icon => switch (source) {
    AppMediaSource.photoLibrary => 'assets/icons/chat/picture_fill.svg',
    AppMediaSource.videoLibrary => 'assets/icons/chat/video_fill.svg',
    AppMediaSource.fileBrowser => 'assets/icons/chat/folder_fill.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: InkWell(
        onTap: onTap,
        splashColor: context.grays.gray7.withValues(alpha: 0.1),
        highlightColor: context.grays.gray7.withValues(alpha: 0.1),
        hoverColor: context.grays.gray7.withValues(alpha: 0.1),
        focusColor: context.grays.gray7.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: context.grays.gray7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 62,
                height: 62,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  _icon,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.grays.gray1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              Text(
                _label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontStyles.med16.copyWith(color: context.grays.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
