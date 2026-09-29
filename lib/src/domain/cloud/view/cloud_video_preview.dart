import 'dart:async';
import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_playback_button.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_video_timeline.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

enum _VideoPreviewLoadState { loading, ready, error }

enum _VideoRepeatMode { off, whole, selection }

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
  int _loadId = 0;

  CloudFilePreviewItem get _currentFile => widget.files[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    unawaited(_initializeVideo(resetState: false));
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

    if (!mounted || selectedIndex == null || selectedIndex == _currentIndex) {
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

  Widget _buildPreviewContent() {
    switch (_loadState) {
      case _VideoPreviewLoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case _VideoPreviewLoadState.error:
        return _VideoPreviewErrorView(onRetry: _initializeVideo);
      case _VideoPreviewLoadState.ready:
        final controller = _controller;
        if (controller == null || !controller.value.isInitialized) {
          return _VideoPreviewErrorView(onRetry: _initializeVideo);
        }

        return _VideoPreviewPlayer(
          key: ValueKey(
            _currentFile.previewUri?.toString() ?? _currentFile.name,
          ),
          controller: controller,
          previewUri: _currentFile.previewUri!,
          requestHeaders: widget.requestHeaders,
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
                0,
                AppSpacing.x24,
                0,
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

class _VideoPreviewPlayer extends StatefulWidget {
  const _VideoPreviewPlayer({
    super.key,
    required this.controller,
    required this.previewUri,
    this.requestHeaders,
  });

  final VideoPlayerController controller;
  final Uri previewUri;
  final Map<String, String>? requestHeaders;

  @override
  State<_VideoPreviewPlayer> createState() => _VideoPreviewPlayerState();
}

class _VideoPreviewPlayerState extends State<_VideoPreviewPlayer> {
  bool _isSelectionMode = false;
  Duration _selectionStart = Duration.zero;
  Duration _selectionEnd = Duration.zero;
  _VideoRepeatMode _repeatMode = _VideoRepeatMode.off;
  bool _isInternalSeek = false;

  VideoPlayerController get _controller => widget.controller;

  Duration get _duration => _controller.value.duration;

  Duration get _currentPosition {
    final duration = _controller.value.duration;
    final position = _controller.value.position;
    if (duration <= Duration.zero) {
      return Duration.zero;
    }
    return position > duration ? duration : position;
  }

  bool get _isRepeatEnabled => _repeatMode != _VideoRepeatMode.off;

  @override
  void initState() {
    super.initState();
    _selectionEnd = _duration;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  Future<void> _runInternalSeek(Future<void> Function() action) async {
    _isInternalSeek = true;
    try {
      await action();
    } finally {
      _isInternalSeek = false;
    }
  }

  void _handleControllerChanged() {
    if (!mounted || _isInternalSeek || !_controller.value.isInitialized) {
      return;
    }

    final value = _controller.value;
    final position = value.position;
    final duration = value.duration;

    if (_isSelectionMode && _selectionEnd > _selectionStart) {
      if (position >= _selectionEnd) {
        if (_repeatMode == _VideoRepeatMode.selection) {
          unawaited(
            _runInternalSeek(() async {
              await _controller.seekTo(_selectionStart);
              if (!value.isPlaying) {
                await _controller.play();
              }
            }),
          );
        } else if (value.isPlaying) {
          unawaited(
            _runInternalSeek(() async {
              await _controller.pause();
              await _controller.seekTo(_selectionEnd);
            }),
          );
        }
        return;
      }
    }

    if (!_isSelectionMode &&
        _repeatMode == _VideoRepeatMode.whole &&
        !value.isPlaying &&
        duration > Duration.zero &&
        position >= duration - const Duration(milliseconds: 120)) {
      unawaited(
        _runInternalSeek(() async {
          await _controller.seekTo(Duration.zero);
          await _controller.play();
        }),
      );
    }

    setState(() {});
  }

  Future<void> _togglePlayPause() async {
    if (!_controller.value.isInitialized) return;

    if (_controller.value.isPlaying) {
      await _controller.pause();
      return;
    }

    final duration = _duration;
    final position = _currentPosition;

    if (_isSelectionMode) {
      final clamped = position < _selectionStart || position >= _selectionEnd
          ? _selectionStart
          : position;
      await _controller.seekTo(clamped);
    } else if (duration > Duration.zero && position >= duration) {
      await _controller.seekTo(Duration.zero);
    }

    await _controller.play();
  }

  Future<void> _toggleRepeat() async {
    final nextMode = _isSelectionMode
        ? (_repeatMode == _VideoRepeatMode.selection
              ? _VideoRepeatMode.off
              : _VideoRepeatMode.selection)
        : (_repeatMode == _VideoRepeatMode.whole
              ? _VideoRepeatMode.off
              : _VideoRepeatMode.whole);

    await _controller.setLooping(false);

    if (!mounted) return;
    setState(() {
      _repeatMode = nextMode;
    });
  }

  Future<void> _toggleSelectionMode() async {
    if (!_controller.value.isInitialized || _duration <= Duration.zero) {
      return;
    }

    if (_isSelectionMode) {
      final keepPosition = _clampDuration(
        _currentPosition,
        _selectionStart,
        _selectionEnd,
      );

      await _controller.seekTo(keepPosition);
      if (!mounted) return;
      setState(() {
        _isSelectionMode = false;
        _selectionStart = Duration.zero;
        _selectionEnd = _duration;
        _repeatMode = _VideoRepeatMode.off;
      });
      return;
    }

    final sourceUs = _duration.inMicroseconds;
    final spanUs = math
        .max(Duration.microsecondsPerSecond, sourceUs ~/ 6)
        .toInt();
    final currentUs = _currentPosition.inMicroseconds;
    final maxStartUs = math.max(0, sourceUs - spanUs).toInt();
    final startUs = (currentUs - (spanUs ~/ 2)).clamp(0, maxStartUs).toInt();
    final endUs = math.min(sourceUs, startUs + spanUs).toInt();
    final start = Duration(microseconds: startUs);
    final end = Duration(microseconds: endUs);

    await _controller.seekTo(start);
    if (!mounted) return;

    setState(() {
      _isSelectionMode = true;
      _selectionStart = start;
      _selectionEnd = end;
      _repeatMode = _VideoRepeatMode.off;
    });
  }

  Future<void> _seek(Duration target) async {
    if (!_controller.value.isInitialized) return;

    final duration = _duration;
    if (duration <= Duration.zero) return;

    final clamped = _isSelectionMode
        ? _clampDuration(target, _selectionStart, _selectionEnd)
        : _clampDuration(target, Duration.zero, duration);

    await _controller.seekTo(clamped);
  }

  void _updateSelection(Duration start, Duration end) {
    if (!_isSelectionMode) return;

    setState(() {
      _selectionStart = start;
      _selectionEnd = end;
    });
  }

  Future<void> _applySelection(Duration start, Duration end) async {
    final safeStart = _clampDuration(start, Duration.zero, _duration);
    final safeEnd = _clampDuration(end, safeStart, _duration);
    if (safeEnd <= safeStart) return;

    final current = _currentPosition;
    final nextPosition = current < safeStart || current > safeEnd
        ? safeStart
        : current;

    await _controller.seekTo(nextPosition);
    if (!mounted) return;

    setState(() {
      _selectionStart = safeStart;
      _selectionEnd = safeEnd;
    });
  }

  Duration _clampDuration(Duration value, Duration minimum, Duration maximum) {
    if (value < minimum) return minimum;
    if (value > maximum) return maximum;
    return value;
  }

  String _formatDuration(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final hours = safe.inHours;
    final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');

    return hours > 0
        ? '$hours:$minutes:$seconds'
        : '${safe.inMinutes}:$seconds';
  }

  Widget _buildSideControl({
    required String semanticLabel,
    required String activeIcon,
    required String defaultIcon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          isActive ? activeIcon : defaultIcon,
          width: 27.0,
          colorFilter: ColorFilter.mode(context.grays.gray1, BlendMode.srcIn),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final aspectRatio = value.aspectRatio > 0 ? value.aspectRatio : 16 / 9;
        final leftLabel = _isSelectionMode ? _selectionStart : _currentPosition;
        final rightLabel = _isSelectionMode ? _selectionEnd : _duration;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: ColoredBox(
                  color: context.grays.black,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      VideoPlayer(_controller),
                      if (value.isBuffering)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSideControl(
                  semanticLabel: _isRepeatEnabled ? '반복재생 끄기' : '반복재생 켜기',
                  activeIcon: 'assets/icons/cloud/rotate_stop.svg',
                  defaultIcon: 'assets/icons/cloud/rotate.svg',
                  isActive: _isRepeatEnabled,
                  onPressed: () {
                    unawaited(_toggleRepeat());
                  },
                ),
                const SizedBox(width: AppSpacing.x30),
                CloudPlaybackButton(
                  semanticLabel: value.isPlaying ? '영상 일시정지' : '영상 재생',
                  iconPath: value.isPlaying
                      ? 'assets/icons/cloud/pause.svg'
                      : 'assets/icons/cloud/play.svg',
                  onPressed: () {
                    unawaited(_togglePlayPause());
                  },
                ),
                const SizedBox(width: AppSpacing.x24),
                _buildSideControl(
                  semanticLabel: _isSelectionMode ? '구간 선택 종료' : '재생 구간 선택',
                  activeIcon: 'assets/icons/cloud/music_loop_stop.svg',
                  defaultIcon: 'assets/icons/cloud/music_loop.svg',
                  isActive: _isSelectionMode,
                  onPressed: () {
                    unawaited(_toggleSelectionMode());
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(leftLabel),
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                  Text(
                    _formatDuration(rightLabel),
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: CloudVideoTimeline(
                videoUri: widget.previewUri,
                requestHeaders: widget.requestHeaders,
                duration: _duration,
                position: _currentPosition,
                isSelectionMode: _isSelectionMode,
                selectionStart: _selectionStart,
                selectionEnd: _selectionEnd,
                onSeek: (position) {
                  unawaited(_seek(position));
                },
                onSelectionChanged: _updateSelection,
                onSelectionChangeEnd: (start, end) {
                  unawaited(_applySelection(start, end));
                },
              ),
            ),
          ],
        );
      },
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
              style: FontStyles.med16.copyWith(color: context.grays.gray2),
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
