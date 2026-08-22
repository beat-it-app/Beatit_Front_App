import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

enum _VideoPreviewLoadState { loading, ready, error }

class CloudVideoPreview extends StatefulWidget {
  const CloudVideoPreview({
    super.key,
    required this.folderName,
    required this.files,
    required this.onDeletePressed,
    required this.onMovePressed,
    required this.onDownloadPressed,
    this.initialIndex = 0,
    this.requestHeaders,
    this.onFileSelected,
  }) : assert(files.length > 0, 'files에는 하나 이상의 파일이 필요합니다.'),
       assert(
         initialIndex >= 0 && initialIndex < files.length,
         'initialIndex가 files 범위를 벗어났습니다.',
       );

  final String folderName;
  final List<CloudFilePreviewItem> files;
  final int initialIndex;
  final Map<String, String>? requestHeaders;

  final ValueChanged<CloudFilePreviewItem> onDeletePressed;
  final ValueChanged<CloudFilePreviewItem> onMovePressed;
  final ValueChanged<CloudFilePreviewItem> onDownloadPressed;

  /// 영상 외 파일을 선택했을 때 해당 Preview로 전환시키는 진입점이다.
  final ValueChanged<CloudFilePreviewItem>? onFileSelected;

  @override
  State<CloudVideoPreview> createState() => _CloudVideoPreviewState();
}

class _CloudVideoPreviewState extends State<CloudVideoPreview> {
  late int _currentIndex;

  VideoPlayerController? _controller;
  _VideoPreviewLoadState _loadState = _VideoPreviewLoadState.loading;

  /// 빠르게 파일을 바꿀 때 이전 initialize 결과가 현재 화면을 덮어쓰지 않게 한다.
  int _loadId = 0;

