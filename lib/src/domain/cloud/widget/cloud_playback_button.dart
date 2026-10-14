import 'package:beatit_front_app/src/core/widgets/media/app_playback_button.dart';

@Deprecated('Use AppPlaybackButton from core/widgets/media')
class CloudPlaybackButton extends AppPlaybackButton {
  const CloudPlaybackButton({
    super.key,
    required super.semanticLabel,
    required super.iconPath,
    required super.onPressed,
    super.width,
    super.height,
  });
}
