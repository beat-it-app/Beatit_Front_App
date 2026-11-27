import 'package:beatit_front_app/src/core/widgets/media/app_audio_waveform.dart';
import 'package:just_waveform/just_waveform.dart';

@Deprecated('Use AppAudioWaveform from core/widgets/media')
class CloudAudioWaveform extends AppAudioWaveform {
  const CloudAudioWaveform({
    super.key,
    required Waveform? waveform,
    required super.duration,
    required super.position,
    required super.onSeek,
    super.loadingProgress,
    super.hasError,
    super.isSelectionMode,
    super.selectionStart,
    super.selectionEnd,
    super.onSelectionChanged,
    super.onSelectionChangeEnd,
  }) : super(waveform: waveform);
}

typedef CloudAudioSelectionChanged = AppAudioSelectionChanged;
