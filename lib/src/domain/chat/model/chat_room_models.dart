import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_models.freezed.dart';
part 'chat_room_models.g.dart';

enum ChatRoomType {
  direct,
  group;

  static ChatRoomType fromParticipantCount(int participantCount) {
    return participantCount <= 2 ? ChatRoomType.direct : ChatRoomType.group;
  }
}

@freezed
abstract class ChatRoomListResponse with _$ChatRoomListResponse {
  const factory ChatRoomListResponse({
    required bool success,
    required int status,
    String? message,
    required ChatRoomListData data,
  }) = _ChatRoomListResponse;

  factory ChatRoomListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListResponseFromJson(json);
}

@freezed
abstract class ChatRoomListData with _$ChatRoomListData {
  const factory ChatRoomListData({
    @Default(<ChatRoomSummary>[]) List<ChatRoomSummary> chatroomList,
  }) = _ChatRoomListData;

  factory ChatRoomListData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListDataFromJson(json);
}

@freezed
abstract class ChatRoomSummary with _$ChatRoomSummary {
  const factory ChatRoomSummary({
    required int chatId,
    required String roomName,
    String? lastMessage,
    DateTime? lastMessageTime,
    @Default(0) int unreadCount,
    @Default(<String>[]) List<String> profileImage,
    required int participantCount,
  }) = _ChatRoomSummary;

  factory ChatRoomSummary.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomSummaryFromJson(json);
}

@freezed
abstract class ChatRoomCreateRequest with _$ChatRoomCreateRequest {
  const factory ChatRoomCreateRequest({
    required String roomName,
    required List<int> participantIds,
    required String firstMessageContent,
  }) = _ChatRoomCreateRequest;

  factory ChatRoomCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomCreateRequestFromJson(json);
}

@freezed
abstract class ChatRoomCreateResponse with _$ChatRoomCreateResponse {
  const factory ChatRoomCreateResponse({
    required bool success,
    required int status,
    String? message,
    required ChatRoomCreateData data,
  }) = _ChatRoomCreateResponse;

  factory ChatRoomCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomCreateResponseFromJson(json);
}

@freezed
abstract class ChatRoomCreateData with _$ChatRoomCreateData {
  const factory ChatRoomCreateData({
    required int chatId,
    required String roomName,
    required DateTime createdAt,
  }) = _ChatRoomCreateData;

  factory ChatRoomCreateData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomCreateDataFromJson(json);
}

@freezed
abstract class ChatRoomUpdateRequest with _$ChatRoomUpdateRequest {
  const factory ChatRoomUpdateRequest({required String roomName}) =
      _ChatRoomUpdateRequest;

  factory ChatRoomUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomUpdateRequestFromJson(json);
}

@freezed
abstract class ChatRoomUpdateData with _$ChatRoomUpdateData {
  const factory ChatRoomUpdateData({
    required int chatId,
    required String roomName,
    required DateTime updatedAt,
  }) = _ChatRoomUpdateData;

  factory ChatRoomUpdateData.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomUpdateDataFromJson(json);
}
