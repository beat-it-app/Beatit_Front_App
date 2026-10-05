import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/domain/team/model/team_archive_model.dart';

import '../model/team_archive_detail_model.dart';

final teamArchiveApiProvider = Provider<TeamArchiveApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamArchiveApi(dio);
});

class TeamArchiveApiException implements Exception {
  final String message;
  final String? code;

  TeamArchiveApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class TeamArchiveApi {
  final Dio _dio;

  TeamArchiveApi(this._dio);

  /// 연습실/합주실 기록 목록 조회 (GET /teams/archives)
  Future<List<TeamArchiveItemModel>> getArchives({
    required int teamId,
    String? keyword,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/teams/archives',
        queryParameters: {
          'teamId': teamId,
          if (keyword != null && keyword.trim().isNotEmpty)
            'keyword': keyword.trim(),
          'page': page,
          'size': size,
        },
      );

      final resData = response.data;
      if (resData is Map<String, dynamic> && resData['data'] != null) {
        final innerData = resData['data'];
        if (innerData is Map<String, dynamic>) {
          final parsed = TeamArchiveResponseModel.fromJson(innerData);
          return parsed.archives; // 👈 parsed.items 대신 parsed.archives 사용
        }
      }

      return [];
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '기록 목록을 불러오지 못했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('기록 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 연습실/합주실 기록 생성 (POST /teams/archives)
  Future<void> createArchive({
    required String title,
    required int locationId,
    required String description,
    List<File>? images,
  }) async {
    try {
      final formData = FormData();

      // 1. 폼 데이터에만 필드 추가 (쿼리 스트링 중복 전송 방지)
      formData.fields.addAll([
        MapEntry('title', title),
        MapEntry('locationId', locationId.toString()),
        MapEntry('description', description),
      ]);

      // 2. 이미지 파일들 추가
      if (images != null && images.isNotEmpty) {
        for (final image in images) {
          final fileName = image.path.split('/').last;
          formData.files.add(
            MapEntry(
              'archiveImages',
              await MultipartFile.fromFile(image.path, filename: fileName),
            ),
          );
        }
      }

      // 💡 queryParameters를 제거하고 FormData만 전송
      await _dio.post('/teams/archives', data: formData);
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '연습실 기록 생성에 실패했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('기록 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 연습실 아카이브 수정 (PATCH /teams/archives/{archiveId})
  Future<void> updateArchive({
    required int archiveId,
    required String title,
    required int locationId,
    required String description,
    List<File>? newImages,
  }) async {
    try {
      final formData = FormData();

      // 텍스트 필드 추가
      formData.fields.addAll([
        MapEntry('title', title),
        MapEntry('locationId', locationId.toString()),
        MapEntry('description', description),
      ]);

      // 새 이미지 파일들 추가 (MultipartFile)
      if (newImages != null && newImages.isNotEmpty) {
        for (final image in newImages) {
          final fileName = image.path.split('/').last;
          formData.files.add(
            MapEntry(
              'archiveImages',
              await MultipartFile.fromFile(image.path, filename: fileName),
            ),
          );
        }
      }

      await _dio.patch('/teams/archives/$archiveId', data: formData);
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '연습실 수정에 실패했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('연습실 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 연습실 기록 상세 조회 (GET /teams/archives/{archive_id})
  Future<TeamArchiveDetailModel> getArchiveDetail(int archiveId) async {
    try {
      final response = await _dio.get('/teams/archives/$archiveId');
      final resData = response.data;

      if (resData is Map<String, dynamic> && resData['data'] != null) {
        return TeamArchiveDetailModel.fromJson(
          resData['data'] as Map<String, dynamic>,
        );
      }
      throw TeamArchiveApiException('상세 데이터를 불러올 수 없습니다.');
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '기록 상세 조회에 실패했습니다.',
        code: data?['code']?.toString(),
      );
    }
  }

  /// 연습실 기록 별점 등록/수정 (POST /teams/archives/{archiveId}/ratings)
  Future<TeamArchiveDetailRating> updateRating({
    required int archiveId,
    required int rating,
  }) async {
    try {
      final response = await _dio.post(
        '/teams/archives/$archiveId/ratings',
        queryParameters: {'rating': rating},
      );

      final resData = response.data;
      if (resData is Map<String, dynamic> && resData['data'] != null) {
        return TeamArchiveDetailRating.fromJson(
          resData['data'] as Map<String, dynamic>,
        );
      }

      throw TeamArchiveApiException('별점 처리에 실패했습니다.');
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '별점을 등록하지 못했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('별점 등록 중 오류가 발생했습니다: $e');
    }
  }

  /// 연습실 기록 댓글 작성 (POST /teams/archives/{archiveId}/comments)
  Future<void> addComment({
    required int archiveId,
    required String comment,
    int? parentCommentId,
    List<int>? mentionedUserIds,
  }) async {
    try {
      // 💡 Swagger 명세: 모두 Query Parameters로 전송
      await _dio.post(
        '/teams/archives/$archiveId/comments',
        queryParameters: {
          'comment': comment,
          if (parentCommentId != null) 'parentCommentId': parentCommentId,
          if (mentionedUserIds != null && mentionedUserIds.isNotEmpty)
            'mentionedUserIds': mentionedUserIds,
        },
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '댓글 작성에 실패했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('댓글 작성 중 오류가 발생했습니다: $e');
    }
  }

  /// 연습실 댓글 삭제하기 (DELETE /teams/archives/{archiveId}/comments/{commentId})
  Future<void> deleteComment({
    required int archiveId,
    required int commentId,
  }) async {
    try {
      await _dio.delete('/teams/archives/$archiveId/comments/$commentId');
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '댓글 삭제에 실패했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('댓글 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// 연습실 아카이브 삭제 (DELETE /teams/archives/{archiveId})
  Future<void> deleteArchive(int archiveId) async {
    try {
      await _dio.delete('/teams/archives/$archiveId');
    } on DioException catch (e) {
      final data = e.response?.data;
      throw TeamArchiveApiException(
        data?['message'] ?? '아카이브 삭제에 실패했습니다.',
        code: data?['code']?.toString(),
      );
    } catch (e) {
      throw TeamArchiveApiException('아카이브 삭제 중 오류가 발생했습니다: $e');
    }
  }
}
