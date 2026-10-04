import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/my_team_model.dart';

class TeamSelectApiException implements Exception {
  final String message;
  final String? code;

  TeamSelectApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class TeamSelectApi {
  final Dio _dio;

  TeamSelectApi(this._dio);

  /// 내 팀 목록 조회 API (GET /teams/me)
  Future<MyTeamResponse> getMyTeams() async {
    try {
      final response = await _dio.get('/teams/me');

      if (response.data is Map<String, dynamic>) {
        return MyTeamResponse.fromJson(response.data as Map<String, dynamic>);
      }
      throw TeamSelectApiException('응답 형식이 올바르지 않습니다.');
    } on DioException catch (e) {
      String message = '팀 목록을 불러오는데 실패했습니다.';
      String? errorCode;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorCode =
            data['status']?.toString() ?? data['errorCode'] ?? data['code'];
        switch (errorCode) {
          case 'COMMON-002':
            message = '로그인이 필요한 서비스입니다.';
            break;
          case 'COMMON-004':
            message = '서버 내부 오류가 발생했습니다.';
            break;
          case 'COMMON-005':
            message = '해당 유저를 찾을 수 없습니다.';
            break;
          default:
            message = data['message'] ?? message;
        }
      }
      throw TeamSelectApiException(message, code: errorCode);
    } catch (e) {
      if (e is TeamSelectApiException) rethrow;
      throw TeamSelectApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }

  /// 팀 선택(활성화) API: POST /teams/select/{teamPublicId}
  Future<void> selectTeam(String teamPublicId) async {
    try {
      final response = await _dio.post('/teams/select/$teamPublicId');
      final data = response.data;

      if (data is Map<String, dynamic> && data['success'] == false) {
        throw TeamSelectApiException(data['message'] ?? '팀 선택에 실패했습니다.');
      }
    } on DioException catch (e) {
      String message = '팀 선택에 실패했습니다.';
      String? errorCode;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorCode =
            data['status']?.toString() ?? data['errorCode'] ?? data['code'];
        switch (errorCode) {
          case 'COMMON-002':
            message = '로그인이 필요한 서비스입니다.';
            break;
          case 'TEAM-011':
            message = '해당 팀의 멤버가 아닙니다.';
            break;
          case 'TEAM-002':
            message = '이미 삭제되었거나 존재하지 않는 팀입니다.';
            break;
          case 'COMMON-005':
            message = '해당 유저를 찾을 수 없습니다.';
            break;
          case 'COMMON-004':
            message = '서버 내부 오류가 발생했습니다.';
            break;
          default:
            message = data['message'] ?? message;
        }
      }
      throw TeamSelectApiException(message, code: errorCode);
    } catch (e) {
      if (e is TeamSelectApiException) rethrow;
      throw TeamSelectApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }
}

final teamSelectApiProvider = Provider<TeamSelectApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamSelectApi(dio);
});
