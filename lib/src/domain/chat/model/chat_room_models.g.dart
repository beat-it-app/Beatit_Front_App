// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRoomListResponse _$ChatRoomListResponseFromJson(
  Map<String, dynamic> json,
) => _ChatRoomListResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String?,
  data: ChatRoomListData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatRoomListResponseToJson(
  _ChatRoomListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_ChatRoomListData _$ChatRoomListDataFromJson(Map<String, dynamic> json) =>
    _ChatRoomListData(
      chatroomList:
          (json['chatroomList'] as List<dynamic>?)
              ?.map((e) => ChatRoomSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChatRoomSummary>[],
    );

Map<String, dynamic> _$ChatRoomListDataToJson(_ChatRoomListData instance) =>
    <String, dynamic>{'chatroomList': instance.chatroomList};

_ChatRoomSummary _$ChatRoomSummaryFromJson(Map<String, dynamic> json) =>
    _ChatRoomSummary(
      chatId: (json['chatId'] as num).toInt(),
      roomName: json['roomName'] as String,
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] == null
          ? null
          : DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      profileImage:
          (json['profileImage'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      participantCount: (json['participantCount'] as num).toInt(),
    );

Map<String, dynamic> _$ChatRoomSummaryToJson(_ChatRoomSummary instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'roomName': instance.roomName,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'profileImage': instance.profileImage,
      'participantCount': instance.participantCount,
    };

_ChatRoomCreateRequest _$ChatRoomCreateRequestFromJson(
  Map<String, dynamic> json,
) => _ChatRoomCreateRequest(
  roomName: json['roomName'] as String,
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  firstMessageContent: json['firstMessageContent'] as String,
);

Map<String, dynamic> _$ChatRoomCreateRequestToJson(
  _ChatRoomCreateRequest instance,
) => <String, dynamic>{
  'roomName': instance.roomName,
  'participantIds': instance.participantIds,
  'firstMessageContent': instance.firstMessageContent,
};

_ChatRoomCreateResponse _$ChatRoomCreateResponseFromJson(
  Map<String, dynamic> json,
) => _ChatRoomCreateResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String?,
  data: ChatRoomCreateData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatRoomCreateResponseToJson(
  _ChatRoomCreateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_ChatRoomCreateData _$ChatRoomCreateDataFromJson(Map<String, dynamic> json) =>
    _ChatRoomCreateData(
      chatId: (json['chatId'] as num).toInt(),
      roomName: json['roomName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatRoomCreateDataToJson(_ChatRoomCreateData instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'roomName': instance.roomName,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_ChatRoomUpdateRequest _$ChatRoomUpdateRequestFromJson(
  Map<String, dynamic> json,
) => _ChatRoomUpdateRequest(roomName: json['roomName'] as String);

Map<String, dynamic> _$ChatRoomUpdateRequestToJson(
  _ChatRoomUpdateRequest instance,
) => <String, dynamic>{'roomName': instance.roomName};

_ChatRoomUpdateData _$ChatRoomUpdateDataFromJson(Map<String, dynamic> json) =>
    _ChatRoomUpdateData(
      chatId: (json['chatId'] as num).toInt(),
      roomName: json['roomName'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChatRoomUpdateDataToJson(_ChatRoomUpdateData instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'roomName': instance.roomName,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
