// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CloudListResponse _$CloudListResponseFromJson(Map<String, dynamic> json) =>
    _CloudListResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: CloudListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudListResponseToJson(_CloudListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_CloudListData _$CloudListDataFromJson(Map<String, dynamic> json) =>
    _CloudListData(
      currentFolderName: json['currentFolderName'] as String?,
      folders:
          (json['folders'] as List<dynamic>?)
              ?.map((e) => CloudFolder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CloudFolder>[],
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CloudItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CloudItem>[],
    );

Map<String, dynamic> _$CloudListDataToJson(_CloudListData instance) =>
    <String, dynamic>{
      'currentFolderName': instance.currentFolderName,
      'folders': instance.folders,
      'items': instance.items,
    };

_CloudFolder _$CloudFolderFromJson(Map<String, dynamic> json) => _CloudFolder(
  folderId: (json['folderId'] as num).toInt(),
  folderName: json['folderName'] as String,
  itemCount: (json['itemCount'] as num).toInt(),
  creatorName: json['creatorName'] as String,
);

Map<String, dynamic> _$CloudFolderToJson(_CloudFolder instance) =>
    <String, dynamic>{
      'folderId': instance.folderId,
      'folderName': instance.folderName,
      'itemCount': instance.itemCount,
      'creatorName': instance.creatorName,
    };

_CloudItem _$CloudItemFromJson(Map<String, dynamic> json) => _CloudItem(
  itemId: (json['itemId'] as num).toInt(),
  itemName: json['itemName'] as String,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  mimeType: json['mimeType'] as String?,
  linkUrl: json['linkUrl'] as String?,
  uploaderName: json['uploaderName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CloudItemToJson(_CloudItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'linkUrl': instance.linkUrl,
      'uploaderName': instance.uploaderName,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_CloudPresignedUrlResponse _$CloudPresignedUrlResponseFromJson(
  Map<String, dynamic> json,
) => _CloudPresignedUrlResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CloudPresignedUrlData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CloudPresignedUrlResponseToJson(
  _CloudPresignedUrlResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_CloudPresignedUrlData _$CloudPresignedUrlDataFromJson(
  Map<String, dynamic> json,
) => _CloudPresignedUrlData(
  presignedUrl: json['presignedUrl'] as String,
  storageKey: json['storageKey'] as String,
  cdnUrl: json['cdnUrl'] as String,
  expirationMinutes: (json['expirationMinutes'] as num).toInt(),
);

Map<String, dynamic> _$CloudPresignedUrlDataToJson(
  _CloudPresignedUrlData instance,
) => <String, dynamic>{
  'presignedUrl': instance.presignedUrl,
  'storageKey': instance.storageKey,
  'cdnUrl': instance.cdnUrl,
  'expirationMinutes': instance.expirationMinutes,
};

_CloudIdResponse _$CloudIdResponseFromJson(Map<String, dynamic> json) =>
    _CloudIdResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as num).toInt(),
    );

Map<String, dynamic> _$CloudIdResponseToJson(_CloudIdResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_CloudFolderRequest _$CloudFolderRequestFromJson(Map<String, dynamic> json) =>
    _CloudFolderRequest(folderName: json['folderName'] as String);

Map<String, dynamic> _$CloudFolderRequestToJson(_CloudFolderRequest instance) =>
    <String, dynamic>{'folderName': instance.folderName};

_CloudItemsDeleteRequest _$CloudItemsDeleteRequestFromJson(
  Map<String, dynamic> json,
) => _CloudItemsDeleteRequest(
  itemIds: (json['itemIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$CloudItemsDeleteRequestToJson(
  _CloudItemsDeleteRequest instance,
) => <String, dynamic>{'itemIds': instance.itemIds};

_CloudLinkCreateRequest _$CloudLinkCreateRequestFromJson(
  Map<String, dynamic> json,
) => _CloudLinkCreateRequest(
  linkUrl: json['linkUrl'] as String,
  itemName: json['itemName'] as String,
);

Map<String, dynamic> _$CloudLinkCreateRequestToJson(
  _CloudLinkCreateRequest instance,
) => <String, dynamic>{
  'linkUrl': instance.linkUrl,
  'itemName': instance.itemName,
};
