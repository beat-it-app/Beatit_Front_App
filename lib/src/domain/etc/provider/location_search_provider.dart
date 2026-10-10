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
    this.query = '',
    this.referenceQuery = '',
    this.page = 0,
    this.referencePage = 0,
    this.errorMessage,
    this.referenceErrorMessage,
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
  final String query;
  final String referenceQuery;
  final int page;
  final int referencePage;
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
    String? query,
    String? referenceQuery,
    int? page,
    int? referencePage,
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
      query: query ?? this.query,
      referenceQuery: referenceQuery ?? this.referenceQuery,
      page: page ?? this.page,
      referencePage: referencePage ?? this.referencePage,
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
  static const int _pageSize = 15;
  int _searchRequestId = 0;
  int _referenceSearchRequestId = 0;

  @override
  LocationSearchState build() => const LocationSearchState();

  Future<void> searchLocations(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      clearSearchResults();
      return;
    }

    final requestId = ++_searchRequestId;
    final referenceLocation = state.referenceLocation;

    state = state.copyWith(
      results: const <LocationSearchResult>[],
      isLoading: true,
      isLoadingMore: false,
      hasMore: false,
      query: normalizedQuery,
      page: 0,
      clearErrorMessage: true,
      clearSelectedLocation: true,
    );

    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: normalizedQuery,
        page: 0,
        latitude: referenceLocation?.latitude,
        longitude: referenceLocation?.longitude,
      );

      if (requestId != _searchRequestId) {
        return;
      }

      state = state.copyWith(
        results: results,
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

    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      isReferenceLoading: true,
      isReferenceLoadingMore: false,
      referenceHasMore: false,
      referenceQuery: normalizedQuery,
      referencePage: 0,
      clearReferenceErrorMessage: true,
    );

    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: normalizedQuery,
        page: 0,
      );

      if (requestId != _referenceSearchRequestId) {
        return;
      }

      state = state.copyWith(
        referenceResults: results,
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

  Future<void> loadMoreLocations() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore ||
        state.query.isEmpty || state.page >= 44) return;
    final requestId = _searchRequestId;
    final nextPage = state.page + 1;
    final reference = state.referenceLocation;
    state = state.copyWith(isLoadingMore: true, clearErrorMessage: true);
    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: state.query,
        page: nextPage,
        latitude: reference?.latitude,
        longitude: reference?.longitude,
      );
      if (requestId != _searchRequestId) return;
      state = state.copyWith(
        results: [...state.results, ...results],
        page: nextPage,
        hasMore: results.length == _pageSize && nextPage < 44,
        isLoadingMore: false,
      );
    } catch (error) {
      if (requestId != _searchRequestId) return;
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: _getErrorMessage(error, fallback: '추가 장소 검색에 실패했습니다.'),
      );
    }
  }

  Future<void> loadMoreReferenceLocations() async {
    if (state.isReferenceLoading || state.isReferenceLoadingMore ||
        !state.referenceHasMore || state.referenceQuery.isEmpty ||
        state.referencePage >= 44) return;
    final requestId = _referenceSearchRequestId;
    final nextPage = state.referencePage + 1;
    state = state.copyWith(isReferenceLoadingMore: true,
        clearReferenceErrorMessage: true);
    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: state.referenceQuery,
        page: nextPage,
      );
      if (requestId != _referenceSearchRequestId) return;
      state = state.copyWith(
        referenceResults: [...state.referenceResults, ...results],
        referencePage: nextPage,
        referenceHasMore: results.length == _pageSize && nextPage < 44,
        isReferenceLoadingMore: false,
      );
    } catch (error) {
      if (requestId != _referenceSearchRequestId) return;
      state = state.copyWith(
        isReferenceLoadingMore: false,
        referenceErrorMessage: _getErrorMessage(error, fallback: '추가 기준 위치 검색에 실패했습니다.'),
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
    state = state.copyWith(
      referenceLocation: location,
      referenceResults: const <LocationSearchResult>[],
      isReferenceLoading: false,
      isReferenceLoadingMore: false,
      referenceHasMore: false,
      referenceQuery: '',
      referencePage: 0,
      clearReferenceErrorMessage: true,
    );
  }

  void clearSearchResults() {
    _searchRequestId++;
    state = state.copyWith(
      results: const <LocationSearchResult>[],
      isLoading: false,
      isLoadingMore: false,
      hasMore: false,
      query: '',
      page: 0,
      clearErrorMessage: true,
      clearSelectedLocation: true,
    );
  }

  void clearReferenceSearchResults() {
    _referenceSearchRequestId++;
    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      isReferenceLoading: false,
      isReferenceLoadingMore: false,
      referenceHasMore: false,
      referenceQuery: '',
      referencePage: 0,
      clearReferenceErrorMessage: true,
    );
  }

  void clearReferenceLocation() {
    _referenceSearchRequestId++;
    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      isReferenceLoading: false,
      isReferenceLoadingMore: false,
      referenceHasMore: false,
      referenceQuery: '',
      referencePage: 0,
      clearReferenceLocation: true,
      clearReferenceErrorMessage: true,
    );
  }

  String _getErrorMessage(Object error, {required String fallback}) {
    if (error is EtcApiException) {
      return error.message;
    }

    return fallback;
  }
}
