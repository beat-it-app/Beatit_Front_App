import 'package:beatit_front_app/src/core/widgets/media/app_video_timeline.dart';

@Deprecated('Use AppVideoTimeline from core/widgets/media')
class CloudVideoTimeline extends AppVideoTimeline {
  const CloudVideoTimeline({
    super.key,
    required super.videoUri,
    required super.duration,
    required super.position,
    required super.isSelectionMode,
    required super.selectionStart,
    required super.selectionEnd,
    required super.onSeek,
    super.requestHeaders,
    super.onSelectionChanged,
    super.onSelectionChangeEnd,
  });
}

typedef CloudVideoSelectionChanged = AppVideoSelectionChanged;
