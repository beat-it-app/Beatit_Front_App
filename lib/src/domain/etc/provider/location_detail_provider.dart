import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/etc_api_provider.dart';

/// 한 번 조회한 장소 상세를 앱 실행 중 재사용합니다.
///
/// 일정 메인과 상세에서 같은 locationId를 반복 조회하지 않도록 하고,
/// 여러 일정의 장소를 미리 준비한 뒤 화면 로딩을 끝낼 수 있게 합니다.
final locationDetailCacheProvider =
    NotifierProvider<LocationDetailCacheNotifier, Map<int, LocationData>>(
      LocationDetailCacheNotifier.new,
    );

class LocationDetailCacheNotifier extends Notifier<Map<int, LocationData>> {
  final Map<int, Future<LocationData>> _inFlight =
      <int, Future<LocationData>>{};

  @override
  Map<int, LocationData> build() => const <int, LocationData>{};

  Future<LocationData> loadLocation(
    int locationId, {
    bool force = false,
  }) async {
    if (!force) {
      final cached = state[locationId];
      if (cached != null) {
        return cached;
      }

      final pending = _inFlight[locationId];
      if (pending != null) {
        return pending;
      }
    }

    final future = ref.read(locationApiProvider).getLocation(locationId);
    _inFlight[locationId] = future;

    try {
      final location = await future;

      state = <int, LocationData>{
        ...state,
        locationId: location,
      };

      return location;
    } finally {
      if (identical(_inFlight[locationId], future)) {
        _inFlight.remove(locationId);
      }
    }
  }

  Future<void> loadLocations(
    Iterable<int> locationIds, {
    bool force = false,
  }) async {
    final uniqueIds = locationIds.toSet();
    if (uniqueIds.isEmpty) {
      return;
    }

    await Future.wait(
      uniqueIds.map(
        (locationId) => loadLocation(locationId, force: force),
      ),
    );
  }

  void cacheLocation(LocationData location) {
    state = <int, LocationData>{
      ...state,
      location.locationId: location,
    };
  }

  void invalidateLocation(int locationId) {
    if (!state.containsKey(locationId)) {
      return;
    }

    final next = Map<int, LocationData>.from(state)..remove(locationId);
    state = next;
  }
}

/// 기존 호출부에서 사용할 단일 장소 Provider입니다.
/// Provider 자체가 dispose되어도 실제 장소 데이터는 위 캐시에 남아있습니다.
final locationDetailProvider = FutureProvider.autoDispose
    .family<LocationData, int>((ref, locationId) {
      final cached = ref.read(locationDetailCacheProvider)[locationId];
      if (cached != null) {
        return Future<LocationData>.value(cached);
      }

      return ref
          .read(locationDetailCacheProvider.notifier)
          .loadLocation(locationId);
    });
