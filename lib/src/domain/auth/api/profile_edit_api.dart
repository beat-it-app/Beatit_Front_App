import 'dart:io';
import 'package:dio/dio.dart';
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
      final response = await _dio.patch(
        '/mypage/profile/name',
        data: {'name': newName},
      );
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

  // 2. 프로필 이미지 변경 (PATCH /mypage/profile/image)
  // default_image_id(1~4) 또는 profile_image(MultipartFile)
  Future<void> updateProfileImage({
    int? defaultImageId,
    File? customImageFile,
  }) async {
    try {
      FormData formData;
      if (customImageFile != null) {
        formData = FormData.fromMap({
          'profile_image': await MultipartFile.fromFile(
            customImageFile.path,
            filename: customImageFile.path.split('/').last,
          ),
        });
      } else if (defaultImageId != null) {
        formData = FormData.fromMap({'default_image_id': defaultImageId});
      } else {
        throw ProfileEditApiException('선택된 이미지가 없습니다.');
      }

      final response = await _dio.patch(
        '/mypage/profile/image',
        data: formData,
      );
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

  // 3. 프로필 이미지 삭제 (DELETE /mypage/profile/image)
  Future<void> deleteProfileImage() async {
    try {
      final response = await _dio.delete('/mypage/profile/image');
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
