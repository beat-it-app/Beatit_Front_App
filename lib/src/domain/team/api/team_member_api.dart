import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/team_member_model.dart';
import '../model/team_member_position_model.dart';

class TeamMemberApiException implements Exception {
  final String message;
  final String? code;

  TeamMemberApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class TeamMemberApi {
  final Dio _dio;

  TeamMemberApi(this._dio);

  // API 메서드 수정 (Record/튜플 반환 방식)
  Future<({String? myRole, List<TeamMemberModel> members})> getTeamMembers({
    String? query,
  }) async {
    try {
      final response = await _dio.get(
        '/teams/members',
        queryParameters: query != null && query.isNotEmpty
            ? {'query': query}
            : null,
      );

      final data = response.data;
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        final innerData = data['data'];
        final myRole = innerData['myRole'] as String?;

        final membersList = (innerData['members'] as List? ?? [])
            .map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return (myRole: myRole, members: membersList);
      }

      throw TeamMemberApiException('응답 데이터 형식이 올바르지 않습니다.');
    } on DioException catch (e) {
      // 기존 에러 처리 유지
      final data = e.response?.data;
      throw TeamMemberApiException(
        data?['message'] ?? '멤버 목록을 불러오지 못했습니다.',
        code: data?['code']?.toString(),
      );
    }
  }

  // 2. 운영진 / 대표 권한 수정: POST /teams/members/{userPublicId}
  Future<List<TeamMemberModel>> updateMemberRole({
    required String userPublicId,
    required String targetRole, // 'LEADER' | 'MANAGER' | 'MEMBER'
  }) async {
    try {
      final response = await _dio.post(
        '/teams/members/$userPublicId',
        data: {'targetRole': targetRole},
      );

      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        final data = resData['data'];
        if (data is Map<String, dynamic> && data['updatedMembers'] is List) {
          final list = data['updatedMembers'] as List<dynamic>;
          return list
              .map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is TeamMemberApiException) rethrow;
      throw TeamMemberApiException('네트워크 오류가 발생했습니다.');
    }
  }

  /// 3. 팀 멤버 포지션 목록 조회: GET /teams/members/position
  Future<List<TeamMemberPositionModel>> getMemberPositions() async {
    try {
      final response = await _dio.get('/teams/members/position');
      final resData = response.data;

      if (resData is Map<String, dynamic>) {
        final data = resData['data'];
        if (data is Map<String, dynamic> && data['members'] is List) {
          final list = data['members'] as List<dynamic>;
          return list
              .map(
                (e) =>
                    TeamMemberPositionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is TeamMemberApiException) rethrow;
      throw TeamMemberApiException('포지션 목록 조회 중 네트워크 오류가 발생했습니다.');
    }
  }

  // 4. 팀 멤버 포지션 일괄 수정: PATCH /teams/members/position
  Future<List<TeamMemberPositionModel>> updateMemberPositions(
    List<Map<String, dynamic>> positions,
  ) async {
    try {
      final response = await _dio.patch(
        '/teams/members/position',
        data: {'positions': positions},
      );

      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        final data = resData['data'];
        if (data is Map<String, dynamic> && data['members'] is List) {
          final list = data['members'] as List<dynamic>;
          return list
              .map(
                (e) =>
                    TeamMemberPositionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e is TeamMemberApiException) rethrow;
      throw TeamMemberApiException('포지션 변경 중 네트워크 오류가 발생했습니다.');
    }
  }
}

// 💡 백엔드 에러 코드 분기 처리 헬퍼 함수
Never _handleDioError(DioException e) {
  final data = e.response?.data;
  String? errorCode;
  String message = '요청 처리에 실패했습니다.';

  if (data is Map<String, dynamic>) {
    errorCode = data['code'] ?? data['errorCode'] ?? data['status']?.toString();
    message = data['message'] ?? message;
  }

  switch (errorCode) {
    case 'TEAM-001':
      message = '팀에 대해 변경할 내용이 없습니다.';
      break;
    case 'TEAM-012':
      message = '현재 선택된 팀이 없습니다. 팀을 먼저 선택해주세요.';
      break;
    case 'COMMON-002':
      message = '로그인이 필요한 서비스입니다.';
      break;
    case 'TEAM-006':
      message = '팀 수정 권한이 없습니다.';
      break;
    case 'TEAM-011':
      message = '해당 팀의 멤버가 아닙니다.';
      break;
    case 'TEAM-015':
      message = '포지션은 10자 이하여야 합니다.';
      break;
    case 'COMMON-005':
      message = '해당 유저를 찾을 수 없습니다.';
      break;
    case 'COMMON-004':
      message = '서버 내부 오류가 발생했습니다.';
      break;
    default:
      if (e.response?.statusCode == 500) {
        message = '서버 내부 오류가 발생했습니다.';
      }
      break;
  }

  throw TeamMemberApiException(message, code: errorCode);
}

final teamMemberApiProvider = Provider<TeamMemberApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamMemberApi(dio);
});
