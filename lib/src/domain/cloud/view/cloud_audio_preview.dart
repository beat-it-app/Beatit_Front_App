import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_audio_waveform.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/bottomsheet/cloud_file_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_preview_background.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_playback_button.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/select_float_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';

enum _AudioLoadState { loading, ready, error }

enum _AudioRepeatMode { off, whole, selection }

class CloudAudioPreview extends StatefulWidget {
  const CloudAudioPreview({
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

  /// 음원 외 파일을 선택했을 때 해당 Preview 화면으로 전환하는 진입점이다.
  final ValueChanged<CloudFilePreviewItem>? onFileSelected;

  @override
  State<CloudAudioPreview> createState() => _CloudAudioPreviewState();
}

class _CloudAudioPreviewState extends State<CloudAudioPreview> {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<WaveformProgress>? _waveformSubscription;

  HttpClient? _waveformHttpClient;
  Directory? _waveformTempDirectory;

  late int _currentIndex;

  _AudioLoadState _loadState = _AudioLoadState.loading;
  _AudioRepeatMode _repeatMode = _AudioRepeatMode.off;

  Duration _sourceDuration = Duration.zero;
  Duration _playerPosition = Duration.zero;
  Duration _clipStart = Duration.zero;
  Duration _selectionStart = Duration.zero;
  Duration _selectionEnd = Duration.zero;

  Waveform? _waveform;
  double _waveformProgress = 0.0;

  bool _isPlaying = false;
  bool _isSelectionMode = false;
  bool _isClipApplied = false;

  int _loadRequestId = 0;

  CloudFilePreviewItem get _currentFile => widget.files[_currentIndex];

  Duration get _displayPosition {
    final absolutePosition = _isClipApplied
        ? _clipStart + _playerPosition
        : _playerPosition;

    return _clampDuration(absolutePosition, Duration.zero, _sourceDuration);
  }

  bool get _isRepeatEnabled {
    if (_isSelectionMode) {
      return _repeatMode == _AudioRepeatMode.selection;
    }
    return _repeatMode == _AudioRepeatMode.whole;
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
    _bindPlayerStreams();
    unawaited(_loadCurrentFile());
  }

  void _bindPlayerStreams() {
    _positionSubscription = _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _playerPosition = position);
    });

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying =
            state.playing && state.processingState != ProcessingState.completed;
      });

      if (state.processingState == ProcessingState.completed &&
          _repeatMode == _AudioRepeatMode.off) {
        unawaited(_resetAfterCompletion());
      }
    });
  }

  Future<void> _resetAfterCompletion() async {
    await _player.pause();
    await _player.seek(Duration.zero);
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
          onTap: () => Navigator.of(sheetContext).pop(index),
        );
      },
    );

    if (!mounted || selectedIndex == null || selectedIndex == _currentIndex) {
      return;
    }

    final selectedFile = widget.files[selectedIndex];

    if (selectedFile.type != CloudPreviewFileType.audio) {
      widget.onFileSelected?.call(selectedFile);
      return;
    }

    setState(() => _currentIndex = selectedIndex);
    await _loadCurrentFile();
  }

  Future<void> _loadCurrentFile() async {
    final requestId = ++_loadRequestId;
    final previewUri = _currentFile.previewUri;

    await _cancelWaveformWork();
    await _player.stop();

    if (!mounted || requestId != _loadRequestId) return;

    setState(() {
      _loadState = _AudioLoadState.loading;
      _repeatMode = _AudioRepeatMode.off;
      _sourceDuration = Duration.zero;
      _playerPosition = Duration.zero;
      _clipStart = Duration.zero;
      _selectionStart = Duration.zero;
      _selectionEnd = Duration.zero;
      _waveform = null;
      _waveformProgress = 0.0;
      _isSelectionMode = false;
      _isClipApplied = false;
    });

    if (previewUri == null) {
      _setLoadError(requestId);
      return;
    }

    try {
      await _player.setLoopMode(LoopMode.off);

      final duration = previewUri.scheme == 'file'
          ? await _player.setFilePath(previewUri.toFilePath())
          : await _player.setUrl(
              previewUri.toString(),
              headers: widget.requestHeaders,
            );

      if (!mounted || requestId != _loadRequestId) return;

      final resolvedDuration = duration ?? _player.duration ?? Duration.zero;

      setState(() {
        _sourceDuration = resolvedDuration;
        _selectionEnd = resolvedDuration;
        _loadState = _AudioLoadState.ready;
      });

      // 재생은 URL을 바로 사용하고, 파형 추출용 파일만 별도로 임시 저장한다.
      unawaited(_prepareWaveform(previewUri, requestId));
    } catch (error, stackTrace) {
      debugPrint('[CloudAudioPreview] audio load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _setLoadError(requestId);
    }
  }

  void _setLoadError(int requestId) {
    if (!mounted || requestId != _loadRequestId) return;

    setState(() {
      _loadState = _AudioLoadState.error;
      _isPlaying = false;
    });
  }

  Future<void> _prepareWaveform(Uri uri, int requestId) async {
    try {
      final audioFile = await _waveformInputFile(uri, requestId);

      if (audioFile == null || !mounted || requestId != _loadRequestId) {
        return;
      }

      final directory = _waveformTempDirectory;
      if (directory == null) return;

      final waveformFile = File('${directory.path}/waveform.wave');

      await _waveformSubscription?.cancel();
      _waveformSubscription =
          JustWaveform.extract(
            audioInFile: audioFile,
            waveOutFile: waveformFile,
            zoom: const WaveformZoom.pixelsPerSecond(80),
          ).listen(
            (progress) {
              if (!mounted || requestId != _loadRequestId) return;

              setState(() {
                _waveformProgress = progress.progress.clamp(0.0, 1.0);
                _waveform = progress.waveform ?? _waveform;
              });
            },
            onError: (Object error, StackTrace stackTrace) {
              debugPrint('[CloudAudioPreview] waveform extract failed: $error');
              debugPrintStack(stackTrace: stackTrace);

              if (!mounted || requestId != _loadRequestId) return;
              setState(() => _waveformProgress = 1.0);
            },
          );
    } catch (error, stackTrace) {
      debugPrint('[CloudAudioPreview] waveform prepare failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || requestId != _loadRequestId) return;
      setState(() => _waveformProgress = 1.0);
    }
  }

  Future<File?> _waveformInputFile(Uri uri, int requestId) async {
    if (uri.scheme == 'file') {
      final directory = await Directory.systemTemp.createTemp(
        'beatit_audio_waveform_',
      );

      if (requestId != _loadRequestId) {
        await directory.delete(recursive: true);
        return null;
      }

      _waveformTempDirectory = directory;
      return File.fromUri(uri);
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return null;
    }

    final directory = await Directory.systemTemp.createTemp(
      'beatit_audio_waveform_',
    );

    if (requestId != _loadRequestId) {
      await directory.delete(recursive: true);
      return null;
    }

    _waveformTempDirectory = directory;
    final audioFile = File(
      '${directory.path}/audio${_fileExtension(uri.path)}',
    );

    final client = HttpClient();
    _waveformHttpClient = client;

    try {
      final request = await client.getUrl(uri);
      widget.requestHeaders?.forEach((key, value) {
        request.headers.set(key, value);
      });

      final response = await request.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Waveform audio download failed: ${response.statusCode}',
          uri: uri,
        );
      }

      await response.pipe(audioFile.openWrite());

      if (requestId != _loadRequestId) return null;
      return audioFile;
    } finally {
      client.close(force: true);
      if (identical(_waveformHttpClient, client)) {
        _waveformHttpClient = null;
      }
    }
  }

  String _fileExtension(String path) {
    final slash = path.lastIndexOf('/');
    final dot = path.lastIndexOf('.');

    if (dot <= slash || dot == path.length - 1) return '.audio';

    final extension = path.substring(dot);
    return extension.length <= 8 ? extension : '.audio';
  }

  Future<void> _togglePlayPause() async {
    if (_loadState != _AudioLoadState.ready ||
        _sourceDuration == Duration.zero) {
      return;
    }

    if (_player.playing) {
      await _player.pause();
      return;
    }

    final playableDuration = _isClipApplied
        ? _selectionEnd - _clipStart
        : _sourceDuration;

    if (_player.position >= playableDuration) {
      await _player.seek(Duration.zero);
    }

    unawaited(_player.play());
  }

  Future<void> _toggleRepeat() async {
    if (_loadState != _AudioLoadState.ready) return;

    final nextMode = _isSelectionMode
        ? (_repeatMode == _AudioRepeatMode.selection
              ? _AudioRepeatMode.off
              : _AudioRepeatMode.selection)
        : (_repeatMode == _AudioRepeatMode.whole
              ? _AudioRepeatMode.off
              : _AudioRepeatMode.whole);

    await _player.setLoopMode(
      nextMode == _AudioRepeatMode.off ? LoopMode.off : LoopMode.one,
    );

    if (!mounted) return;
    setState(() => _repeatMode = nextMode);
  }

  Future<void> _toggleSelectionMode() async {
    if (_loadState != _AudioLoadState.ready ||
        _sourceDuration == Duration.zero) {
      return;
    }

    final wasPlaying = _player.playing;
    final absolutePosition = _displayPosition;

    await _player.pause();
    await _player.setLoopMode(LoopMode.off);

    if (_isSelectionMode) {
      await _player.setClip(start: null, end: null);
      await _player.seek(absolutePosition);

      if (!mounted) return;
      setState(() {
        _isSelectionMode = false;
        _isClipApplied = false;
        _clipStart = Duration.zero;
        _repeatMode = _AudioRepeatMode.off;
        _playerPosition = absolutePosition;
      });
    } else {
      final sourceUs = _sourceDuration.inMicroseconds;
      final spanUs = math.max(1, sourceUs ~/ 6).toInt();
      final halfSpanUs = spanUs ~/ 2;
      final currentUs = absolutePosition.inMicroseconds;
      final maxStartUs = math.max(0, sourceUs - spanUs).toInt();
      final selectionStartUs = (currentUs - halfSpanUs)
          .clamp(0, maxStartUs)
          .toInt();
      final selectionEndUs = math
          .min(sourceUs, selectionStartUs + spanUs)
          .toInt();
      final selectionStart = Duration(microseconds: selectionStartUs);
      final selectionEnd = Duration(microseconds: selectionEndUs);
      final clampedPosition = _clampDuration(
        absolutePosition,
        selectionStart,
        selectionEnd,
      );

      await _player.setClip(start: selectionStart, end: selectionEnd);
      await _player.seek(clampedPosition - selectionStart);

      if (!mounted) return;
      setState(() {
        _isSelectionMode = true;
        _isClipApplied = true;
        _clipStart = selectionStart;
        _repeatMode = _AudioRepeatMode.off;
        _selectionStart = selectionStart;
        _selectionEnd = selectionEnd;
        _playerPosition = clampedPosition - selectionStart;
      });
    }

    if (wasPlaying) unawaited(_player.play());
  }

  void _updateSelection(Duration start, Duration end) {
    if (!_isSelectionMode) return;

    setState(() {
      _selectionStart = start;
      _selectionEnd = end;
    });
  }

  Future<void> _applySelection(Duration start, Duration end) async {
    if (!_isSelectionMode || _sourceDuration == Duration.zero) return;

    final safeStart = _clampDuration(start, Duration.zero, _sourceDuration);
    final safeEnd = _clampDuration(end, safeStart, _sourceDuration);
    if (safeEnd <= safeStart) return;

    final wasPlaying = _player.playing;
    final absolutePosition = _clampDuration(
      _displayPosition,
      safeStart,
      safeEnd,
    );

    await _player.pause();
    await _player.setClip(start: safeStart, end: safeEnd);
    await _player.setLoopMode(
      _repeatMode == _AudioRepeatMode.selection ? LoopMode.one : LoopMode.off,
    );
    await _player.seek(absolutePosition - safeStart);

    if (!mounted) return;
    setState(() {
      _selectionStart = safeStart;
      _selectionEnd = safeEnd;
      _clipStart = safeStart;
      _isClipApplied = true;
      _playerPosition = absolutePosition - safeStart;
    });

    if (wasPlaying) unawaited(_player.play());
  }

  Future<void> _seek(Duration target) async {
    if (_loadState != _AudioLoadState.ready ||
        _sourceDuration == Duration.zero) {
      return;
    }

    final absoluteTarget = _clampDuration(
      target,
      Duration.zero,
      _sourceDuration,
    );

    if (_isClipApplied) {
      final clippedTarget = _clampDuration(
        absoluteTarget,
        _selectionStart,
        _selectionEnd,
      );
      await _player.seek(clippedTarget - _clipStart);
      return;
    }

    await _player.seek(absoluteTarget);
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

  Widget _buildBody() {
    switch (_loadState) {
      case _AudioLoadState.loading:
        return const Center(child: CircularProgressIndicator());
      case _AudioLoadState.error:
        return _AudioErrorView(onRetry: () => unawaited(_loadCurrentFile()));
      case _AudioLoadState.ready:
        return Center(child: _buildPlayer());
    }
  }

  Widget _buildPlayer() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x24,
        AppSpacing.x20,
        100.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/icons/cloud/sound.svg',
                  width: 200.0,
                  height: 170.0,
                ),
              ),
              const SizedBox(height: AppSpacing.x30),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.x8,
                children: [
                  Text(
                    _currentFile.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: FontStyles.semi20.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                  if (_currentFile.sizeLabel?.isNotEmpty == true)
                    Text(
                      _currentFile.sizeLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: FontStyles.semi20.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                _currentFile.uploadedAt,
                style: FontStyles.med16.copyWith(color: context.grays.gray6),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x70),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSideControl(
                    semanticLabel: _isRepeatEnabled ? '반복재생 끄기' : '반복재생 켜기',
                    icon1: 'assets/icons/cloud/rotate_stop.svg',
                    icon2: 'assets/icons/cloud/rotate.svg',
                    isActive: _isRepeatEnabled,
                    onPressed: () => unawaited(_toggleRepeat()),
                  ),
                  const SizedBox(width: AppSpacing.x30),
                  CloudPlaybackButton(
                    semanticLabel: _isPlaying ? '음원 일시정지' : '음원 재생',
                    iconPath: _isPlaying
                        ? 'assets/icons/cloud/pause.svg'
                        : 'assets/icons/cloud/play.svg',
                    onPressed: () => unawaited(_togglePlayPause()),
                  ),
                  const SizedBox(width: AppSpacing.x24),
                  _buildSideControl(
                    semanticLabel: _isSelectionMode ? '구간 선택 종료' : '재생 구간 선택',
                    icon1: 'assets/icons/cloud/music_loop_stop.svg',
                    icon2: 'assets/icons/cloud/music_loop.svg',
                    isActive: _isSelectionMode,
                    onPressed: () => unawaited(_toggleSelectionMode()),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(
                      _isSelectionMode ? _selectionStart : _displayPosition,
                    ),
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                  Text(
                    _formatDuration(
                      _isSelectionMode ? _selectionEnd : _sourceDuration,
                    ),
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ],
              ),
              CloudAudioWaveform(
                waveform: _waveform,
                loadingProgress: _waveformProgress,
                duration: _sourceDuration,
                position: _displayPosition,
                isSelectionMode: _isSelectionMode,
                selectionStart: _selectionStart,
                selectionEnd: _selectionEnd,
                onSeek: (position) => unawaited(_seek(position)),
                onSelectionChanged: _updateSelection,
                onSelectionChangeEnd: (start, end) {
                  unawaited(_applySelection(start, end));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSideControl({
    required String semanticLabel,
    required String icon1,
    required String icon2,
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
            isActive ? icon1 : icon2,
            width: 27.0,
            colorFilter: ColorFilter.mode(context.grays.gray1, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Future<void> _cancelWaveformWork() async {
    await _waveformSubscription?.cancel();
    _waveformSubscription = null;

    _waveformHttpClient?.close(force: true);
    _waveformHttpClient = null;

    final directory = _waveformTempDirectory;
    _waveformTempDirectory = null;

    if (directory != null && await directory.exists()) {
      try {
        await directory.delete(recursive: true);
      } catch (error) {
        debugPrint('[CloudAudioPreview] temp cleanup failed: $error');
      }
    }
  }

  @override
  void dispose() {
    _loadRequestId += 1;
    _waveformHttpClient?.close(force: true);

    unawaited(_waveformSubscription?.cancel());
    unawaited(_positionSubscription?.cancel());
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_player.dispose());

    final directory = _waveformTempDirectory;
    if (directory != null) {
      unawaited(
        directory.exists().then((exists) async {
          if (!exists) return;
          try {
            await directory.delete(recursive: true);
          } catch (_) {}
        }),
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildBody(),
            Positioned(
              left: AppSpacing.x16,
              bottom: AppSpacing.x16 + MediaQuery.paddingOf(context).bottom,
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

class _AudioErrorView extends StatelessWidget {
  const _AudioErrorView({required this.onRetry});

  final VoidCallback onRetry;

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
            TextButton(
              onPressed: onRetry,
              child: Text(
                '다시 시도',
                style: FontStyles.med14.copyWith(
                  color: context.brands.beatOrange1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
