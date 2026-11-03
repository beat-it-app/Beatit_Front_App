import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/performance_create_model.dart';

final performanceApiProvider = Provider<PerformanceApi>((ref) {
  return PerformanceApi(ref.watch(dioProvider));
});

class PerformanceApi {
  final Dio _dio;

  PerformanceApi(this._dio);

  Future<void> createPerformance(PerformanceFullCreateData data) async {
    try {
      final formData = FormData();

      // 1. JSON DTO 추가 (application/json 타입 명시)
      final jsonPayload = jsonEncode(data.toRequestJson());
      formData.fields.add(MapEntry('performanceCreateRequest', jsonPayload));

      // 2. 포스터 이미지 파일 (선택)
      if (data.step1.poster != null) {
        final posterFile = await MultipartFile.fromFile(
          data.step1.poster!.path,
          filename: data.step1.poster!.name,
        );
        formData.files.add(MapEntry('posterImage', posterFile));
      }

      // 3. 상세 이미지 목록 (0~5장 또는 최대 10장)
      for (final image in data.detailImages) {
        final multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
        formData.files.add(MapEntry('detailImages', multipartFile));
      }

      debugPrint(
        '================ 📤 [POST /performances 공연 등록 요청] ================',
      );
      debugPrint('📦 Payload: $jsonPayload');

      final response = await _dio.post(
        '/performances',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      debugPrint('📥 [POST /performances 상태코드]: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint(
        '🚨 [공연 등록 실패]: ${e.response?.statusCode} - ${e.response?.data}',
      );
      final msg = e.response?.data?['message'] ?? '공연 등록 중 오류가 발생했습니다.';
      throw Exception(msg);
    } catch (e) {
      debugPrint('🚨 [공연 등록 알 수 없는 오류]: $e');
      rethrow;
    }
  }
}
