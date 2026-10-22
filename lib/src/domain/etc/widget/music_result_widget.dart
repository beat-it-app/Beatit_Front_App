import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusicResultWidget extends StatefulWidget {
  const MusicResultWidget({
    super.key,
    required this.musicTitle,
    required this.artist,
    required this.imageUrl,
    this.isSelected = false,
    this.isPlaying = false,
    this.onTap,
    this.onAddPressed,
  });

  final String musicTitle;
  final String artist;
  final String imageUrl;
  final bool isSelected;
  final bool isPlaying;

  /// 행/썸네일 클릭: 30초 음악 미리듣기. 선택과 분리합니다.
  final VoidCallback? onTap;

  /// 왼쪽 추가 버튼: 기존 음악 선택 및 이전 화면으로 반환.
  final VoidCallback? onAddPressed;

  @override
  State<MusicResultWidget> createState() => _MusicResultWidgetState();
}

class _MusicResultWidgetState extends State<MusicResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isPlaying || widget.isSelected
          ? context.grays.gray8
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.x8,
          horizontal: AppSpacing.x16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: widget.onTap,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            widget.imageUrl.trim().isEmpty
                                ? const _MusicImageFallback()
                                : Image.network(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const _MusicImageFallback(),
                                  ),
                            ColoredBox(color: AppColor.black.withOpacity(0.4)),
                            Center(
                              child: widget.isPlaying
                                  ? SvgPicture.asset(
                                      'assets/icons/etc/pause.svg',
                                      width: 24,
                                      height: 24,
                                      colorFilter: ColorFilter.mode(
                                        context.grays.white,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: SvgPicture.asset(
                                        'assets/icons/core/play.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          context.grays.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.musicTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FontStyles.med20.copyWith(
                              color: context.grays.black,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            widget.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FontStyles.med16.copyWith(
                              color: context.grays.gray5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x16),
            Semantics(
              button: true,
              label: '${widget.musicTitle} 추가',
              child: InkWell(
                onTap: widget.onAddPressed,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(
                  width: 36,
                  height: 60,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/etc/add_block.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        context.colors.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicImageFallback extends StatelessWidget {
  const _MusicImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.grays.gray7,
      alignment: Alignment.center,
      child: Icon(Icons.music_note, color: context.grays.gray5),
    );
  }
}
