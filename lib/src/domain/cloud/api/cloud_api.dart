import 'dart:io';

import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/cloud/model/cloud_models.dart';

class CloudApi {
  CloudApi(this._dio);

  final Dio _dio;

  static const String _cloudPath = '/teams/clouds';
  static const String _presignedPath = '/files/presigned-url';
  static const int maxUploadFileSize = 300 * 1024 * 1024;

  static const Duration _cloudSendTimeout = Duration(minutes: 5);
  static const Duration _cloudReceiveTimeout = Duration(minutes: 5);

  Future<CloudListResponse> getCloudList({int? folderId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _cloudPath,
        queryParameters: folderId == null ? null : {'folderId': folderId},
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '팀 클라우드 목록을 불러오지 못했습니다.',
      );
      return CloudListResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<CloudFileDetailResponse> getFileDetail({
    required int itemId,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_cloudPath/items/$itemId',
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '파일 정보를 불러오지 못했습니다.',
      );
      return CloudFileDetailResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<CloudStorageResponse> getStorage() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_cloudPath/storage',
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '저장 용량을 불러오지 못했습니다.',
      );
      return CloudStorageResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  /// 현재 Team Cloud 응답에는 uploaderId/creatorId/isMine이 없어서
  /// UI 권한 표시에 한해 /mypage의 사용자 이름을 비교한다.
  /// 동명이인을 완전히 구분하려면 백엔드 응답에 isMine 또는 userId가 필요하다.
  Future<String> getCurrentUserName() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/mypage',
        options: _cloudRequestOptions(),
      );
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '사용자 정보를 불러오지 못했습니다.',
      );
      final data = body['data'];
      if (data is! Map) {
        throw const CloudApiException(message: '사용자 정보 응답이 올바르지 않습니다.');
      }
      final userName = data['userName']?.toString().trim() ?? '';
      if (userName.isEmpty) {
        throw const CloudApiException(message: '사용자 이름을 확인할 수 없습니다.');
      }
      return userName;
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<int> createFolder({required String folderName}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_cloudPath/folders',
        data: CloudFolderRequest(folderName: folderName).toJson(),
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '폴더를 만들지 못했습니다.',
      );
      return CloudIdResponse.fromJson(body).data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> renameFolder({
    required int folderId,
    required String folderName,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '$_cloudPath/folders/$folderId',
        data: CloudFolderRequest(folderName: folderName).toJson(),
        options: _cloudRequestOptions(),
      );

      _requireSuccessBody(
        response: response,
        fallbackMessage: '폴더 이름을 변경하지 못했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> deleteFolder({required int folderId}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '$_cloudPath/folders/$folderId',
        options: _cloudRequestOptions(),
      );

      _requireSuccessBody(
        response: response,
        fallbackMessage: '폴더를 삭제하지 못했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> moveItems({
    required List<int> itemIds,
    int? targetFolderId,
  }) async {
    if (itemIds.isEmpty) {
      return;
    }

    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '$_cloudPath/items/move',
        data: CloudItemsMoveRequest(
          itemIds: itemIds,
          targetFolderId: targetFolderId,
        ).toJson(),
        options: _cloudRequestOptions(),
      );

      _requireSuccessBody(
        response: response,
        fallbackMessage: '파일을 이동하지 못했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> deleteItems({required List<int> itemIds}) async {
    if (itemIds.isEmpty) {
      return;
    }

    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '$_cloudPath/items',
        data: CloudItemsDeleteRequest(itemIds: itemIds).toJson(),
        options: _cloudRequestOptions(),
      );

      _requireSuccessBody(
        response: response,
        fallbackMessage: '파일을 삭제하지 못했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<int> createLink({
    int? folderId,
    required String itemName,
    required String linkUrl,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_cloudPath/links',
        queryParameters: folderId == null ? null : {'folderId': folderId},
        data: CloudLinkCreateRequest(
          linkUrl: linkUrl,
          itemName: itemName,
        ).toJson(),
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '링크를 등록하지 못했습니다.',
      );
      return CloudIdResponse.fromJson(body).data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<int> uploadFile({
    int? folderId,
    required String filePath,
    required String fileName,
    required int fileSize,
  }) async {
    final normalizedName = fileName.trim();
    if (normalizedName.isEmpty) {
      throw const CloudApiException(message: '파일 이름을 확인해주세요.');
    }
    if (fileSize <= 0) {
      throw const CloudApiException(message: '빈 파일은 등록할 수 없습니다.');
    }
    if (fileSize > maxUploadFileSize) {
      throw const CloudApiException(message: '파일은 최대 300MB까지 등록할 수 있습니다.');
    }

    final contentType = contentTypeForFileName(normalizedName);
    final presigned = await _getPresignedUrl(fileName: normalizedName);
    final file = File(filePath);

    if (!await file.exists()) {
      throw const CloudApiException(message: '선택한 파일을 찾을 수 없습니다.');
    }

    final uploadDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        // 300MB 파일은 네트워크 환경에 따라 업로드에 오래 걸릴 수 있다.
        // Duration.zero는 Dio의 send/receive timeout을 비활성화한다.
        sendTimeout: Duration.zero,
        receiveTimeout: Duration.zero,
      ),
    );

    try {
      await uploadDio.put<void>(
        presigned.presignedUrl,
        data: file.openRead(),
        options: Options(
          contentType: contentType,
          headers: {
            Headers.contentTypeHeader: contentType,
            Headers.contentLengthHeader: fileSize,
          },
          sendTimeout: Duration.zero,
          receiveTimeout: Duration.zero,
        ),
      );
    } on DioException catch (error) {
      throw CloudApiException(
        message: _uploadErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    } on FileSystemException {
      throw const CloudApiException(message: '선택한 파일을 읽을 수 없습니다.');
    } finally {
      uploadDio.close(force: true);
    }

    return _registerFile(
      folderId: folderId,
      fileName: normalizedName,
      storageKey: presigned.storageKey,
      fileSize: fileSize,
      contentType: contentType,
    );
  }

  Future<CloudPresignedUrlData> _getPresignedUrl({
    required String fileName,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _presignedPath,
        queryParameters: {
          'originalFileName': fileName,
          'directory': 'TEAM_CLOUD',
        },
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '파일 업로드 URL을 발급받지 못했습니다.',
      );
      return CloudPresignedUrlResponse.fromJson(body).data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<int> _registerFile({
    int? folderId,
    required String fileName,
    required String storageKey,
    required int fileSize,
    required String contentType,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'fileName': fileName,
        'storageKey': storageKey,
        'fileSize': fileSize,
        'contentType': contentType,
      };
      if (folderId != null) {
        queryParameters['folderId'] = folderId;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '$_cloudPath/files',
        queryParameters: queryParameters,
        options: _cloudRequestOptions(),
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '팀 클라우드에 파일을 등록하지 못했습니다.',
      );
      return CloudIdResponse.fromJson(body).data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  static String contentTypeForFileName(String fileName) {
    final extension = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';

    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      'mp3' => 'audio/mpeg',
      'wav' => 'audio/x-wav',
      'm4a' => 'audio/mp4',
      'aac' => 'audio/aac',
      'ogg' => 'audio/ogg',
      'flac' => 'audio/flac',
      'mp4' => 'video/mp4',
      'mov' => 'video/quicktime',
      'avi' => 'video/x-msvideo',
      'pdf' => 'application/pdf',
      'zip' => 'application/zip',
      'docx' =>
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'hwp' => 'application/octet-stream',
      _ => 'application/octet-stream',
    };
  }

  Options _cloudRequestOptions() {
    return Options(
      sendTimeout: _cloudSendTimeout,
      receiveTimeout: _cloudReceiveTimeout,
    );
  }

  Map<String, dynamic> _requireSuccessBody({
    required Response<Map<String, dynamic>> response,
    required String fallbackMessage,
  }) {
    final body = response.data;
    if (body == null) {
      throw const CloudApiException(message: '서버 응답이 비어 있습니다.');
    }

    if (body['success'] != true) {
      throw _createApiException(
        body: body,
        statusCode: response.statusCode,
        fallbackMessage: fallbackMessage,
      );
    }

    return body;
  }

  CloudApiException _createApiException({
    required Map<String, dynamic> body,
    required int? statusCode,
    required String fallbackMessage,
  }) {
    return CloudApiException(
      message: body['message']?.toString() ?? fallbackMessage,
      code: body['status']?.toString(),
      statusCode: statusCode,
    );
  }

  CloudApiException _mapDioException(DioException error) {
    final rawData = error.response?.data;
    if (rawData is Map) {
      final body = Map<String, dynamic>.from(rawData);
      return CloudApiException(
        message: body['message']?.toString() ?? '요청에 실패했습니다.',
        code: body['status']?.toString(),
        statusCode: error.response?.statusCode,
      );
    }

    return CloudApiException(
      message: switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.connectionError => '서버와 연결할 수 없습니다.',
        DioExceptionType.sendTimeout => '요청 전송 시간이 초과되었습니다.',
        DioExceptionType.receiveTimeout => '서버 응답 시간이 초과되었습니다.',
        _ => '서버와 통신할 수 없습니다.',
      },
      statusCode: error.response?.statusCode,
    );
  }

  String _uploadErrorMessage(DioException error) {
    if (error.response?.statusCode == 403) {
      return 'S3 업로드 권한을 확인할 수 없습니다. 파일 형식 또는 업로드 URL을 다시 발급해주세요.';
    }
    return 'S3 파일 업로드에 실패했습니다.';
  }
}

class CloudApiException implements Exception {
  const CloudApiException({
    required this.message,
    this.code,
    this.statusCode,
  });

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => message;
}
