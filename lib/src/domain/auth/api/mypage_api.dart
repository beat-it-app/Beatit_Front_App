import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';

import '../model/mypage/mypage_model.dart';

class MyPageApiException implements Exception {
  final String message;
  final String? code;

  MyPageApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class MyPageApi {
  final Dio _dio;

  MyPageApi(this._dio);

  Future<MyPageResponseModel> getMyPage() async {
    try {
      final response = await _dio.get('/mypage');
      final data = response.data;

      if (data is Map<String, dynamic> && data['data'] != null) {
        return MyPageResponseModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      }
      throw MyPageApiException('마이페이지 데이터를 불러오지 못했습니다.');
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String message = '마이페이지 조회에 실패했습니다.';
      String? code;

      if (errorData is Map<String, dynamic>) {
        message = errorData['message'] ?? message;
        code = errorData['code']?.toString() ?? errorData['status']?.toString();
      }
      throw MyPageApiException(message, code: code);
    } catch (e) {
      if (e is MyPageApiException) rethrow;
      throw MyPageApiException('네트워크 오류가 발생했습니다: $e');
    }
  }
}

final myPageApiProvider = Provider<MyPageApi>((ref) {
  final dio = ref.watch(dioProvider);
  return MyPageApi(dio);
});
