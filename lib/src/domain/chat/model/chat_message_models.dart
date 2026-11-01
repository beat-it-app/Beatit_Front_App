import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_models.freezed.dart';
part 'chat_message_models.g.dart';

enum ChatMessageType {
  @JsonValue('TEXT')
  text,
  @JsonValue('IMAGE')
  image,
  @JsonValue('VIDEO')
  video,
  @JsonValue('FILE')
  file,
  @JsonValue('SYSTEM')
  system,
  @JsonValue('UNKNOWN')
  unknown,
}

@freezed
abstract class ChatRoomDetailResponse with _$ChatRoomDetailResponse {
  const factory ChatRoomDetailResponse({
    required bool success,
    required int status,
    String? message,
    required ChatRoomDetailData data,
  }) = _ChatRoomDetailResponse;

  factory ChatRoomDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDetailResponseFromJson(json);
}

@freezed
abstract class ChatRoomDetailData with _$ChatRoomDetailData {
  const factory ChatRoomDetailData({
    required String chatroomName,
    required int participantCount,
    @Default(<ChatMessage>[]) List<ChatMessage> messages,
    required bool hasNext,
  }) = _ChatRoomDetailData;

  factory ChatRoomDetailData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDetailDataFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required int messageId,
    required int senderId,
    required String senderName,
    String? profileImageUrl,
    required String content,
    @JsonKey(unknownEnumValue: ChatMessageType.unknown)
    required ChatMessageType messageType,
    required DateTime createdAt,
    @JsonKey(name: 'isMine') required bool isMine,
    String? attachmentName,
    int? attachmentSizeBytes,
    String? attachmentMimeType,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
abstract class ChatMessageSendRequest with _$ChatMessageSendRequest {
  const factory ChatMessageSendRequest({
    required ChatMessageType messageType,
    String? content,
    String? storageKey,
  }) = _ChatMessageSendRequest;

  factory ChatMessageSendRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageSendRequestFromJson(json);
}

@freezed
abstract class ChatMessageSendData with _$ChatMessageSendData {
  const factory ChatMessageSendData({
    required int messageId,
    required int chatId,
    required int senderId,
    required String content,
    @JsonKey(unknownEnumValue: ChatMessageType.unknown)
    required ChatMessageType messageType,
    required DateTime createdAt,
  }) = _ChatMessageSendData;

  factory ChatMessageSendData.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageSendDataFromJson(json);
}
enum ChatPendingAttachmentStatus { uploading, failed }

@freezed
abstract class ChatPendingAttachment with _$ChatPendingAttachment {
  const factory ChatPendingAttachment({
    required String localId,
    required String filePath,
    required String fileName,
    required int fileSizeBytes,
    required ChatMessageType messageType,
    required DateTime createdAt,
    @Default(0) double progress,
    @Default(ChatPendingAttachmentStatus.uploading)
    ChatPendingAttachmentStatus status,
    String? errorMessage,
  }) = _ChatPendingAttachment;
}


/// 읽음 위치는 메시지 내용과 별도의 실시간 상태입니다.
/// Freezed 생성 코드를 수정하지 않고 기존 메시지 모델을 유지합니다.
class ChatReadMarker {
  const ChatReadMarker({
    required this.userId,
    required this.messageId,
    this.name = '',
    this.profileImageUrl,
  });

  final int userId;
  final int messageId;
  final String name;
  final String? profileImageUrl;

  ChatReadMarker atMessage(int nextMessageId) => ChatReadMarker(
    userId: userId,
    messageId: nextMessageId,
    name: name,
    profileImageUrl: profileImageUrl,
  );
}
