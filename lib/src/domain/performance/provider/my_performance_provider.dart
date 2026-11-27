import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/performance_model.dart';

final myPerformanceListProvider =
    FutureProvider.autoDispose<List<PerformanceModel>>((ref) async {
      final dio = ref.watch(dioProvider);

      try {
        debugPrint('================ 📤 [GET 나의 공연 목록 요청] ================');
        final response = await dio.get(
          '/performances/my',
          queryParameters: {'filter': 'ALL', 'page': 0, 'size': 50},
        );

        debugPrint('📥 [GET 나의 공연 목록 응답 상태코드]: ${response.statusCode}');
        debugPrint('📦 [GET 나의 공연 목록 바디]:\n${jsonEncode(response.data)}');

        final resData = response.data;
        if (resData is Map<String, dynamic> && resData['data'] != null) {
          final parsed = PerformanceResponseModel.fromJson(
            resData['data'] as Map<String, dynamic>,
          );
          // '전체 보기'이므로 upcoming과 past를 모두 합친 allItems 반환
          return parsed.allItems;
        }

        return [];
      } on DioException catch (e) {
        debugPrint(
          '🚨 [GET 나의 공연 목록 실패]: ${e.response?.statusCode} - ${e.message}',
        );
        return [];
      } catch (e, stack) {
        debugPrint('🚨 [GET 나의 공연 목록 파싱 에러]: $e\n$stack');
        return [];
      }
    });
