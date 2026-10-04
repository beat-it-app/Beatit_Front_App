import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';

/// 일정/투표 등 여러 화면에서 같은 형태로 사용하는 음악 미리듣기 행 UI.
/// 실제 재생 시간과 상태, 탭 동작은 각 화면이 관리하고 이 위젯은 표시만 담당한다.
class MusicPreviewListItem extends StatelessWidget {
  const MusicPreviewListItem({
    super.key,
    required this.trackText,
    required this.artistText,
    required this.onTap,
    this.isPlaying = false,
    this.isLoading = false,
  });

  final String trackText;
  final String artistText;
  final VoidCallback onTap;
  final bool isPlaying;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x16,
            vertical: AppSpacing.x12,
          ),
          child: Row(
            children: [
              const _PlaybackStatusIcon(),
              const SizedBox(width: AppSpacing.x16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trackText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med16.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      artistText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med12.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x12),
              _MusicWaveIndicator(isPlaying: isPlaying, isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaybackStatusIcon extends StatelessWidget {
  const _PlaybackStatusIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: ShapeDecoration(
        shape: const OvalBorder(),
        color: context.brands.beatOrange1,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: SvgPicture.asset(
          'assets/icons/core/play.svg',
          width: 10,
          height: 10,
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

class _MusicWaveIndicator extends StatelessWidget {
  const _MusicWaveIndicator({required this.isPlaying, required this.isLoading});

  final bool isPlaying;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      opacity: isLoading ? 0.45 : 1,
      child: SizedBox(
        width: 30,
        height: 20,
        child: TickerMode(
          enabled: isPlaying,
          child: LoadingIndicator(
            indicatorType: Indicator.lineScalePulseOut,
            colors: <Color>[context.colors.onSurface],
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
