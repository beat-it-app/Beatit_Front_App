import 'package:beatit_front_app/src/core/widgets/music/music_preview_list_item.dart';
import 'package:flutter/material.dart';

/// 기존 일정 화면의 호출부를 유지하면서 공통 음악 미리듣기 위젯을 사용한다.
class MusicListItem extends StatelessWidget {
  const MusicListItem({
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
    return MusicPreviewListItem(
      trackText: trackText,
      artistText: artistText,
      onTap: onTap,
      isPlaying: isPlaying,
      isLoading: isLoading,
    );
  }
}
