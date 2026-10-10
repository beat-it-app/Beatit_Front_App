import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/etc_api_provider.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';

final locationSearchProvider =
    NotifierProvider.autoDispose<LocationSearchNotifier, LocationSearchState>(
      LocationSearchNotifier.new,
    );

class LocationSearchState {
  const LocationSearchState({
    this.results = const <LocationSearchResult>[],
    this.referenceResults = const <LocationSearchResult>[],
    this.selectedLocation,
    this.referenceLocation,
    this.isLoading = false,
    this.isReferenceLoading = false,
    this.isLoadingMore = false,
    this.isReferenceLoadingMore = false,
    this.hasMore = false,
    this.referenceHasMore = false,
    this.page = 0,
    this.referencePage = 0,
    this.errorMessage,
    this.referenceErrorMessage,
    this.loadMoreErrorMessage,
    this.referenceLoadMoreErrorMessage,
  });

  final List<LocationSearchResult> results;
  final List<LocationSearchResult> referenceResults;
  final LocationSearchResult? selectedLocation;
  final LocationSearchResult? referenceLocation;
  final bool isLoading;
  final bool isReferenceLoading;
  final bool isLoadingMore;
  final bool isReferenceLoadingMore;
  final bool hasMore;
  final bool referenceHasMore;
  final int page;
  final int referencePage;
  final String? loadMoreErrorMessage;
  final String? referenceLoadMoreErrorMessage;
  final String? errorMessage;
  final String? referenceErrorMessage;

  LocationSearchState copyWith({
    List<LocationSearchResult>? results,
    List<LocationSearchResult>? referenceResults,
    LocationSearchResult? selectedLocation,
    bool clearSelectedLocation = false,
    LocationSearchResult? referenceLocation,
    bool clearReferenceLocation = false,
    bool? isLoading,
    bool? isReferenceLoading,
    bool? isLoadingMore,
    bool? isReferenceLoadingMore,
    bool? hasMore,
    bool? referenceHasMore,
    int? page,
    int? referencePage,
    String? loadMoreErrorMessage,
    bool clearLoadMoreErrorMessage = false,
    String? referenceLoadMoreErrorMessage,
    bool clearReferenceLoadMoreErrorMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? referenceErrorMessage,
    bool clearReferenceErrorMessage = false,
  }) {
    return LocationSearchState(
      results: results ?? this.results,
      referenceResults: referenceResults ?? this.referenceResults,
      selectedLocation: clearSelectedLocation
          ? null
          : selectedLocation ?? this.selectedLocation,
      referenceLocation: clearReferenceLocation
          ? null
          : referenceLocation ?? this.referenceLocation,
      isLoading: isLoading ?? this.isLoading,
      isReferenceLoading: isReferenceLoading ?? this.isReferenceLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isReferenceLoadingMore: isReferenceLoadingMore ?? this.isReferenceLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      referenceHasMore: referenceHasMore ?? this.referenceHasMore,
      page: page ?? this.page,
      referencePage: referencePage ?? this.referencePage,
      loadMoreErrorMessage: clearLoadMoreErrorMessage
          ? null
          : loadMoreErrorMessage ?? this.loadMoreErrorMessage,
      referenceLoadMoreErrorMessage: clearReferenceLoadMoreErrorMessage
          ? null
          : referenceLoadMoreErrorMessage ?? this.referenceLoadMoreErrorMessage,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      referenceErrorMessage: clearReferenceErrorMessage
          ? null
          : referenceErrorMessage ?? this.referenceErrorMessage,
    );
  }
}

class LocationSearchNotifier extends Notifier<LocationSearchState> {
  static const int _pageSize = 10;
  static const int _lastPage = 44; // 백엔드에서 page >= 45는 빈 목록을 반환합니다.
  int _searchRequestId = 0;
  int _referenceSearchRequestId = 0;
  String _mainQuery = '';
  String _referenceQuery = '';

  @override
  LocationSearchState build() => const LocationSearchState();

  Future<void> searchLocations(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      clearSearchResults();
      return;
    }

    final requestId = ++_searchRequestId;
    _mainQuery = normalizedQuery;
    final referenceLocation = state.referenceLocation;