  CloudFilePreviewItem get _currentFile => widget.files[_currentIndex];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
    _initializeVideo(resetState: false);
  }

  @override
  void dispose() {
    _loadId += 1;
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _showFileList() async {
    final selectedIndex = await showCloudPreviewFileListBottomSheet(
      context: context,
      folderName: widget.folderName,
      itemCount: widget.files.length,
      itemBuilder: (sheetContext, index) {
        final file = widget.files[index];

        return CloudItemWidget(
          itemType: file.type.cloudItemType,
          fileName: file.name,
          fileSize: file.sizeLabel,
          uploadedAt: file.uploadedAt,
          uploaderName: file.uploaderName,
          isSelected: index == _currentIndex,
          showMoreMenu: false,
          onTap: () {
            Navigator.of(sheetContext).pop(index);
          },
        );
      },
    );

    if (!mounted ||
        selectedIndex == null ||
        selectedIndex == _currentIndex) {
      return;
    }

    final selectedFile = widget.files[selectedIndex];

    if (selectedFile.type != CloudPreviewFileType.video) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() {
      _currentIndex = selectedIndex;
      _loadState = _VideoPreviewLoadState.loading;
    });

    await _initializeVideo(resetState: false);
  }

  Future<void> _initializeVideo({bool resetState = true}) async {
    final loadId = ++_loadId;
    final previousController = _controller;
    _controller = null;

    if (resetState && mounted) {
      setState(() {
        _loadState = _VideoPreviewLoadState.loading;
      });
    }

    await previousController?.dispose();

    if (!mounted || loadId != _loadId) {
      return;
    }

    final previewUri = _currentFile.previewUri;

    if (_currentFile.type != CloudPreviewFileType.video || previewUri == null) {
      setState(() {
        _loadState = _VideoPreviewLoadState.error;
      });
      return;
    }

    final controller = VideoPlayerController.networkUrl(
      previewUri,
      httpHeaders: widget.requestHeaders ?? const <String, String>{},
    );

    try {
      await controller.initialize();

      if (!mounted || loadId != _loadId) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _loadState = _VideoPreviewLoadState.ready;
      });
    } catch (error, stackTrace) {
      debugPrint('[CloudVideoPreview] video initialize failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      await controller.dispose();

      if (!mounted || loadId != _loadId) {
        return;
      }

      setState(() {
        _loadState = _VideoPreviewLoadState.error;
      });
    }
  }

  Future<void> _togglePlayback() async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (controller.value.isPlaying) {
      await controller.pause();
      return;
    }

    final duration = controller.value.duration;
    final position = controller.value.position;

    if (duration > Duration.zero && position >= duration) {
      await controller.seekTo(Duration.zero);
    }

    await controller.play();
  }

  Future<void> _seekTo(double milliseconds) async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    await controller.seekTo(
      Duration(milliseconds: milliseconds.round()),
    );
  }

  Widget _buildPreviewContent() {
    switch (_loadState) {
      case _VideoPreviewLoadState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      case _VideoPreviewLoadState.error:
        return _VideoPreviewErrorView(
          onRetry: _initializeVideo,
        );

      case _VideoPreviewLoadState.ready:
        final controller = _controller;

        if (controller == null || !controller.value.isInitialized) {
          return _VideoPreviewErrorView(
            onRetry: _initializeVideo,
          );
        }

        return _VideoPreviewPlayer(
          controller: controller,
          onTogglePlayback: _togglePlayback,
          onSeek: _seekTo,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(
        titleText: _currentFile.name,
        onLeadingPressed: _showFileList,
        onTitlePressed: _showFileList,
      ),
      body: CloudPreviewBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.x16,
                AppSpacing.x24,
                AppSpacing.x16,
                98.0 + bottomSafeArea,
              ),
              child: _buildPreviewContent(),
            ),
            Positioned(
              left: AppSpacing.x16,
              bottom: AppSpacing.x16 + bottomSafeArea,
              child: CloudSelectionFloatingBar(
                isEnabled: true,
                onDeletePressed: () {
                  widget.onDeletePressed(_currentFile);
                },
                onMovePressed: () {
                  widget.onMovePressed(_currentFile);
                },
                onDownloadPressed: () {
                  widget.onDownloadPressed(_currentFile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPreviewPlayer extends StatelessWidget {
  const _VideoPreviewPlayer({
    required this.controller,
    required this.onTogglePlayback,
    required this.onSeek,
  });

  final VideoPlayerController controller;
  final Future<void> Function() onTogglePlayback;
  final Future<void> Function(double milliseconds) onSeek;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final durationMs = value.duration.inMilliseconds;
        final maxMs = durationMs <= 0 ? 1.0 : durationMs.toDouble();
        final positionMs = value.position.inMilliseconds
            .clamp(0, durationMs <= 0 ? 0 : durationMs)
            .toDouble();

        return Column(
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: value.aspectRatio > 0
                      ? value.aspectRatio
                      : 16 / 9,
                  child: ColoredBox(
                    color: context.grays.black,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        VideoPlayer(controller),
                        Center(
                          child: _VideoPlaybackButton(
                            isPlaying: value.isPlaying,
                            onPressed: onTogglePlayback,
                          ),
                        ),
                        if (value.isBuffering)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x20),
            Row(
              children: [
                Text(
                  _formatDuration(value.position),
                  style: FontStyles.med12.copyWith(
                    color: context.grays.gray3,
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      activeTrackColor: context.brands.beatOrange1,
                      inactiveTrackColor: context.grays.gray6,
                      thumbColor: context.brands.beatOrange1,
                      overlayColor: context.brands.beatOrange1.withValues(
                        alpha: 0.12,
                      ),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14.0,
                      ),
                    ),
                    child: Semantics(
                      label: '영상 재생 위치',
                      value:
                          '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                      child: Slider(
                        value: positionMs.clamp(0.0, maxMs).toDouble(),
                        min: 0.0,
                        max: maxMs,
                        onChanged: durationMs <= 0 ? null : onSeek,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                Text(
                  _formatDuration(value.duration),
                  style: FontStyles.med12.copyWith(
                    color: context.grays.gray3,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _VideoPlaybackButton extends StatelessWidget {
  const _VideoPlaybackButton({
    required this.isPlaying,
    required this.onPressed,
  });

  final bool isPlaying;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isPlaying ? '영상 일시정지' : '영상 재생',
      child: Material(
        color: context.grays.white.withValues(alpha: 0.9),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            onPressed();
          },
          child: SizedBox(
            width: 56.0,
            height: 56.0,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32.0,
              color: context.grays.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoPreviewErrorView extends StatelessWidget {
  const _VideoPreviewErrorView({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '불러오지 못했습니다. 다시 시도해주세요',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(
                color: context.grays.gray2,
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            Semantics(
              button: true,
              label: '영상 미리보기 다시 시도',
              child: TextButton(
                onPressed: () {
                  onRetry();
                },
                child: Text(
                  '다시 시도',
                  style: FontStyles.med14.copyWith(
                    color: context.brands.beatOrange1,
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

String _formatDuration(Duration duration) {
  final totalSeconds = duration.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;

  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
