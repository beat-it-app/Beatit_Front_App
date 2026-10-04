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
    this.errorMessage,
  });

  final List<MusicSearchResult> results;
  final MusicSearchResult? selectedMusic;
  final bool isLoading;
  final String? errorMessage;

  MusicSearchState copyWith({
    List<MusicSearchResult>? results,
    MusicSearchResult? selectedMusic,
    bool clearSelectedMusic = false,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MusicSearchState(
      results: results ?? this.results,
      selectedMusic: clearSelectedMusic
          ? null
          : selectedMusic ?? this.selectedMusic,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class MusicSearchNotifier extends Notifier<MusicSearchState> {
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
      clearErrorMessage: true,
      clearSelectedMusic: true,
    );

    try {
      final results = await ref.read(musicApiProvider).searchMusic(
        query: normalizedQuery,
        page: 0,
        limit: 10,
      );

      if (requestId != _requestId) {
        return;
      }

      state = state.copyWith(
        results: results,
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

  void selectMusic(MusicSearchResult music) {
    state = state.copyWith(selectedMusic: music);
  }

  void clear() {
    _requestId++;
    state = const MusicSearchState();
  }
}
