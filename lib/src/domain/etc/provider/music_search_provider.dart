import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/etc_api_provider.dart';

final musicSearchProvider =
    NotifierProvider.autoDispose<MusicSearchNotifier, MusicSearchState>(
      MusicSearchNotifier.new,
    );

class MusicSearchState {
  const MusicSearchState({
    this.results = const <MusicSearchResult>[],
    this.selectedMusic,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.query = '',
    this.page = 0,
    this.errorMessage,
  });

  final List<MusicSearchResult> results;
  final MusicSearchResult? selectedMusic;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String query;
  final int page;
  final String? errorMessage;

  MusicSearchState copyWith({
    List<MusicSearchResult>? results,
    MusicSearchResult? selectedMusic,
    bool clearSelectedMusic = false,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? query,
    int? page,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MusicSearchState(
      results: results ?? this.results,
      selectedMusic: clearSelectedMusic
          ? null
          : selectedMusic ?? this.selectedMusic,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      page: page ?? this.page,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class MusicSearchNotifier extends Notifier<MusicSearchState> {
  static const int _pageSize = 10;
  int _requestId = 0;

  @override
  MusicSearchState build() => const MusicSearchState();

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      clear();
      return;
    }

    final requestId = ++_requestId;

    state = state.copyWith(
      results: const <MusicSearchResult>[],
      isLoading: true,
      isLoadingMore: false,
      hasMore: false,
      query: normalizedQuery,
      page: 0,
      clearErrorMessage: true,
      clearSelectedMusic: true,
    );

    try {
      final results = await ref.read(musicApiProvider).searchMusic(
        query: normalizedQuery,
        page: 0,
        limit: _pageSize,
      );

      if (requestId != _requestId) {
        return;
      }

      state = state.copyWith(
        results: results,
        hasMore: results.length == _pageSize,
        isLoading: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      if (requestId != _requestId) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: error is EtcApiException
            ? error.message
            : '음악 검색에 실패했습니다.',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore ||
        state.query.isEmpty) return;
    final requestId = _requestId;
    final query = state.query;
    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true, clearErrorMessage: true);
    try {
      final results = await ref.read(musicApiProvider).searchMusic(
        query: query,
        page: nextPage,
        limit: _pageSize,
      );
      if (requestId != _requestId) return;
      state = state.copyWith(
        results: [...state.results, ...results],
        page: nextPage,
        hasMore: results.length == _pageSize,
        isLoadingMore: false,
      );
    } catch (error) {
      if (requestId != _requestId) return;
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error is EtcApiException
            ? error.message : '음악 검색 결과를 더 불러오지 못했습니다.',
      );
    }
  }

  void selectMusic(MusicSearchResult music) {
    state = state.copyWith(selectedMusic: music);
  }

  void clear() {
    _requestId++;
    state = const MusicSearchState();
  }
}
