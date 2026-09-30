import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloud_models.freezed.dart';
part 'cloud_models.g.dart';

@freezed
abstract class CloudListResponse with _$CloudListResponse {
  const factory CloudListResponse({
    required bool success,
    required int status,
    required String message,
    required CloudListData data,
  }) = _CloudListResponse;

  factory CloudListResponse.fromJson(Map<String, dynamic> json) =>
      _$CloudListResponseFromJson(json);
}

@freezed
abstract class CloudListData with _$CloudListData {
  const factory CloudListData({
    String? currentFolderName,
    @Default(<CloudFolder>[]) List<CloudFolder> folders,
    @Default(<CloudItem>[]) List<CloudItem> items,
  }) = _CloudListData;

  factory CloudListData.fromJson(Map<String, dynamic> json) =>
      _$CloudListDataFromJson(json);
}

@freezed
abstract class CloudFolder with _$CloudFolder {
  const factory CloudFolder({
    required int folderId,
    required String folderName,
    required int itemCount,
    required String creatorName,
  }) = _CloudFolder;

  factory CloudFolder.fromJson(Map<String, dynamic> json) =>
      _$CloudFolderFromJson(json);
}

@freezed
abstract class CloudItem with _$CloudItem {
  const factory CloudItem({
    required int itemId,
    required String itemName,
    int? fileSize,
    String? mimeType,
    String? linkUrl,
    required String uploaderName,
    required DateTime createdAt,
  }) = _CloudItem;

  factory CloudItem.fromJson(Map<String, dynamic> json) =>
      _$CloudItemFromJson(json);
}

@freezed
abstract class CloudPresignedUrlResponse with _$CloudPresignedUrlResponse {
  const factory CloudPresignedUrlResponse({
    required bool success,
    required int status,
    required String message,
    required CloudPresignedUrlData data,
  }) = _CloudPresignedUrlResponse;

  factory CloudPresignedUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$CloudPresignedUrlResponseFromJson(json);
}

@freezed
abstract class CloudPresignedUrlData with _$CloudPresignedUrlData {
  const factory CloudPresignedUrlData({
    required String presignedUrl,
    required String storageKey,
    required String cdnUrl,
    required int expirationMinutes,
  }) = _CloudPresignedUrlData;

  factory CloudPresignedUrlData.fromJson(Map<String, dynamic> json) =>
      _$CloudPresignedUrlDataFromJson(json);
}

@freezed
abstract class CloudIdResponse with _$CloudIdResponse {
  const factory CloudIdResponse({
    required bool success,
    required int status,
    required String message,
    required int data,
  }) = _CloudIdResponse;

  factory CloudIdResponse.fromJson(Map<String, dynamic> json) =>
      _$CloudIdResponseFromJson(json);
}

@freezed
abstract class CloudFolderRequest with _$CloudFolderRequest {
  const factory CloudFolderRequest({required String folderName}) =
      _CloudFolderRequest;

  factory CloudFolderRequest.fromJson(Map<String, dynamic> json) =>
      _$CloudFolderRequestFromJson(json);
}

@freezed
abstract class CloudItemsDeleteRequest with _$CloudItemsDeleteRequest {
  const factory CloudItemsDeleteRequest({required List<int> itemIds}) =
      _CloudItemsDeleteRequest;

  factory CloudItemsDeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$CloudItemsDeleteRequestFromJson(json);
}

@freezed
abstract class CloudLinkCreateRequest with _$CloudLinkCreateRequest {
  const factory CloudLinkCreateRequest({
    required String linkUrl,
    required String itemName,
  }) = _CloudLinkCreateRequest;

  factory CloudLinkCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$CloudLinkCreateRequestFromJson(json);
}
