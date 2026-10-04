// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRoomDetailResponse _$ChatRoomDetailResponseFromJson(
  Map<String, dynamic> json,
) => _ChatRoomDetailResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String?,
  data: ChatRoomDetailData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatRoomDetailResponseToJson(
  _ChatRoomDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_ChatRoomDetailData _$ChatRoomDetailDataFromJson(Map<String, dynamic> json) =>
    _ChatRoomDetailData(
      chatroomName: json['chatroomName'] as String,
      participantCount: (json['participantCount'] as num).toInt(),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChatMessage>[],
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$ChatRoomDetailDataToJson(_ChatRoomDetailData instance) =>
    <String, dynamic>{
      'chatroomName': instance.chatroomName,
      'participantCount': instance.participantCount,
      'messages': instance.messages,
      'hasNext': instance.hasNext,
    };

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  messageId: (json['messageId'] as num).toInt(),
  senderId: (json['senderId'] as num).toInt(),
  senderName: json['senderName'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  content: json['content'] as String,
  messageType: $enumDecode(
    _$ChatMessageTypeEnumMap,
    json['messageType'],
    unknownValue: ChatMessageType.unknown,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isMine: json['mine'] as bool,
  attachmentName: json['attachmentName'] as String?,
  attachmentSizeBytes: (json['attachmentSizeBytes'] as num?)?.toInt(),
  attachmentMimeType: json['attachmentMimeType'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'profileImageUrl': instance.profileImageUrl,
      'content': instance.content,
      'messageType': _$ChatMessageTypeEnumMap[instance.messageType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'mine': instance.isMine,
      'attachmentName': instance.attachmentName,
      'attachmentSizeBytes': instance.attachmentSizeBytes,
      'attachmentMimeType': instance.attachmentMimeType,
    };

const _$ChatMessageTypeEnumMap = {
  ChatMessageType.text: 'TEXT',
  ChatMessageType.image: 'IMAGE',
  ChatMessageType.video: 'VIDEO',
  ChatMessageType.file: 'FILE',
  ChatMessageType.system: 'SYSTEM',
  ChatMessageType.unknown: 'UNKNOWN',
};

_ChatMessageSendRequest _$ChatMessageSendRequestFromJson(
  Map<String, dynamic> json,
) => _ChatMessageSendRequest(
  messageType: $enumDecode(_$ChatMessageTypeEnumMap, json['messageType']),
  content: json['content'] as String?,
  storageKey: json['storageKey'] as String?,
);

Map<String, dynamic> _$ChatMessageSendRequestToJson(
  _ChatMessageSendRequest instance,
) => <String, dynamic>{
  'messageType': _$ChatMessageTypeEnumMap[instance.messageType]!,
  'content': instance.content,
  'storageKey': instance.storageKey,
};

_ChatMessageSendData _$ChatMessageSendDataFromJson(Map<String, dynamic> json) =>
    _ChatMessageSendData(
      messageId: (json['messageId'] as num).toInt(),
      chatId: (json['chatId'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      content: json['content'] as String,
      messageType: $enumDecode(
        _$ChatMessageTypeEnumMap,
        json['messageType'],
        unknownValue: ChatMessageType.unknown,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatMessageSendDataToJson(
  _ChatMessageSendData instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'chatId': instance.chatId,
  'senderId': instance.senderId,
  'content': instance.content,
  'messageType': _$ChatMessageTypeEnumMap[instance.messageType]!,
  'createdAt': instance.createdAt.toIso8601String(),
};
