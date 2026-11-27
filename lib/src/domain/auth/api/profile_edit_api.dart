// lib/src/domain/mypage/api/profile_edit_api.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';

class ProfileEditApiException implements Exception {
  final String message;
  final String? code;

  ProfileEditApiException(this.message, {this.code});

  @override
  String toString() => message;
}

class ProfileEditApi {
  final Dio _dio;

  ProfileEditApi(this._dio);

  // 1. 이름 변경 (PATCH /mypage/profile/name)
  Future<void> updateName(String newName) async {
    try {
      debugPrint('👉 [PATCH /mypage/profile/name] 요청: {"name": "$newName"}');
      final response = await _dio.patch(
        '/mypage/profile/name',
        data: {'name': newName},
      );
      debugPrint('👉 [PATCH /mypage/profile/name] 응답: ${response.data}');

      final data = response.data;
      if (data['success'] != true) {
        throw ProfileEditApiException(
          data['message'] ?? '이름 변경에 실패했습니다.',
          code: data['status']?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, '이름 변경에 실패했습니다.');
    }
  }

  // 2. 프로필 이미지 변경 (PATCH /mypage/image)
  // - 기본 프로필 선택 시: defaultImageId (Query Parameter) + 빈 FormData (multipart/form-data 헤더 유지)
  // - 새 갤러리 이미지 선택 시: image (MultipartFile Body)
  Future<void> updateProfileImage({
    int? defaultImageId,
    File? customImageFile,
  }) async {
    try {
      final formData = FormData();
      Map<String, dynamic>? queryParams;

      if (customImageFile != null) {
        // 💡 갤러리 이미지: multipart/form-data body에 'image' 키로 첨부
        final fileName = customImageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              customImageFile.path,
              filename: fileName,
            ),
          ),
        );
      } else if (defaultImageId != null) {
        // 💡 기본 프로필 선택: Swagger 규격대로 Query Parameter에 defaultImageId 전달
        queryParams = {'defaultImageId': defaultImageId};
      } else {
        throw ProfileEditApiException('선택된 이미지가 없습니다.');
      }

      debugPrint(
        '👉 [PATCH /mypage/image] 전송 - Query: $queryParams, 파일첨부 여부: ${customImageFile != null}',
      );

      // 💡 Content-Type을 multipart/form-data로 고정하고 data에 formData를 항상 전송하여 application/json 방지
      final response = await _dio.patch(
        '/mypage/profile/image',
        queryParameters: queryParams,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      debugPrint('👉 [PATCH /mypage/image] 응답: ${response.data}');

      final data = response.data;
      if (data['success'] != true) {
        throw ProfileEditApiException(
          data['message'] ?? '프로필 이미지 변경에 실패했습니다.',
          code: data['status']?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, '프로필 이미지 변경에 실패했습니다.');
    }
  }

  // 3. 프로필 이미지 삭제 (DELETE /mypage/image)
  Future<void> deleteProfileImage() async {
    try {
      debugPrint('👉 [DELETE /mypage/image] 요청 전송');
      final response = await _dio.delete('/mypage/image');
      debugPrint('👉 [DELETE /mypage/image] 응답: ${response.data}');

      final data = response.data;
      if (data['success'] != true) {
        throw ProfileEditApiException(
          data['message'] ?? '프로필 이미지 삭제에 실패했습니다.',
          code: data['status']?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, '프로필 이미지 삭제에 실패했습니다.');
    }
  }

  void _handleDioException(DioException e, String defaultMessage) {
    debugPrint(
      '❌ [ProfileEditApi Error] HTTP ${e.response?.statusCode}: ${e.response?.data}',
    );
    final errorData = e.response?.data;
    String message = defaultMessage;
    String? code;
    if (errorData is Map<String, dynamic>) {
      message = errorData['message'] ?? message;
      code = errorData['status']?.toString() ?? errorData['code']?.toString();
    }
    throw ProfileEditApiException(message, code: code);
  }
}

final profileEditApiProvider = Provider<ProfileEditApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileEditApi(dio);
});
