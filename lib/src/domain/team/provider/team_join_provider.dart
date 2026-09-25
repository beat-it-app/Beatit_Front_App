import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/team_verify_response.dart';

class TeamJoinApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  TeamJoinApiException(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;
}

class TeamJoinApi {
  final Dio _dio;

  TeamJoinApi(this._dio);

  // 1. 초대 코드 확인 API (GET /teams/verify/{inviteCode})
  Future<TeamVerifyData> verifyInviteCode(String inviteCode) async {
    try {
      final response = await _dio.get('/teams/verify/$inviteCode');

      final data = response.data is Map<String, dynamic>
          ? response.data
          : Map<String, dynamic>.from(response.data);

      final result = TeamVerifyResponse.fromJson(data);

      if (result.success && result.data != null) {
        return result.data!;
      } else {
        throw TeamJoinApiException(
          result.message.isNotEmpty ? result.message : '존재하지 않는 코드입니다.',
        );
      }
    } on DioException catch (e) {
      String message = '존재하지 않는 코드입니다.';
      String? errorCode;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorCode = data['errorCode'] ?? data['code'];
        message = data['message'] ?? message;
      }
      throw TeamJoinApiException(message, code: errorCode);
    } catch (e) {
      if (e is TeamJoinApiException) rethrow;
      throw TeamJoinApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }

  Future<void> joinTeam(String teamPublicId) async {
    try {
      await _dio.post('/teams/join/$teamPublicId');
    } on DioException catch (e) {
      print('📦 [백엔드 원본 에러 응답 전체]: ${e.response?.data}');
      print('📦 [응답 데이터 타입]: ${e.response?.data.runtimeType}');
      String message = '팀 가입 처리에 실패했습니다.';
      String? errorCode;
      final statusCode = e.response?.statusCode;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorCode = data['status'];
        message = data['message'] ?? message;
      }
      throw TeamJoinApiException(
        message,
        code: errorCode,
        statusCode: statusCode,
      );
    } catch (e) {
      if (e is TeamJoinApiException) rethrow;
      throw TeamJoinApiException('네트워크 통신 중 오류가 발생했습니다.');
    }
  }
}

final teamJoinApiProvider = Provider<TeamJoinApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamJoinApi(dio);
});

class TeamJoinState {
  const TeamJoinState({
    this.isVerifying = false,
    this.isJoining = false,
    this.errorMessage,
    this.errorCode,
    this.statusCode,
    this.verifiedTeam,
  });

  final bool isVerifying;
  final bool isJoining;
  final String? errorMessage;
  final String? errorCode;
  final int? statusCode;
  final TeamVerifyData? verifiedTeam;

  TeamJoinState copyWith({
    bool? isVerifying,
    bool? isJoining,
    String? errorMessage,
    String? errorCode,
    int? statusCode,
    TeamVerifyData? verifiedTeam,
    bool clearError = false,
  }) {
    return TeamJoinState(
      isVerifying: isVerifying ?? this.isVerifying,
      isJoining: isJoining ?? this.isJoining,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      statusCode: clearError ? null : (statusCode ?? this.statusCode),
      verifiedTeam: verifiedTeam ?? this.verifiedTeam,
    );
  }
}

class TeamJoinNotifier extends Notifier<TeamJoinState> {
  @override
  TeamJoinState build() {
    return const TeamJoinState();
  }

  Future<bool> verifyInviteCode(String inviteCode) async {
    state = state.copyWith(isVerifying: true, clearError: true);

    try {
      final teamJoinApi = ref.read(teamJoinApiProvider);
      final teamData = await teamJoinApi.verifyInviteCode(inviteCode);

      state = state.copyWith(isVerifying: false, verifiedTeam: teamData);
      return true;
    } catch (error) {
      state = state.copyWith(
        isVerifying: false,
        errorMessage: _getErrorMessage(error),
      );
      return false;
    }
  }

  Future<bool> joinTeam(String teamPublicId) async {
    state = state.copyWith(isJoining: true, clearError: true);

    try {
      final teamJoinApi = ref.read(teamJoinApiProvider);
      await teamJoinApi.joinTeam(teamPublicId);

      state = state.copyWith(isJoining: false);
      return true;
    } catch (error) {
      String? code;
      int? status;
      if (error is TeamJoinApiException) {
        code = error.code;
        status = error.statusCode;
      }
      state = state.copyWith(
        isJoining: false,
        errorMessage: _getErrorMessage(error),
        errorCode: code,
        statusCode: status,
      );
      return false;
    }
  }

  String _getErrorMessage(Object error) {
    if (error is TeamJoinApiException) {
      return error.message;
    }
    return '요청 처리 중 오류가 발생했습니다.';
  }
}

final teamJoinProvider =
    NotifierProvider.autoDispose<TeamJoinNotifier, TeamJoinState>(
      TeamJoinNotifier.new,
    );
