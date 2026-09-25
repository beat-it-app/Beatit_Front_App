import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';

class LocationApi {
  LocationApi(this._dio);

  final Dio _dio;

  static const String _searchPath = '/locations/search';

  Future<List<LocationSearchResult>> searchLocations({
    required String query,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _searchPath,
        queryParameters: {
          'query': query,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      );

      final body = requireEtcSuccessBody(
        response: response,
        fallbackMessage: '장소 검색에 실패했습니다.',
      );

      final rawData = body['data'];
      if (rawData is! List) {
        throw const EtcApiException(message: '장소 검색 결과 형식이 올바르지 않습니다.');
      }

      return rawData
          .whereType<Map>()
          .map(
            (item) => LocationSearchResult.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw mapEtcDioException(error);
    }
  }
}
