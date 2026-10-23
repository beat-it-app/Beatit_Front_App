import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/music_search_provider.dart';
import 'package:beatit_front_app/src/domain/etc/widget/music_result_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_pagination_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class MusicSearchPage extends ConsumerStatefulWidget {
  const MusicSearchPage({super.key, this.returnOnSelect = false});

  /// 일정 생성처럼 한 곡을 누르는 즉시 선택 결과를 이전 화면에 반환할 때 사용한다.
  final bool returnOnSelect;

  @override
  ConsumerState<MusicSearchPage> createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends ConsumerState<MusicSearchPage> {
  static const Duration _previewLimit = Duration(seconds: 30);
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  MusicSearchResult? _activeMusic;
  bool _isPlaying = false;
  bool _isLoadingPreview = false;
  int _previewRequestId = 0;

  @override
  void initState() {
    super.initState();
    _positionSubscription = _player.positionStream.listen((position) {
      if (position >= _previewLimit && _activeMusic != null) {
        unawaited(_stopPreview());
      }
    });
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted || _activeMusic == null) return;
      if (state.processingState == ProcessingState.completed) {
        unawaited(_stopPreview());
        return;
      }
      final playing =
          state.playing && state.processingState == ProcessingState.ready;
      if (_isPlaying != playing) {
        setState(() => _isPlaying = playing);
      }
    });
  }

  @override
  void dispose() {
    ++_previewRequestId;
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _player.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _stopPreview() async {
    ++_previewRequestId;
    if (mounted) {
      setState(() {
        _activeMusic = null;
        _isPlaying = false;
        _isLoadingPreview = false;
      });
    }
    try {
      await _player.stop();
    } catch (error) {
      debugPrint('[MusicSearchPage] preview stop failed: $error');
    }
  }

  Future<void> _togglePreview(MusicSearchResult music) async {
    if (identical(_activeMusic, music)) {
      if (_isLoadingPreview) {
        await _stopPreview();
      } else if (_isPlaying) {
        await _player.pause();
      } else {
        // 일시정지한 음악은 0초로 돌아가지 않고 이어서 재생합니다.
        unawaited(_player.play());
      }
      return;
    }

    final url = music.previewUrl?.trim();
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showPreviewMessage('미리듣기 음원이 없습니다.');
      return;
    }

    final requestId = ++_previewRequestId;
    setState(() {
      _activeMusic = music;
      _isPlaying = false;
      _isLoadingPreview = true;
    });

    try {
      await _player.stop();
      if (!mounted || requestId != _previewRequestId) return;
      await _player.setUrl(url!);
      if (!mounted || requestId != _previewRequestId) return;
      await _player.seek(Duration.zero);
      if (!mounted || requestId != _previewRequestId) return;
      setState(() => _isLoadingPreview = false);
      unawaited(_player.play());
    } catch (error, stackTrace) {
      debugPrint('[MusicSearchPage] preview load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted || requestId != _previewRequestId) return;
      setState(() {
        _activeMusic = null;
        _isPlaying = false;
        _isLoadingPreview = false;
      });
      _showPreviewMessage('미리듣기 음원을 불러오지 못했습니다.');
    }
  }

  void _showPreviewMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleSearch() async {
    FocusScope.of(context).unfocus();
    await _stopPreview();
    if (!mounted) return;
    await ref.read(musicSearchProvider.notifier).search(_searchController.text);
  }

  void _handleSearchChanged(String value) {
    if (value.trim() != ref.read(musicSearchProvider).query) {
      unawaited(_stopPreview());
      ref.read(musicSearchProvider.notifier).clear();
    }
  }

  Future<void> _handleMusicSelected(MusicSearchResult music) async {
    // 선택 시 재생을 멈추고 기존 반환 동작(일정/투표)을 그대로 수행합니다.
    await _stopPreview();
    if (!mounted) return;
    ref.read(musicSearchProvider.notifier).selectMusic(music);

    if (widget.returnOnSelect) {
      Navigator.of(context).pop<MusicSearchResult>(music);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(musicSearchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: Row(
                children: [
                  Expanded(
                    child: SearchInputWidget(
                      controller: _searchController,
                      onSearchPressed: _handleSearch,
                      onChanged: _handleSearchChanged,
                      hintText: '어떤 음원을 선택하고 싶나요?',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Semantics(
                    button: true,
                    label: '이전 화면으로 이동',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).maybePop(),
                      child: SizedBox(
                        width: 32,
                        height: 54,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/etc/delete.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              context.grays.gray1,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Expanded(child: _buildSearchContent(searchState)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent(MusicSearchState searchState) {
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.errorMessage != null) {
      return Center(
        child: Text(
          searchState.errorMessage!,
          textAlign: TextAlign.center,
          style: FontStyles.med14.copyWith(color: context.grays.gray5),
        ),
      );
    }

    if (searchState.results.isEmpty) {
      return searchState.query.isEmpty
          ? const SizedBox.shrink()
          : Center(
              child: Text(
                '검색 결과가 없습니다.',
                style: FontStyles.med14.copyWith(color: context.grays.gray5),
              ),
            );
    }

    return SearchPaginationListener(
      canLoadMore:
          searchState.hasMore &&
          !searchState.isLoadingMore &&
          searchState.loadMoreErrorMessage == null,
      onLoadMore: () {
        if (mounted) {
          ref.read(musicSearchProvider.notifier).loadMore();
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            searchState.results.length +
            (searchState.isLoadingMore ||
                    searchState.loadMoreErrorMessage != null
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index == searchState.results.length) {
            if (searchState.loadMoreErrorMessage != null) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.x16),
                child: Center(
                  child: TextButton(
                    onPressed: () =>
                        ref.read(musicSearchProvider.notifier).loadMore(),
                    child: const Text('음악을 불러오지 못했습니다. 다시 시도'),
                  ),
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.x16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final music = searchState.results[index];
          return MusicResultWidget(
            musicTitle: music.title,
            artist: music.artist,
            imageUrl: music.imageUrl ?? '',
            isSelected: identical(searchState.selectedMusic, music),
            isPlaying: identical(_activeMusic, music) && _isPlaying,
            onTap: () => unawaited(_togglePreview(music)),
            onAddPressed: () => unawaited(_handleMusicSelected(music)),
          );
        },
      ),
    );
  }
}
