import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import '../model/team_performance_model.dart';
import '../model/team_schedule_model.dart';

/// 다가오는 공연 조회 (GET /teams/performances)
final teamUpcomingPerformancesProvider =
    FutureProvider.autoDispose<List<TeamPerformanceModel>>((ref) async {
      final dio = ref.watch(dioProvider);
      final response = await dio.get('/teams/performances');

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is Map<String, dynamic> && data['items'] is List) {
          return (data['items'] as List)
              .map(
                (e) => TeamPerformanceModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    });

/// 다가오는 일정 조회 (GET /teams/calendars)
final teamUpcomingSchedulesProvider =
    FutureProvider.autoDispose<List<TeamScheduleModel>>((ref) async {
      final dio = ref.watch(dioProvider);

      try {
        final response = await dio.get('/teams/calendars');

        debugPrint('====================================');
        debugPrint('🔥 [GET /teams/calendars] Status: ${response.statusCode}');
        debugPrint(
          '🔥 [GET /teams/calendars] Raw Body:\n${jsonEncode(response.data)}',
        );
        debugPrint('====================================');

        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          // 1. data.items 구조 대응
          final data = resData['data'];
          if (data is Map<String, dynamic> && data['items'] is List) {
            return (data['items'] as List)
                .map(
                  (e) => TeamScheduleModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }

          // 2. data 자체가 List로 내려오는 경우 대비 (fallback)
          if (data is List) {
            return data
                .map(
                  (e) => TeamScheduleModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }
        }

        return [];
      } on DioException catch (e) {
        debugPrint(
          '❌ [GET /teams/calendars] DioException: ${e.response?.statusCode} - ${e.message}',
        );

        // 선택된 팀이 없거나(TEAM-012) 일정이 없는 상태 등에서는 빈 리스트를 반환하여
        // UI가 죽지 않고 Empty Box('등록된 일정이 없습니다')를 표시하도록 처리
        final errorData = e.response?.data;
        if (errorData is Map<String, dynamic>) {
          final code = errorData['code'] ?? errorData['errorCode'];
          if (code == 'TEAM-012' ||
              e.response?.statusCode == 400 ||
              e.response?.statusCode == 404) {
            return [];
          }
        }
        rethrow;
      } catch (e, stack) {
        debugPrint('❌ [GET /teams/calendars] Parsing Error: $e\n$stack');
        return [];
      }
    });
