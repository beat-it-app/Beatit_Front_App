import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/core/widgets/media/app_media_playback_controls.dart';
import 'package:beatit_front_app/src/core/widgets/media/app_playback_time_labels.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/core/widgets/media/app_video_timeline.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

enum _VideoPreviewLoadState { loading, ready, error }

enum _VideoRepeatMode { off, whole, selection }

class CloudVideoPreview extends StatefulWidget {
  const CloudVideoPreview({
    super.key,
    this.folderName = '',
    required this.files,
    this.onDeletePressed,
    this.onMovePressed,
    this.onDownloadPressed,
    this.onOpenExternalPressed,
    this.canManage = true,
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

  final ValueChanged<CloudFilePreviewItem>? onDeletePressed;
  final ValueChanged<CloudFilePreviewItem>? onMovePressed;
  final ValueChanged<CloudFilePreviewItem>? onDownloadPressed;
  final ValueChanged<CloudFilePreviewItem>? onOpenExternalPressed;
  final bool canManage;

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
  CancelToken? _downloadCancelToken;
  File? _temporaryVideo;
  Uri? _playbackUri;
  String? _failureMessage;
  bool _unsupportedCodec = false;
  static const int _maxFallbackBytes = 200 * 1024 * 1024;

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
    _downloadCancelToken?.cancel('영상 화면이 종료되었습니다.');
    final controller = _controller;
    final file = _temporaryVideo;
    unawaited(() async {
      await controller?.dispose();
      if (file != null) await _deleteTempFile(file);
    }());
    super.dispose();
  }

  Future<void> _showFileList() async {
    if (widget.files.length <= 1) return;

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

    if (selectedFile.type != CloudPreviewFileType.video ||
        selectedFile.previewUri == null) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() {
      _currentIndex = selectedIndex;
      _loadState = _VideoPreviewLoadState.loading;
    });

    await _initializeVideo(resetState: false);
  }

  Future<void> _deleteTempFile(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException catch (error) {
      debugPrint('[CloudVideoPreview] 임시 영상 정리 실패: $error');
    }
  }

