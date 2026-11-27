import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';

class MusicApi {
  MusicApi(this._dio);

  final Dio _dio;

  static const String _searchPath = '/musics/search';

  Future<List<MusicSearchResult>> searchMusic({
    required String query,
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _searchPath,
        queryParameters: {
          'query': query,
          'page': page,
          'limit': limit,
        },
      );

      final body = requireEtcSuccessBody(
        response: response,
        fallbackMessage: '음악 검색에 실패했습니다.',
      );

      final rawData = body['data'];
      if (rawData is! List) {
        throw const EtcApiException(message: '음악 검색 결과 형식이 올바르지 않습니다.');
      }

      return rawData
          .whereType<Map>()
          .map(
            (item) => MusicSearchResult.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw mapEtcDioException(error);
    }
  }
}
