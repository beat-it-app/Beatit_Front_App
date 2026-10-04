import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/team_detail_model.dart';

class TeamDetailApiException implements Exception {
  final String message;
  final String? code;

  TeamDetailApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class TeamDetailResult {
  final TeamDetailModel? detail; // 정상 팀 상세 데이터
  final bool hasNoSelectedTeam; // TEAM-012 (선택된 팀 없음) 발생 여부

  TeamDetailResult({this.detail, this.hasNoSelectedTeam = false});
}

class TeamDetailApi {
  final Dio _dio;

  TeamDetailApi(this._dio);

  /// 1. 현재 활성 팀 상세 조회 (GET /teams)
  Future<TeamDetailResult> getActiveTeamDetail() async {
    try {
      final response = await _dio.get('/teams');
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final innerData = data['data'];
        if (innerData is Map<String, dynamic>) {
          return TeamDetailResult(
            detail: TeamDetailModel.fromJson(innerData),
            hasNoSelectedTeam: false,
          );
        }
      }
      throw TeamDetailApiException('응답 데이터 형식이 올바르지 않습니다.');
    } on DioException catch (e) {
      final data = e.response?.data;
      String? errorCode;
      String message = '팀 정보를 불러오지 못했습니다.';

      if (data is Map<String, dynamic>) {
        errorCode =
            data['code'] ?? data['errorCode'] ?? data['status']?.toString();
        message = data['message'] ?? message;

        // 백엔드 핵심 에러: 현재 선택된 팀이 없는 경우
        if (errorCode == 'TEAM-012' || e.response?.statusCode == 400) {
          return TeamDetailResult(hasNoSelectedTeam: true);
        }
      }

      throw TeamDetailApiException(message, code: errorCode);
    } catch (e) {
      if (e is TeamDetailApiException) rethrow;
      throw TeamDetailApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }

  /// 2. 팀 정보 수정 (PATCH /teams, multipart/form-data)
  Future<void> updateTeam({
    required String teamName,
    String? description,
    String? teamType,
    String? establishedOn,
    File? teamImageFile,
    List<Map<String, String>>? links,
  }) async {
    try {
      final Map<String, dynamic> formMap = {'teamName': teamName};

      if (description != null) {
        formMap['description'] = description;
      }
      if (teamType != null) {
        formMap['teamType'] = teamType;
      }
      if (establishedOn != null && establishedOn.isNotEmpty) {
        formMap['establishedOn'] = establishedOn;
      }

      // links는 백엔드에서 String을 ObjectMapper로 파싱하므로 JSON 문자열로 변환하여 전송
      if (links != null) {
        formMap['links'] = jsonEncode(links);
      }

      // 새 이미지 파일이 첨부된 경우 @RequestPart(value = "teamImage")로 전달
      if (teamImageFile != null) {
        final fileName = teamImageFile.path.split('/').last;
        formMap['teamImage'] = await MultipartFile.fromFile(
          teamImageFile.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio.patch(
        '/teams',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['success'] != true) {
          throw TeamDetailApiException(
            data['message'] ?? '팀 정보 수정에 실패했습니다.',
            code: data['code']?.toString(),
          );
        }
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? errorCode;
      String message = '팀 정보를 수정하지 못했습니다.';

      if (data is Map<String, dynamic>) {
        errorCode =
            data['code'] ?? data['errorCode'] ?? data['status']?.toString();
        message = data['message'] ?? message;

        switch (errorCode) {
          case 'TEAM-001':
            message = '팀에 대해 변경할 내용이 없습니다.';
            break;
          case 'TEAM-003':
            message = '팀 이름은 필수입니다.';
            break;
          case 'TEAM-004':
            message = '팀 이름은 100자 이하여야 합니다.';
            break;
          case 'TEAM-005':
            message = '팀 설명은 500자 이하여야 합니다.';
            break;
          case 'TEAM-006':
            message = '팀 수정 권한이 없습니다.';
            break;
          case 'TEAM-011':
            message = '해당 팀의 멤버가 아닙니다.';
            break;
          case 'TEAM-012':
            message = '현재 선택된 팀이 없습니다. 팀을 먼저 선택해주세요.';
            break;
          case 'COMMON-002':
            message = '로그인이 필요한 서비스입니다.';
            break;
        }
      }

      throw TeamDetailApiException(message, code: errorCode);
    } catch (e) {
      if (e is TeamDetailApiException) rethrow;
      throw TeamDetailApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }
}

final teamDetailApiProvider = Provider<TeamDetailApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamDetailApi(dio);
});
