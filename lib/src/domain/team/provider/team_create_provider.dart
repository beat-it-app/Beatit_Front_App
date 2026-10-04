import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/team_create_request.dart';

class TeamApiException implements Exception {
  final String message;
  final String? code;

  TeamApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class TeamApi {
  final Dio _dio;

  TeamApi(this._dio);

  // 💡 [수정]: File? teamImageFile 매개변수 추가 및 FormData 방식으로 전송
  Future<void> createTeam(
    TeamCreateRequest request, {
    File? teamImageFile,
  }) async {
    try {
      // 백엔드 @RequestParam 스펙에 맞게 Map 구성
      final map = <String, dynamic>{
        'teamName': request.teamName,
        'teamType': request.teamType,
        if (request.description != null &&
            request.description!.trim().isNotEmpty)
          'description': request.description!.trim(),
        if (request.establishedOn != null &&
            request.establishedOn!.trim().isNotEmpty)
          'establishedOn': request.establishedOn!.trim(),
      };

      // 백엔드 @RequestPart(value = "teamImage") 스펙에 맞게 파일 추가
      if (teamImageFile != null) {
        final fileName = teamImageFile.path.split('/').last;
        map['teamImage'] = await MultipartFile.fromFile(
          teamImageFile.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap(map);

      // Dio에 FormData를 전달하면 자동으로 Content-Type이 multipart/form-data로 지정됩니다.
      await _dio.post('/teams', data: formData);
    } on DioException catch (e) {
      String message = '팀 생성에 실패했습니다.';
      String? errorCode;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorCode =
            data['status']?.toString() ?? data['errorCode'] ?? data['code'];
        switch (errorCode) {
          case 'TEAM-003':
            message = '팀 이름은 필수입니다.';
            break;
          case 'TEAM-004':
            message = '팀 이름은 100자 이하여야 합니다.';
            break;
          case 'TEAM-005':
            message = '팀 설명은 500자 이하여야 합니다.';
            break;
          case 'COMMON-002':
            message = '로그인이 필요한 서비스입니다.';
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
      throw TeamApiException(message, code: errorCode);
    } catch (e) {
      if (e is TeamApiException) rethrow;
      throw TeamApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }
}

final teamApiProvider = Provider<TeamApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamApi(dio);
});

class TeamCreateState {
  const TeamCreateState({this.isCreating = false, this.createError});

  final bool isCreating;
  final String? createError;

  bool get isLoading => isCreating;

  TeamCreateState copyWith({
    bool? isCreating,
    String? createError,
    bool clearError = false,
  }) {
    return TeamCreateState(
      isCreating: isCreating ?? this.isCreating,
      createError: clearError ? null : (createError ?? this.createError),
    );
  }
}

class TeamCreateNotifier extends Notifier<TeamCreateState> {
  @override
  TeamCreateState build() {
    return const TeamCreateState();
  }

  // 💡 [수정]: File? teamImageFile 선택 파라미터 전달 지원
  Future<bool> createTeam(
    TeamCreateRequest request, {
    File? teamImageFile,
  }) async {
    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final teamApi = ref.read(teamApiProvider);
      await teamApi.createTeam(request, teamImageFile: teamImageFile);

      state = state.copyWith(isCreating: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isCreating: false,
        createError: _getErrorMessage(error),
      );
      return false;
    }
  }

  void reset() {
    state = const TeamCreateState();
  }

  String _getErrorMessage(Object error) {
    if (error is TeamApiException) {
      return error.message;
    }
    return '요청 처리 중 오류가 발생했습니다.';
  }
}

final teamCreateProvider =
    NotifierProvider.autoDispose<TeamCreateNotifier, TeamCreateState>(
      TeamCreateNotifier.new,
    );
