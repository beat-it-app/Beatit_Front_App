import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusicListItem extends StatefulWidget {
  const MusicListItem({
    super.key,
    required this.trackText,
    required this.artistText,
    required this.onTap,
    required this.onSeek,
    this.isExpanded = false,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  final String trackText;
  final String artistText;
  final VoidCallback onTap;
  final ValueChanged<Duration> onSeek;
  final bool isExpanded;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final String? errorMessage;

  @override
  State<MusicListItem> createState() => _MusicListItemState();
}

class _MusicListItemState extends State<MusicListItem> {
  static const Duration _expandDuration = Duration(milliseconds: 240);

  double? _dragValueMilliseconds;

  @override
  void didUpdateWidget(covariant MusicListItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isExpanded || widget.duration != oldWidget.duration) {
      _dragValueMilliseconds = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x16,
                vertical: AppSpacing.x12,
              ),
              child: Row(
                children: [
                  _PlaybackStatusIcon(
                    isExpanded: widget.isExpanded,
                    isPlaying: widget.isPlaying,
                  ),
                  const SizedBox(width: AppSpacing.x16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trackText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyles.med16.copyWith(
                            color: context.colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Text(
                          widget.artistText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyles.med12.copyWith(
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
          ClipRect(
            child: AnimatedSize(
              duration: _expandDuration,
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: widget.isExpanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.x16,
                        0,
                        AppSpacing.x16,
                        AppSpacing.x14,
                      ),
                      child: _buildPlaybackBar(context),
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackBar(BuildContext context) {
    final errorMessage = widget.errorMessage;
    if (errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x10,
        ),
        decoration: BoxDecoration(
          color: context.colors.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Text(
          errorMessage,
          style: FontStyles.med12.copyWith(
            color: context.colors.onErrorContainer,
          ),
        ),
      );
    }

    if (widget.isLoading || widget.duration <= Duration.zero) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
        child: LinearProgressIndicator(
          minHeight: 3,
          color: context.colors.primary,
          backgroundColor: context.grays.gray7,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      );
    }

    final maxMilliseconds = math.max(1, widget.duration.inMilliseconds);
    final currentMilliseconds = (_dragValueMilliseconds ??
            widget.position.inMilliseconds.toDouble())
        .clamp(0.0, maxMilliseconds.toDouble())
        .toDouble();
    final displayPosition = Duration(
      milliseconds: currentMilliseconds.round(),
    );

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: context.colors.primary,
            inactiveTrackColor: context.grays.gray7,
            thumbColor: context.colors.primary,
            overlayColor: context.colors.primary.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
          ),
          child: Slider(
            value: currentMilliseconds,
            min: 0,
            max: maxMilliseconds.toDouble(),
            onChangeStart: (value) {
              setState(() {
                _dragValueMilliseconds = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _dragValueMilliseconds = value;
              });
            },
            onChangeEnd: (value) {
              setState(() {
                _dragValueMilliseconds = null;
              });
              widget.onSeek(Duration(milliseconds: value.round()));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(displayPosition),
              style: FontStyles.med11.copyWith(color: context.grays.gray5),
            ),
            Text(
              _formatDuration(widget.duration),
              style: FontStyles.med11.copyWith(color: context.grays.gray5),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final minutes = safeDuration.inMinutes;
    final seconds = safeDuration.inSeconds.remainder(60).toString().padLeft(
      2,
      '0',
    );

    return '$minutes:$seconds';
  }
}

class _PlaybackStatusIcon extends StatelessWidget {
  const _PlaybackStatusIcon({
    required this.isExpanded,
    required this.isPlaying,
  });

  final bool isExpanded;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: ShapeDecoration(
        shape: const OvalBorder(),
        color: context.colors.primary,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(left: isPlaying ? 0 : 3),
        child: SvgPicture.asset(
          isExpanded && isPlaying
              ? 'assets/icons/cloud/pause.svg'
              : 'assets/icons/core/play.svg',
          width: 11,
          height: 11,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            context.colors.onPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
