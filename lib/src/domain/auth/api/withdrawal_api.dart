import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';

class WithdrawalApiException implements Exception {
  final String message;
  final String? code;

  WithdrawalApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class WithdrawalApi {
  final Dio _dio;

  WithdrawalApi(this._dio);

  // 1. 팀 탈퇴 안내 정보 조회 (GET /teams/withdrawal-info)
  Future<Map<String, dynamic>> getTeamWithdrawalInfo() async {
    try {
      final res = await _dio.get('/teams/withdrawl-info');
      return (res.data['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw _parseError(e, '팀 탈퇴 안내 정보 조회에 실패했습니다.');
    }
  }

  // 2. 팀 탈퇴 요청 (POST /teams/withdraw)
  Future<Map<String, dynamic>> withdrawTeam() async {
    try {
      final res = await _dio.post('/teams/withdraw');
      return (res.data['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw _parseError(e, '팀 탈퇴 처리에 실패했습니다.');
    }
  }

  // 3. 회원(빗잇) 탈퇴 안내 정보 조회 (GET /auth/withdrawl-info)
  Future<Map<String, dynamic>> getAuthWithdrawalInfo() async {
    try {
      final res = await _dio.get('/auth/withdrawl-info');
      return (res.data['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw _parseError(e, '회원 탈퇴 안내 정보 조회에 실패했습니다.');
    }
  }

  // 4. 회원(빗잇) 탈퇴 요청 (PATCH /auth/withdraw)
  Future<Map<String, dynamic>> withdrawAuth({
    required String withdrawalReason,
    required String detailReason,
  }) async {
    try {
      final res = await _dio.patch(
        '/auth/withdraw',
        data: {
          'withdrawalReason': withdrawalReason,
          'detailReason': detailReason,
        },
      );
      return (res.data['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw _parseError(e, '회원 탈퇴 처리에 실패했습니다.');
    }
  }

  Future<void> deleteTeam() async {
    try {
      final response = await _dio.delete('/teams/delete');

      if (response.statusCode != 200) {
        throw WithdrawalApiException(
          response.data?['message'] ?? '팀 삭제에 실패했습니다.',
        );
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? '팀 삭제 요청 중 오류가 발생했습니다.';
      throw WithdrawalApiException(errorMsg);
    }
  }

  Future<Map<String, dynamic>> getTeamDeletionInfo() async {
    try {
      final res = await _dio.get('/teams/deletion-info');
      final raw = res.data;
      if (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return {};
    } on DioException catch (e) {
      throw _parseError(e, '팀 삭제 안내 정보 조회에 실패했습니다.');
    }
  }

  WithdrawalApiException _parseError(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return WithdrawalApiException(
        data['message'] ?? fallback,
        code: data['status']?.toString() ?? data['code']?.toString(),
      );
    }
    return WithdrawalApiException(fallback);
  }
}

final withdrawalApiProvider = Provider<WithdrawalApi>((ref) {
  final dio = ref.watch(dioProvider);
  return WithdrawalApi(dio);
});
