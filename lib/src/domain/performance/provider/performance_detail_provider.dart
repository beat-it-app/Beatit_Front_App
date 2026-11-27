import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/performance_detail_response_model.dart';

final performanceDetailProvider = FutureProvider.autoDispose
    .family<PerformanceDetailModel, String>((ref, publicId) async {
      final dio = ref.watch(dioProvider);

      try {
        debugPrint('================ 📤 [GET 공연 상세 조회 요청] ================');
        debugPrint('👉 URL: /performances/$publicId');

        final response = await dio.get('/performances/$publicId');

        debugPrint('📥 [GET 공연 상세 응답] Status: ${response.statusCode}');
        debugPrint('📥 [GET 공연 상세 바디]:\n${jsonEncode(response.data)}');

        final resData = response.data;
        if (resData is Map<String, dynamic> && resData['data'] != null) {
          final dataMap = resData['data'] as Map<String, dynamic>;

          // 💡 1. 백엔드에서 넘어온 원본 key 확인
          debugPrint('--- 🔍 [백엔드 원본 필드 확인] ---');
          debugPrint('🔹 teamName: ${dataMap['teamName']}');
          debugPrint('🔹 location: ${dataMap['location']}');
          debugPrint('🔹 prices: ${dataMap['prices']}');
          debugPrint('🔹 description: ${dataMap['description']}');
          debugPrint('🔹 detailInfo: ${dataMap['detailInfo']}');
          debugPrint('-----------------------------------');

          final model = PerformanceDetailModel.fromJson(dataMap);

          // 💡 2. Model로 파싱된 결과 확인
          debugPrint('--- 🔍 [PerformanceDetailModel 파싱 결과] ---');
          debugPrint('✅ model.teamName: ${model.teamName}');
          debugPrint(
            '✅ model.location: ${model.location?.locationName} / ${model.location?.roadAddress}',
          );
          debugPrint(
            '✅ model.prices: ${model.prices.map((p) => '${p.priceType}:${p.price}').toList()}',
          );
          debugPrint('----------------------------------------------');

          return model;
        }

        throw Exception('공연 상세 데이터를 불러올 수 없습니다.');
      } on DioException catch (e) {
        debugPrint(
          '🚨 [GET 공연 상세 실패]: ${e.response?.statusCode} - ${e.message}',
        );
        final msg = e.response?.data?['message'] ?? '공연 정보를 불러오지 못했습니다.';
        throw Exception(msg);
      } catch (e, stack) {
        debugPrint('🚨 [GET 공연 상세 파싱 오류]: $e\n$stack');
        rethrow;
      }
    });
