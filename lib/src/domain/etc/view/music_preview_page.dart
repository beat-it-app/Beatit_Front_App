import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/widget/music_preview_waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';

enum _MusicPreviewLoadState { loading, ready, error }

class MusicPreviewPage extends StatefulWidget {
  const MusicPreviewPage({
    super.key,
    required this.musicTitle,
    required this.artist,
    required this.imageUrl,
    required this.previewUrl,
    this.requestHeaders,
  });

  final String musicTitle;
  final String artist;
  final String imageUrl;
  final String previewUrl;
  final Map<String, String>? requestHeaders;

  @override
  State<MusicPreviewPage> createState() => _MusicPreviewPageState();
}

class _MusicPreviewPageState extends State<MusicPreviewPage> {
  static const Duration _maxPreviewDuration = Duration(seconds: 30);

  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<WaveformProgress>? _waveformSubscription;

  HttpClient? _waveformHttpClient;
  Directory? _waveformTempDirectory;

  _MusicPreviewLoadState _loadState = _MusicPreviewLoadState.loading;
  Duration _previewDuration = _maxPreviewDuration;
  Duration _position = Duration.zero;
  Waveform? _waveform;
  double _waveformProgress = 0.0;
  bool _isPlaying = false;
  int _loadRequestId = 0;

  Duration get _initialPosition => Duration.zero;

  @override
  void initState() {
    super.initState();
    _bindPlayerStreams();
    unawaited(_loadPreview());
  }

