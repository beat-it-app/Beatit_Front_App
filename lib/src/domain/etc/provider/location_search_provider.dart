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
    this.errorMessage,
    this.referenceErrorMessage,
  });

  final List<LocationSearchResult> results;
  final List<LocationSearchResult> referenceResults;
  final LocationSearchResult? selectedLocation;
  final LocationSearchResult? referenceLocation;
  final bool isLoading;
  final bool isReferenceLoading;
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
      clearErrorMessage: true,
      clearSelectedLocation: true,
    );

    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: normalizedQuery,
        latitude: referenceLocation?.latitude,
        longitude: referenceLocation?.longitude,
      );

      if (requestId != _searchRequestId) {
        return;
      }

      state = state.copyWith(
        results: results,
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
      clearReferenceErrorMessage: true,
    );

    try {
      final results = await ref.read(locationApiProvider).searchLocations(
        query: normalizedQuery,
      );

      if (requestId != _referenceSearchRequestId) {
        return;
      }

      state = state.copyWith(
        referenceResults: results,
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
      clearReferenceErrorMessage: true,
    );
  }

  void clearSearchResults() {
    _searchRequestId++;
    state = state.copyWith(
      results: const <LocationSearchResult>[],
      isLoading: false,
      clearErrorMessage: true,
      clearSelectedLocation: true,
    );
  }

  void clearReferenceSearchResults() {
    _referenceSearchRequestId++;
    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      isReferenceLoading: false,
      clearReferenceErrorMessage: true,
    );
  }

  void clearReferenceLocation() {
    _referenceSearchRequestId++;
    state = state.copyWith(
      referenceResults: const <LocationSearchResult>[],
      isReferenceLoading: false,
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