    state = state.copyWith(
      results: const <LocationSearchResult>[],
      page: 0,
      hasMore: false,
      isLoading: true,
      isLoadingMore: false,
      clearErrorMessage: true,
      clearLoadMoreErrorMessage: true,
      clearSelectedLocation: true,
    );

    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: normalizedQuery,
        latitude: referenceLocation?.latitude,
        longitude: referenceLocation?.longitude,
        page: 0,
        limit: _pageSize,
      );

      if (requestId != _searchRequestId) {
        return;
      }

      state = state.copyWith(
        results: results,
        page: 0,
        hasMore: results.length == _pageSize,
        isLoading: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      if (requestId != _searchRequestId) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(error, fallback: '장소 검색에 실패했습니다.'),
      );
    }
  }

  Future<void> searchReferenceLocations(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      clearReferenceSearchResults();
      return;
    }

    final requestId = ++_referenceSearchRequestId;
    _referenceQuery = normalizedQuery;

    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      referencePage: 0,
      referenceHasMore: false,
      isReferenceLoading: true,
      isReferenceLoadingMore: false,
      clearReferenceErrorMessage: true,
      clearReferenceLoadMoreErrorMessage: true,
    );

    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: normalizedQuery,
        page: 0,
        limit: _pageSize,
      );

      if (requestId != _referenceSearchRequestId) {
        return;
      }

      state = state.copyWith(
        referenceResults: results,
        referencePage: 0,
        referenceHasMore: results.length == _pageSize,
        isReferenceLoading: false,
        clearReferenceErrorMessage: true,
      );
    } catch (error) {
      if (requestId != _referenceSearchRequestId) {
        return;
      }

      state = state.copyWith(
        isReferenceLoading: false,
        referenceErrorMessage: _getErrorMessage(
          error,
          fallback: '기준 위치 검색에 실패했습니다.',
        ),
      );
    }
  }

  /// 현재 검색어와 기준 좌표를 유지하면서 다음 페이지만 추가합니다.
  Future<void> loadMoreLocations() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore ||
        _mainQuery.isEmpty) return;

    final requestId = _searchRequestId;
    final nextPage = state.page + 1;
    final referenceLocation = state.referenceLocation;
    state = state.copyWith(
      isLoadingMore: true,
      clearLoadMoreErrorMessage: true,
    );

    try {
      final next = await ref.read(locationApiProvider).searchLocations(
        query: _mainQuery,
        latitude: referenceLocation?.latitude,
        longitude: referenceLocation?.longitude,
        page: nextPage,
        limit: _pageSize,
      );
      if (requestId != _searchRequestId) return;

      state = state.copyWith(
        results: <LocationSearchResult>[...state.results, ...next],
        page: nextPage,
        hasMore: next.length == _pageSize && nextPage < _lastPage,
        isLoadingMore: false,
      );
    } catch (error) {
      if (requestId != _searchRequestId) return;
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreErrorMessage: _getErrorMessage(error, fallback: '다음 장소를 불러오지 못했습니다.'),
      );
    }
  }

  Future<void> loadMoreReferenceLocations() async {
    if (state.isReferenceLoading || state.isReferenceLoadingMore ||
        !state.referenceHasMore || _referenceQuery.isEmpty) return;

    final requestId = _referenceSearchRequestId;
    final nextPage = state.referencePage + 1;
    state = state.copyWith(
      isReferenceLoadingMore: true,
      clearReferenceLoadMoreErrorMessage: true,
    );

    try {
      final next = await ref.read(locationApiProvider).searchLocations(
        query: _referenceQuery,
        page: nextPage,
        limit: _pageSize,
      );
      if (requestId != _referenceSearchRequestId) return;

      state = state.copyWith(
        referenceResults: <LocationSearchResult>[
          ...state.referenceResults,
          ...next,
        ],
        referencePage: nextPage,
        referenceHasMore: next.length == _pageSize && nextPage < _lastPage,
        isReferenceLoadingMore: false,
      );
    } catch (error) {
      if (requestId != _referenceSearchRequestId) return;
      state = state.copyWith(
        isReferenceLoadingMore: false,
        referenceLoadMoreErrorMessage: _getErrorMessage(
          error,
          fallback: '다음 기준 위치를 불러오지 못했습니다.',
        ),
      );
    }
  }

  void selectLocation(LocationSearchResult location) {
    state = state.copyWith(selectedLocation: location);
  }

  Future<LocationData> registerLocation(LocationSearchResult location) async {
    final registered = await ref.read(locationApiProvider).createLocation(location);
    ref.read(locationDetailCacheProvider.notifier).cacheLocation(registered);
    return registered;
  }

  void selectReferenceLocation(LocationSearchResult location) {
    _referenceSearchRequestId++;
    _referenceQuery = '';
    state = state.copyWith(
      referenceLocation: location,
      referenceResults: const <LocationSearchResult>[],
      referencePage: 0,
      referenceHasMore: false,
      isReferenceLoading: false,
      isReferenceLoadingMore: false,
      clearReferenceErrorMessage: true,
      clearReferenceLoadMoreErrorMessage: true,
    );
  }

  void clearSearchResults() {
    _searchRequestId++;
    _mainQuery = '';
    state = state.copyWith(
      results: const <LocationSearchResult>[],
      page: 0,
      hasMore: false,
      isLoading: false,
      isLoadingMore: false,
      clearErrorMessage: true,
      clearLoadMoreErrorMessage: true,
      clearSelectedLocation: true,
    );
  }

  void clearReferenceSearchResults() {
    _referenceSearchRequestId++;
    _referenceQuery = '';
    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      referencePage: 0,
      referenceHasMore: false,
      isReferenceLoading: false,
      isReferenceLoadingMore: false,
      clearReferenceErrorMessage: true,
      clearReferenceLoadMoreErrorMessage: true,
    );
  }

  void clearReferenceLocation() {
    _referenceSearchRequestId++;
    _referenceQuery = '';
    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      referencePage: 0,
      referenceHasMore: false,
      isReferenceLoading: false,
      isReferenceLoadingMore: false,
      clearReferenceLocation: true,
      clearReferenceErrorMessage: true,
      clearReferenceLoadMoreErrorMessage: true,
    );
  }

  String _getErrorMessage(Object error, {required String fallback}) {
    if (error is EtcApiException) {
      return error.message;
    }

    return fallback;
  }
}