  void _bindPlayerStreams() {
    _positionSubscription = _player.positionStream.listen((position) {
      if (!mounted) return;

      final nextPosition = _clampDuration(
        position,
        Duration.zero,
        _previewDuration,
      );

      setState(() {
        _position = nextPosition;
      });
    });

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying =
            state.playing && state.processingState != ProcessingState.completed;

        if (state.processingState == ProcessingState.completed) {
          _position = _previewDuration;
        }
      });
    });
  }

  Future<void> _loadPreview() async {
    final requestId = ++_loadRequestId;

    await _cancelWaveformWork();
    await _player.stop();

    if (!mounted || requestId != _loadRequestId) return;

    setState(() {
      _loadState = _MusicPreviewLoadState.loading;
      _previewDuration = _maxPreviewDuration;
      _position = Duration.zero;
      _waveform = null;
      _waveformProgress = 0.0;
      _isPlaying = false;
    });

    final previewUri = Uri.tryParse(widget.previewUrl);
    if (previewUri == null || previewUri.scheme.isEmpty) {
      _setLoadError(requestId);
      return;
    }

    try {
      final sourceDuration = previewUri.scheme == 'file'
          ? await _player.setFilePath(previewUri.toFilePath())
          : await _player.setUrl(
              previewUri.toString(),
              headers: widget.requestHeaders,
            );

      if (!mounted || requestId != _loadRequestId) return;

      final resolvedDuration = sourceDuration ?? _player.duration;
      if (resolvedDuration == null || resolvedDuration <= Duration.zero) {
        _setLoadError(requestId);
        return;
      }

      final previewDuration = resolvedDuration < _maxPreviewDuration
          ? resolvedDuration
          : _maxPreviewDuration;

      await _player.setClip(start: Duration.zero, end: previewDuration);

      const initialPosition = Duration.zero;
      await _player.seek(initialPosition);

      if (!mounted || requestId != _loadRequestId) return;

      setState(() {
        _previewDuration = previewDuration;
        _position = initialPosition;
        _loadState = _MusicPreviewLoadState.ready;
      });

      unawaited(_prepareWaveform(previewUri, requestId));
    } catch (error, stackTrace) {
      debugPrint('[MusicPreviewPage] audio load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _setLoadError(requestId);
    }
  }

  void _setLoadError(int requestId) {
    if (!mounted || requestId != _loadRequestId) return;

    setState(() {
      _loadState = _MusicPreviewLoadState.error;
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
              debugPrint('[MusicPreviewPage] waveform extract failed: $error');
              debugPrintStack(stackTrace: stackTrace);

              if (!mounted || requestId != _loadRequestId) return;
              setState(() => _waveformProgress = 1.0);
            },
          );
    } catch (error, stackTrace) {
      debugPrint('[MusicPreviewPage] waveform prepare failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || requestId != _loadRequestId) return;
      setState(() => _waveformProgress = 1.0);
    }
  }

  Future<File?> _waveformInputFile(Uri uri, int requestId) async {
    if (uri.scheme == 'file') {
      final directory = await Directory.systemTemp.createTemp(
        'beatit_music_preview_waveform_',
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
      'beatit_music_preview_waveform_',
    );

    if (requestId != _loadRequestId) {
      await directory.delete(recursive: true);
      return null;
    }

    _waveformTempDirectory = directory;
    final audioFile = File(
      '${directory.path}/preview${_fileExtension(uri.path)}',
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
          'Music preview download failed: ${response.statusCode}',
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
    if (_loadState != _MusicPreviewLoadState.ready ||
        _previewDuration <= Duration.zero) {
      return;
    }

    if (_player.playing) {
      await _player.pause();
      return;
    }

    if (_position >= _previewDuration) {
      await _player.seek(_initialPosition);
    }

    unawaited(_player.play());
  }

  Future<void> _seek(Duration target) async {
    if (_loadState != _MusicPreviewLoadState.ready) return;

    final clamped = _clampDuration(target, Duration.zero, _previewDuration);

    setState(() {
      _position = clamped;
    });

    await _player.seek(clamped);
  }

  Duration _clampDuration(Duration value, Duration minimum, Duration maximum) {
    if (value < minimum) return minimum;
    if (value > maximum) return maximum;
    return value;
  }

  String _formatDuration(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildPlayerBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.x24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max(0.0, constraints.maxHeight - AppSpacing.x24),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.x40,
                      AppSpacing.x40,
                      AppSpacing.x40,
                      AppSpacing.x24,
                    ),
                    child: _buildArtwork(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.musicTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: FontStyles.semi18.copyWith(
                            color: context.grays.black,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Text(
                          widget.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: FontStyles.med16.copyWith(
                            color: context.grays.gray5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x24),
                  _buildPlayButton(context),
                  const SizedBox(height: AppSpacing.x20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: FontStyles.med16.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                            Text(
                              _formatDuration(_previewDuration),
                              style: FontStyles.med16.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        MusicPreviewWaveform(
                          waveform: _waveform,
                          duration: _previewDuration,
                          position: _position,
                          loadingProgress: _waveformProgress,
                          onSeek: (position) => unawaited(_seek(position)),
                        ),
                      ],
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

  Widget _buildArtwork(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: context.grays.gray7,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.music_note,
                    size: 48.0,
                    color: context.grays.gray5,
                  ),
                );
              },
            ),
            ColoredBox(color: context.grays.black.withValues(alpha: 0.40)),
            Center(
              child: Text(
                '30초 미리듣기',
                style: FontStyles.med16.copyWith(color: context.grays.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    final enabled = _loadState == _MusicPreviewLoadState.ready;

    return Semantics(
      button: true,
      enabled: enabled,
      label: _isPlaying ? '음원 일시정지' : '음원 재생',
      child: Material(
        color: context.grays.white,
        elevation: 4.0,
        shadowColor: context.grays.black.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: context.grays.gray7, width: 1.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? () => unawaited(_togglePlayPause()) : null,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: SizedBox(
            width: 70.0,
            height: 60.0,
            child: _loadState == _MusicPreviewLoadState.loading
                ? Center(
                    child: SizedBox(
                      width: 27.0,
                      height: 27.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: context.grays.gray3,
                      ),
                    ),
                  )
                : Center(
                    child: SvgPicture.asset(
                      _isPlaying
                          ? 'assets/icons/cloud/pause.svg'
                          : 'assets/icons/cloud/play.svg',
                      width: 25.0,
                      height: 25.0,
                      colorFilter: ColorFilter.mode(
                        enabled ? context.grays.gray1 : context.grays.gray6,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '미리듣기를 불러오지 못했습니다.',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(color: context.grays.gray2),
            ),
            const SizedBox(height: AppSpacing.x16),
            TextButton(
              onPressed: () => unawaited(_loadPreview()),
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
        debugPrint('[MusicPreviewPage] temp cleanup failed: $error');
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
      appBar: _MusicPreviewAppBar(titleText: widget.musicTitle),
      body: _MusicPreviewBackground(
        child: _loadState == _MusicPreviewLoadState.error
            ? _buildErrorBody(context)
            : _buildPlayerBody(context),
      ),
    );
  }
}

class _MusicPreviewBackground extends StatelessWidget {
  const _MusicPreviewBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            context.grays.white,
            context.grays.white,
            context.grays.gray7,
          ],
        ),
      ),
      child: child,
    );
  }
}

class _MusicPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _MusicPreviewAppBar({required this.titleText});

  final String titleText;

  @override
  Size get preferredSize => const Size.fromHeight(62.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: context.grays.white,
      surfaceTintColor: context.grays.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: _MusicBackButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Text(
                  titleText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: FontStyles.semi18.copyWith(color: context.grays.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicBackButton extends StatefulWidget {
  const _MusicBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_MusicBackButton> createState() => _MusicBackButtonState();
}

class _MusicBackButtonState extends State<_MusicBackButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '뒤로가기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: SizedBox(
          width: 60.0,
          height: 60.0,
          child: Center(
            child: AnimatedScale(
              scale: _isPressed ? 0.86 : 1.0,
              duration: _isPressed
                  ? const Duration(milliseconds: 200)
                  : const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              child: SvgPicture.asset(
                'assets/icons/appbar/back.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(
                  context.grays.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
