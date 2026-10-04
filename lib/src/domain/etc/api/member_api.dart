import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/etc/api/etc_api_exception.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';

class MemberApi {
  MemberApi(this._dio);

  final Dio _dio;

  static const String _membersPath = '/teams/members';

  Future<TeamMemberListData> getMembers({
    String? query,
    int page = 0,
    int size = 100,
  }) async {
    try {
      final normalizedQuery = query?.trim();
      final response = await _dio.get<Map<String, dynamic>>(
        _membersPath,
        queryParameters: {
          if (normalizedQuery != null && normalizedQuery.isNotEmpty)
            'query': normalizedQuery,
          'page': page,
          'size': size,
        },
      );

      final body = requireEtcSuccessBody(
        response: response,
        fallbackMessage: '팀 멤버 목록을 불러오지 못했습니다.',
      );

      final rawData = body['data'];
      if (rawData is! Map) {
        throw const EtcApiException(message: '팀 멤버 목록 형식이 올바르지 않습니다.');
      }

      return TeamMemberListData.fromJson(Map<String, dynamic>.from(rawData));
    } on DioException catch (error) {
      throw mapEtcDioException(error);
    }
  }
}