  /// 네이티브 영상 플레이어가 CDN의 Range 요청/Content-Type을 처리하지 못할 때
  /// 기존 URL을 동일하게 받아 로컬 파일 재생으로 한 번 더 시도합니다.
  /// 실제 코덱 불일치나 CDN 403/404는 이 방식으로 해결할 수 없습니다.
  Future<File> _downloadForPlayback(
    Uri uri,
    String fileName,
    CancelToken cancelToken,
  ) async {
    final lastDot = fileName.lastIndexOf('.');
    final extension = lastDot > 0 ? fileName.substring(lastDot).toLowerCase() : '.mp4';
    final safeExtension = const {'.mp4', '.mov', '.avi', '.m4v'}.contains(extension)
        ? extension : '.mp4';
    final path = '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'beatit_video_${DateTime.now().microsecondsSinceEpoch}$safeExtension';
    final temp = File(path);
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(minutes: 2),
      headers: widget.requestHeaders ?? const <String, String>{},
    ));
    try {
      await dio.downloadUri(
        uri,
        path,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (received > _maxFallbackBytes || total > _maxFallbackBytes) {
            cancelToken.cancel('영상이 임시 재생 용량 제한을 초과했습니다.');
          }
        },
      );
      if (!await temp.exists() || await temp.length() == 0) {
        throw StateError('빈 동영상 파일이 전달되었습니다.');
      }
      return temp;
    } catch (_) {
      await _deleteTempFile(temp);
      rethrow;
    } finally {
      dio.close(force: true);
    }
  }

  /// Android MediaCodec's NO_EXCEEDS_CAPABILITIES identifies a decoder limit,
  /// not a URL, MIME header, or download error. Downloading the same bytes
  /// cannot change the decoder requirement.
  bool _isUnsupportedCodecError(Object error) {
    final detail = error.toString().toLowerCase();
    return detail.contains('no_exceeds_capabilities') ||
        detail.contains('no_unsupported_type') ||
        detail.contains('no_unsupported_drm') ||
        detail.contains('dvhe.') ||
        detail.contains('video/dolby-vision');
  }

  String _videoErrorMessage(Object error) {
    if (_isUnsupportedCodecError(error)) {
      final detail = error.toString().toLowerCase();
      if (detail.contains('dolby-vision') || detail.contains('dvhe.')) {
        return '이 기기에서는 Dolby Vision/HEVC 영상을 재생할 수 없습니다. '
            'H.264 영상과 AAC 음성의 일반 MP4로 변환하거나, '
            '지원하는 기기 또는 외부 앱에서 열어주세요.';
      }
      return '이 기기에서 지원하지 않는 영상 코덱입니다. '
          '호환 가능한 MP4(H.264/AAC)로 변환해주세요.';
    }
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return '영상 접근 권한이 없거나 URL이 만료되었습니다. (HTTP $statusCode)';
      }
      if (statusCode == 404) return '영상 파일을 찾을 수 없습니다. (HTTP 404)';
      if (statusCode != null) return '영상 다운로드가 실패했습니다. (HTTP $statusCode)';
      return '네트워크 문제로 영상을 불러오지 못했습니다.';
    }
    if (error is PlatformException) {
      return '영상을 재생할 수 없습니다. 영상 코덱이나 파일 형식을 확인해주세요.';
    }
    return '영상 파일을 불러오지 못했습니다. 다시 시도해주세요.';
  }

  Future<void> _initializeVideo({bool resetState = true}) async {
    final loadId = ++_loadId;
    _downloadCancelToken?.cancel('새 영상을 선택했습니다.');
    _downloadCancelToken = null;
    final previousController = _controller;
    final previousTempFile = _temporaryVideo;
    _controller = null;
    _temporaryVideo = null;
    _playbackUri = null;
    _failureMessage = null;
    _unsupportedCodec = false;

    if (resetState && mounted) {
      setState(() => _loadState = _VideoPreviewLoadState.loading);
    }

    // Android ExoPlayer의 decoder 자원을 해제한 뒤 새 컨트롤러를 초기화합니다.
    await previousController?.dispose();
    if (previousTempFile != null) await _deleteTempFile(previousTempFile);
    if (!mounted || loadId != _loadId) return;

    final previewUri = _currentFile.previewUri;
    if (_currentFile.type != CloudPreviewFileType.video ||
        previewUri == null ||
        !const {'http', 'https', 'file'}.contains(previewUri.scheme)) {
      setState(() {
        _failureMessage = '유효한 영상 주소를 확인할 수 없습니다.';
        _loadState = _VideoPreviewLoadState.error;
      });
      return;
    }

    VideoPlayerController? selectedController;
    File? localVideo;
    Object? networkError;
    try {
      final candidate = previewUri.scheme == 'file'
          ? VideoPlayerController.file(File.fromUri(previewUri))
          : VideoPlayerController.networkUrl(
              previewUri,
              httpHeaders: widget.requestHeaders ?? const <String, String>{},
            );
      try {
        await candidate.initialize();
        if (candidate.value.hasError) {
          throw StateError(candidate.value.errorDescription ?? '영상 초기화 오류');
        }
        selectedController = candidate;
      } catch (error) {
        networkError = error;
        debugPrint('[CloudVideoPreview] URL 재생 실패 (${previewUri.host}${previewUri.path}): $error');
        await candidate.dispose();
        // 코덱 미지원은 재다운로드로 해결되지 않으므로 중복 다운로드 생략.
        if (previewUri.scheme == 'file' || _isUnsupportedCodecError(error)) {
          rethrow;
        }

        // CDN은 200으로 파일을 내려주지만 직접 스트리밍이 안 되는 경우가 있어
        // 실제 파일을 받아 로컬 재생을 시도합니다. 최대 200MB까지만 허용합니다.
        final cancelToken = CancelToken();
        _downloadCancelToken = cancelToken;
        localVideo = await _downloadForPlayback(
          previewUri, _currentFile.name, cancelToken,
        );
        if (!mounted || loadId != _loadId) {
          await _deleteTempFile(localVideo);
          return;
        }
        final fallbackController = VideoPlayerController.file(localVideo);
        try {
          await fallbackController.initialize();
          if (fallbackController.value.hasError) {
            throw StateError(fallbackController.value.errorDescription ?? '로컬 영상 오류');
          }
          selectedController = fallbackController;
        } catch (_) {
          await fallbackController.dispose();
          rethrow;
        }
      }

      if (!mounted || loadId != _loadId) {
        await selectedController?.dispose();
        if (localVideo != null) await _deleteTempFile(localVideo);
        return;
      }
      setState(() {
        _controller = selectedController;
        _temporaryVideo = localVideo;
        _playbackUri = localVideo?.uri ?? previewUri;
        _loadState = _VideoPreviewLoadState.ready;
      });
    } catch (error, stackTrace) {
      debugPrint('[CloudVideoPreview] 영상 초기화 최종 실패: $error');
      if (networkError != null) {
        debugPrint('[CloudVideoPreview] 최초 네트워크 재생 실패: $networkError');
      }
      debugPrintStack(stackTrace: stackTrace);
      await selectedController?.dispose();
      if (localVideo != null) await _deleteTempFile(localVideo);
      if (!mounted || loadId != _loadId) return;
      final originalFailure = networkError != null &&
              _isUnsupportedCodecError(networkError)
          ? networkError
          : error;
      setState(() {
        _unsupportedCodec = _isUnsupportedCodecError(originalFailure);
        _failureMessage = _videoErrorMessage(originalFailure);
        _loadState = _VideoPreviewLoadState.error;
      });
    } finally {
      if (loadId == _loadId) _downloadCancelToken = null;
    }
  }

  Future<void> _openExternalVideo() async {
    if (widget.onOpenExternalPressed != null) {
      widget.onOpenExternalPressed!(_currentFile);
      return;
    }
    final uri = _currentFile.previewUri;
    if (uri == null || !{'http', 'https'}.contains(uri.scheme)) return;
    try {
      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success && mounted) _showExternalOpenError();
    } catch (_) {
      if (mounted) _showExternalOpenError();
    }
  }

  void _showExternalOpenError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('외부 앱에서도 영상을 열지 못했습니다.')),
    );
  }

  VoidCallback? get _openExternalAction {
    if (widget.onOpenExternalPressed != null) {
      return () => unawaited(_openExternalVideo());
    }
    final uri = _currentFile.previewUri;
    if (uri != null && {'http', 'https'}.contains(uri.scheme) &&
        (widget.requestHeaders == null || widget.requestHeaders!.isEmpty)) {
      return () => unawaited(_openExternalVideo());
    }
    return null;
  }

  Widget _buildPreviewContent() {
    switch (_loadState) {
      case _VideoPreviewLoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case _VideoPreviewLoadState.error:
        return _VideoPreviewErrorView(
          onRetry: _unsupportedCodec ? null : _initializeVideo,
          message: _failureMessage,
          onOpenExternal: _openExternalAction,
        );
      case _VideoPreviewLoadState.ready:
        final controller = _controller;
        if (controller == null || !controller.value.isInitialized) {
          return _VideoPreviewErrorView(
            onRetry: _unsupportedCodec ? null : _initializeVideo,
            message: _failureMessage,
            onOpenExternal: _openExternalAction,
          );
        }

        return _VideoPreviewPlayer(
          key: ValueKey(
            _currentFile.previewUri?.toString() ?? _currentFile.name,
          ),
          controller: controller,
          previewUri: _playbackUri ?? _currentFile.previewUri!,
          requestHeaders: _temporaryVideo == null ? widget.requestHeaders : null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;
    final showDelete = widget.canManage && widget.onDeletePressed != null;
    final showMove = widget.canManage && widget.onMovePressed != null;
    final showDownload = widget.onDownloadPressed != null;
    final showActions = showDelete || showMove || showDownload;

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: CloudFileAppbar(
        titleText: _currentFile.name,
        onLeadingPressed: widget.files.length > 1 ? _showFileList : null,
        onTitlePressed: widget.files.length > 1 ? _showFileList : null,
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
                showActions ? 98.0 + bottomSafeArea : AppSpacing.x24,
              ),
              child: _buildPreviewContent(),
            ),
            if (showActions)
              Positioned(
                left: AppSpacing.x16,
                bottom: AppSpacing.x16 + bottomSafeArea,
                child: CloudSelectionFloatingBar(
                  isEnabled: true,
                  showDelete: showDelete,
                  showMove: showMove,
                  showDownload: showDownload,
                  onDeletePressed: () => widget.onDeletePressed?.call(_currentFile),
                  onMovePressed: () => widget.onMovePressed?.call(_currentFile),
                  onDownloadPressed: showDownload
                      ? () => widget.onDownloadPressed?.call(_currentFile)
                      : null,
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
  _VideoRepeatMode _repeatMode = _VideoRepeatMode.whole;
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
      final nextRepeatMode = _repeatMode == _VideoRepeatMode.off
          ? _VideoRepeatMode.off
          : _VideoRepeatMode.whole;
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
        _repeatMode = nextRepeatMode;
      });
      return;
    }

    final sourceUs = _duration.inMicroseconds;
    const desiredSpanUs = 20 * Duration.microsecondsPerSecond;
    final currentUs = _currentPosition.inMicroseconds;
    final startUs = currentUs >= sourceUs
        ? math.max(0, sourceUs - desiredSpanUs).toInt()
        : currentUs;
    final endUs = math.min(sourceUs, startUs + desiredSpanUs).toInt();
    final start = Duration(microseconds: startUs);
    final end = Duration(microseconds: endUs);

    await _controller.seekTo(start);
    if (!mounted) return;

    setState(() {
      _isSelectionMode = true;
      _selectionStart = start;
      _selectionEnd = end;
      _repeatMode = _VideoRepeatMode.selection;
    });
  }

  Future<void> _resumeFromScrub(Duration target) async {
    if (!_controller.value.isInitialized) return;
    await _controller.pause();
    await _seek(target);
    if (mounted && _controller.value.isInitialized) {
      await _controller.play();
    }
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final aspectRatio = value.aspectRatio > 0 ? value.aspectRatio : 16 / 9;

        return LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
            SizedBox(
              width: double.infinity,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width,
                    maxHeight: math.min(
                      constraints.maxHeight * 0.48,
                      MediaQuery.sizeOf(context).height * 0.42,
                    ),
                  ),
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
              ),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppMediaPlaybackControls(
              mediaLabel: '영상',
              isPlaying: value.isPlaying,
              isRepeatEnabled: _isRepeatEnabled,
              isSelectionMode: _isSelectionMode,
              onToggleRepeat: () => unawaited(_toggleRepeat()),
              onTogglePlay: () => unawaited(_togglePlayPause()),
              onToggleSelection: () => unawaited(_toggleSelectionMode()),
            ),
            const SizedBox(height: AppSpacing.x24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: AppPlaybackTimeLabels(
                position: _currentPosition,
                duration: _duration,
                isSelectionMode: _isSelectionMode,
                selectionStart: _selectionStart,
                selectionEnd: _selectionEnd,
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: AppVideoTimeline(
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
                onScrubStart: () => unawaited(_controller.pause()),
                onScrubEnd: _resumeFromScrub,
                onSelectionChanged: _updateSelection,
                onSelectionChangeEnd: (start, end) {
                  unawaited(_applySelection(start, end));
                },
              ),
            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VideoPreviewErrorView extends StatelessWidget {
  const _VideoPreviewErrorView({
    required this.onRetry,
    this.onOpenExternal,
    this.message,
  });

  final Future<void> Function()? onRetry;
  final VoidCallback? onOpenExternal;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? '불러오지 못했습니다. 다시 시도해주세요',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(color: context.grays.gray2),
            ),
            const SizedBox(height: AppSpacing.x16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.x8,
              children: [
                if (onRetry != null)
                  Semantics(
                    button: true,
                    label: '영상 미리보기 다시 시도',
                    child: TextButton(
                      onPressed: () => unawaited(onRetry!()),
                    child: Text(
                      '다시 시도',
                      style: FontStyles.med14.copyWith(
                        color: context.brands.beatOrange1,
                      ),
                    ),
                  ),
                ),
                if (onOpenExternal != null)
                  TextButton(
                    onPressed: onOpenExternal,
                    child: const Text('외부 앱에서 열기'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
