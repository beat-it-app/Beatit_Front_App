import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/media/app_playback_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 음성/영상 모두에서 동일한 반복/재생/구간 선택 버튼을 표시한다.
/// 반복 방식 및 플레이어 상태 변경은 호출하는 화면에서 처리한다.
class AppMediaPlaybackControls extends StatelessWidget {
  const AppMediaPlaybackControls({
    super.key,
    required this.mediaLabel,
    required this.isPlaying,
    required this.isRepeatEnabled,
    required this.isSelectionMode,
    required this.onTogglePlay,
    required this.onToggleRepeat,
    required this.onToggleSelection,
  });

  final String mediaLabel;
  final bool isPlaying;
  final bool isRepeatEnabled;
  final bool isSelectionMode;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleRepeat;
  final VoidCallback onToggleSelection;

  Widget _sideButton(
    BuildContext context, {
    required String semanticLabel,
    required String activeIcon,
    required String inactiveIcon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: IconButton(
        onPressed: onPressed,
        icon: Center(
          child: SvgPicture.asset(
            isActive ? activeIcon : inactiveIcon,
            width: 27.0,
            colorFilter: ColorFilter.mode(
              context.grays.gray1,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _sideButton(
          context,
          semanticLabel: isRepeatEnabled ? '반복재생 끄기' : '반복재생 켜기',
          activeIcon: 'assets/icons/cloud/rotate.svg',
          inactiveIcon: 'assets/icons/cloud/rotate_stop.svg',
          isActive: isRepeatEnabled,
          onPressed: onToggleRepeat,
        ),
        const SizedBox(width: AppSpacing.x30),
        AppPlaybackButton(
          semanticLabel: isPlaying ? '$mediaLabel 일시정지' : '$mediaLabel 재생',
          iconPath: isPlaying
              ? 'assets/icons/cloud/pause.svg'
              : 'assets/icons/cloud/play.svg',
          onPressed: onTogglePlay,
        ),
        const SizedBox(width: AppSpacing.x24),
        _sideButton(
          context,
          semanticLabel: isSelectionMode ? '구간 선택 종료' : '재생 구간 선택',
          activeIcon: 'assets/icons/cloud/music_loop.svg',
          inactiveIcon: 'assets/icons/cloud/music_loop_stop.svg',
          isActive: isSelectionMode,
          onPressed: onToggleSelection,
        ),
      ],
    );
  }
}
