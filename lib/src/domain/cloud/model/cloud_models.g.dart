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

_CloudFileDetailResponse _$CloudFileDetailResponseFromJson(
  Map<String, dynamic> json,
) => _CloudFileDetailResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CloudFileDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CloudFileDetailResponseToJson(
  _CloudFileDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_CloudFileDetail _$CloudFileDetailFromJson(Map<String, dynamic> json) =>
    _CloudFileDetail(
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      fileUrl: json['fileUrl'] as String,
    );

Map<String, dynamic> _$CloudFileDetailToJson(_CloudFileDetail instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'fileUrl': instance.fileUrl,
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

_CloudStorageResponse _$CloudStorageResponseFromJson(
  Map<String, dynamic> json,
) => _CloudStorageResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: CloudStorageData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CloudStorageResponseToJson(
  _CloudStorageResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_CloudStorageData _$CloudStorageDataFromJson(Map<String, dynamic> json) =>
    _CloudStorageData(
      teamName: json['teamName'] as String,
      usagePercentage: (json['usagePercentage'] as num).toInt(),
      totalStorageBytes: (json['totalStorageBytes'] as num).toInt(),
      totalStorageDisplay: json['totalStorageDisplay'] as String,
      usedStorageBytes: (json['usedStorageBytes'] as num).toInt(),
      usedStorageDisplay: json['usedStorageDisplay'] as String,
      remainingStorageBytes: (json['remainingStorageBytes'] as num).toInt(),
      remainingStorageDisplay: json['remainingStorageDisplay'] as String,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => CloudStorageCategoryUsage.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const <CloudStorageCategoryUsage>[],
    );

Map<String, dynamic> _$CloudStorageDataToJson(_CloudStorageData instance) =>
    <String, dynamic>{
      'teamName': instance.teamName,
      'usagePercentage': instance.usagePercentage,
      'totalStorageBytes': instance.totalStorageBytes,
      'totalStorageDisplay': instance.totalStorageDisplay,
      'usedStorageBytes': instance.usedStorageBytes,
      'usedStorageDisplay': instance.usedStorageDisplay,
      'remainingStorageBytes': instance.remainingStorageBytes,
      'remainingStorageDisplay': instance.remainingStorageDisplay,
      'categories': instance.categories,
    };

_CloudStorageCategoryUsage _$CloudStorageCategoryUsageFromJson(
  Map<String, dynamic> json,
) => _CloudStorageCategoryUsage(
  category: json['category'] as String,
  bytes: (json['bytes'] as num).toInt(),
  displaySize: json['displaySize'] as String,
);

Map<String, dynamic> _$CloudStorageCategoryUsageToJson(
  _CloudStorageCategoryUsage instance,
) => <String, dynamic>{
  'category': instance.category,
  'bytes': instance.bytes,
  'displaySize': instance.displaySize,
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

_CloudItemsMoveRequest _$CloudItemsMoveRequestFromJson(
  Map<String, dynamic> json,
) => _CloudItemsMoveRequest(
  itemIds: (json['itemIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  targetFolderId: (json['targetFolderId'] as num?)?.toInt(),
);

Map<String, dynamic> _$CloudItemsMoveRequestToJson(
  _CloudItemsMoveRequest instance,
) => <String, dynamic>{
  'itemIds': instance.itemIds,
  'targetFolderId': instance.targetFolderId,
};

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
