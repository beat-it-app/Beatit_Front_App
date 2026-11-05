import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/performance_create_model.dart';
import '../model/performance_detail_response_model.dart';
import '../model/performance_model.dart';

final performanceApiProvider = Provider<PerformanceApi>((ref) {
  return PerformanceApi(ref.watch(dioProvider));
});

class PerformanceApi {
  final Dio _dio;

  PerformanceApi(this._dio);

  /// 1. 공연 등록 (POST /performances)
  Future<void> createPerformance(PerformanceFullCreateData data) async {
    try {
      final formData = FormData();

      // 💡 백엔드 @RequestPart("performanceCreateRequest") 요구 스펙 충족
      final jsonPayload = jsonEncode(data.toRequestJson());
      formData.files.add(
        MapEntry(
          'performanceCreateRequest',
          MultipartFile.fromString(
            jsonPayload,
            contentType: DioMediaType('application', 'json'),
          ),
        ),
      );

      // 포스터 이미지 파일 (선택)
      if (data.step1.poster != null) {
        final posterFile = await MultipartFile.fromFile(
          data.step1.poster!.path,
          filename: data.step1.poster!.name,
        );
        formData.files.add(MapEntry('posterImage', posterFile));
      }

      // 상세 이미지 목록 (0~5장)
      for (final image in data.detailImages) {
        final multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        );
        formData.files.add(MapEntry('detailImages', multipartFile));
      }

      debugPrint(
        '================ 📤 [POST /performances 등록 요청] ================',
      );
      debugPrint('📦 Payload: $jsonPayload');

      // Dio 자체 boundary 생성을 위해 contentType 헤더를 수동으로 덮어쓰지 않고 전송
      final response = await _dio.post('/performances', data: formData);

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

  /// 2. 공연 수정 (PATCH /performances/{publicId})
  Future<void> updatePerformance({
    required String publicId,
    required Map<String, dynamic> requestJsonMap,
    MultipartFile? posterImage,
    List<MultipartFile>? detailImages,
  }) async {
    try {
      final formData = FormData();

      // 💡 백엔드 컨트롤러 파라미터 규격에 맞춤 (보통 'request' 또는 'performanceUpdateRequest')
      final jsonPayload = jsonEncode(requestJsonMap);
      formData.files.add(
        MapEntry(
          'request',
          MultipartFile.fromString(
            jsonPayload,
            contentType: DioMediaType('application', 'json'),
          ),
        ),
      );

      if (posterImage != null) {
        formData.files.add(MapEntry('posterImage', posterImage));
      }

      if (detailImages != null && detailImages.isNotEmpty) {
        for (final file in detailImages) {
          formData.files.add(MapEntry('detailImages', file));
        }
      }

      debugPrint(
        '================ 📤 [PATCH /performances/$publicId 수정 요청] ================',
      );
      debugPrint('📦 Payload: $jsonPayload');

      final response = await _dio.patch(
        '/performances/$publicId',
        data: formData,
      );

      debugPrint(
        '📥 [PATCH /performances/$publicId 상태코드]: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint(
        '🚨 [공연 수정 실패]: ${e.response?.statusCode} - ${e.response?.data}',
      );
      final msg = e.response?.data?['message'] ?? '공연 수정 중 오류가 발생했습니다.';
      throw Exception(msg);
    } catch (e) {
      debugPrint('🚨 [공연 수정 알 수 없는 오류]: $e');
      rethrow;
    }
  }

  /// 3. 공연 삭제 (DELETE /performances/{publicId})
  Future<void> deletePerformance(String publicId) async {
    try {
      debugPrint(
        '================ 📤 [DELETE /performances/$publicId 삭제 요청] ================',
      );
      final response = await _dio.delete('/performances/$publicId');
      debugPrint(
        '📥 [DELETE /performances/$publicId 상태코드]: ${response.statusCode}',
      );
    } on DioException catch (e) {
      debugPrint(
        '🚨 [공연 삭제 실패]: ${e.response?.statusCode} - ${e.response?.data}',
      );
      final msg = e.response?.data?['message'] ?? '공연 삭제에 실패했습니다.';
      throw Exception(msg);
    } catch (e) {
      debugPrint('🚨 [공연 삭제 알 수 없는 오류]: $e');
      rethrow;
    }
  }
}
