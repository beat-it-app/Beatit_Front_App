import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/music/music_preview_list_item.dart';
import 'package:beatit_front_app/src/domain/etc/widget/location_result_widget.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// CalDetailPage와 같은 just_audio 재생 정책(30초, 재탭 정지, 요청 취소)을 사용한다.
class PollOptionsPreviewSheet extends StatefulWidget {
  const PollOptionsPreviewSheet({
    super.key,
    required this.items,
    required this.isMusic,
    required this.onLocationTap,
  });

  final List<PollDetailItem> items;
  final bool isMusic;
  final ValueChanged<int> onLocationTap;

  @override
  State<PollOptionsPreviewSheet> createState() =>
      _PollOptionsPreviewSheetState();
}

class _PollOptionsPreviewSheetState extends State<PollOptionsPreviewSheet> {
  static const Duration _previewLimit = Duration(seconds: 30);
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  int? _activeItemId;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isStopping = false;
  int _loadRequestId = 0;

  @override
  void initState() {
    super.initState();
    _positionSubscription = _player.positionStream.listen((position) {
      if (!mounted || _activeItemId == null || _isStopping) return;
      if (position >= _previewLimit) unawaited(_stopPreview());
    });
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted || _activeItemId == null || _isStopping) return;
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _activeItemId = null;
          _isPlaying = false;
          _isLoading = false;
        });
        return;
      }
      final buffering =
          state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
      final playing =
          state.playing && state.processingState == ProcessingState.ready;
      if (_isLoading != buffering || _isPlaying != playing) {
        setState(() {
          _isLoading = buffering;
          _isPlaying = playing;
        });
      }
    });
  }

  Future<void> _handleMusicTap(PollDetailItem item) async {
    if (_activeItemId == item.itemId) {
      await _stopPreview();
      return;
    }
    final url = item.previewUrl?.trim();
    if (url == null || url.isEmpty) {
      _showMessage('미리듣기 음원이 없습니다.');
      return;
    }
    final requestId = ++_loadRequestId;
    setState(() {
      _activeItemId = item.itemId;
      _isPlaying = false;
      _isLoading = true;
    });
    try {
      await _player.stop();
      if (!mounted || requestId != _loadRequestId) return;
      await _player.setUrl(url);
      if (!mounted || requestId != _loadRequestId) return;
      await _player.seek(Duration.zero);
      if (!mounted || requestId != _loadRequestId) return;
      setState(() => _isLoading = false);
      unawaited(_player.play());
    } catch (error, stackTrace) {
      debugPrint('[PollOptionsPreviewSheet] music preview failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted || requestId != _loadRequestId) return;
      setState(() {
        _activeItemId = null;
        _isPlaying = false;
        _isLoading = false;
      });
      _showMessage('미리듣기 음원을 불러오지 못했습니다.');
    }
  }

  Future<void> _stopPreview() async {
    if (_isStopping) return;
    _isStopping = true;
    ++_loadRequestId;
    try {
      await _player.stop();
    } finally {
      if (mounted) {
        setState(() {
          _activeItemId = null;
          _isPlaying = false;
          _isLoading = false;
        });
      }
      _isStopping = false;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    ++_loadRequestId;
    unawaited(_positionSubscription?.cancel());
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.58,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x20),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      widget.isMusic ? '음악 미리듣기' : '장소 미리보기',
                      textAlign: TextAlign.center,
                      style: FontStyles.bold20.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  itemCount: widget.items.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: context.grays.gray7, height: 1),
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    if (!widget.isMusic) {
                      return LocationResultWidget(
                        name: item.locationName ?? item.location ?? '장소',
                        address: item.roadAddress ?? '',
                        onTap: item.locationId == null
                            ? null
                            : () => widget.onLocationTap(item.locationId!),
                      );
                    }
                    final active = _activeItemId == item.itemId;
                    return MusicPreviewListItem(
                      trackText: item.title ?? '제목 없음',
                      artistText: item.artist ?? '아티스트 정보 없음',
                      isPlaying: active && _isPlaying,
                      isLoading: active && _isLoading,
                      onTap: () => unawaited(_handleMusicTap(item)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
