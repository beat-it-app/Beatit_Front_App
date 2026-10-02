import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/chat/api/chat_api_exception.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_message_models.dart';
import 'package:beatit_front_app/src/domain/chat/model/chat_room_models.dart';

class ChatApi {
  ChatApi(this._dio);

  final Dio _dio;

  static const String _chatRoomsPath = '/chatrooms';

  Future<ChatRoomListData> getChatRooms() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(_chatRoomsPath);
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '채팅방 목록을 불러오지 못했습니다.',
      );
      final data = _requireDataMap(body, '채팅방 목록 응답 형식이 올바르지 않습니다.');
      final rawRooms = data['chatroomList'];

      if (rawRooms is! List) {
        throw const ChatApiException(
          message: '채팅방 목록 응답 형식이 올바르지 않습니다.',
        );
      }

      final rooms = rawRooms
          .whereType<Map>()
          .map((rawRoom) {
            final room = Map<String, dynamic>.from(rawRoom);
            return ChatRoomSummary(
              chatId: _requireInt(room['chatId'], fieldName: 'chatId'),
              roomName: room['roomName']?.toString() ?? '',
              lastMessage: room['lastMessage']?.toString(),
              lastMessageTime: _dateTimeOrNull(room['lastMessageTime']),
              unreadCount: _intOrDefault(room['unreadCount']),
              profileImage: _stringList(room['profileImage']),
              participantCount: _intOrDefault(room['participantCount']),
            );
          })
          .toList(growable: false);

      return ChatRoomListData(chatroomList: rooms);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on ChatApiException {
      rethrow;
    } catch (_) {
      throw const ChatApiException(
        message: '채팅방 목록 응답을 처리하지 못했습니다.',
      );
    }
  }

  Future<ChatRoomDetailData> getChatRoomDetails({
    required int chatId,
    int page = 0,
    int size = 30,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_chatRoomsPath/$chatId/messages',
        queryParameters: {'page': page, 'size': size},
      );
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '채팅 내용을 불러오지 못했습니다.',
      );
      final data = _requireDataMap(body, '채팅 상세 응답 형식이 올바르지 않습니다.');
      final rawMessages = data['messages'];

      if (rawMessages is! List) {
        throw const ChatApiException(
          message: '채팅 메시지 응답 형식이 올바르지 않습니다.',
        );
      }

      final messages = rawMessages
          .whereType<Map>()
          .map((rawMessage) {
            final message = Map<String, dynamic>.from(rawMessage);
            return ChatMessage(
              messageId: _requireInt(
                message['messageId'],
                fieldName: 'messageId',
              ),
              senderId: _requireInt(message['senderId'], fieldName: 'senderId'),
              senderName: message['senderName']?.toString() ?? '알 수 없는 사용자',
              profileImageUrl: message['profileImageUrl']?.toString(),
              content: message['content']?.toString() ?? '',
              messageType: _messageType(message['messageType']),
              createdAt: _requireDateTime(
                message['createdAt'],
                fieldName: 'createdAt',
              ),
              isMine: _boolOrDefault(message['mine'] ?? message['isMine']),
            );
          })
          .toList(growable: false);

      return ChatRoomDetailData(
        chatroomName:
            data['chatroomName']?.toString() ??
            data['chatRoomName']?.toString() ??
            '',
        participantCount: _intOrDefault(data['participantCount']),
        messages: messages,
        hasNext: _boolOrDefault(data['hasNext']),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on ChatApiException {
      rethrow;
    } catch (_) {
      throw const ChatApiException(
        message: '채팅 상세 응답을 처리하지 못했습니다.',
      );
    }
  }

  Future<ChatRoomCreateData> createChatRoom(
    ChatRoomCreateRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _chatRoomsPath,
        data: request.toJson(),
      );
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '채팅방을 생성하지 못했습니다.',
      );
      final data = _requireDataMap(body, '채팅방 생성 응답 형식이 올바르지 않습니다.');

      return ChatRoomCreateData(
        chatId: _requireInt(data['chatId'], fieldName: 'chatId'),
        roomName: data['roomName']?.toString() ?? request.roomName,
        createdAt: _requireDateTime(data['createdAt'], fieldName: 'createdAt'),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on ChatApiException {
      rethrow;
    } catch (_) {
      throw const ChatApiException(
        message: '채팅방 생성 응답을 처리하지 못했습니다.',
      );
    }
  }

  Future<ChatMessageSendData> sendTextMessage({
    required int chatId,
    required String content,
  }) {
    return _sendMessage(
      chatId: chatId,
      request: ChatMessageSendRequest(
        messageType: ChatMessageType.text,
        content: content,
      ),
    );
  }

  Future<ChatMessageSendData> sendAttachmentMessage({
    required int chatId,
    required ChatMessageType messageType,
    required String filePath,
    required String fileName,
    ProgressCallback? onSendProgress,
  }) {
    return _sendMessage(
      chatId: chatId,
      request: ChatMessageSendRequest(messageType: messageType),
      filePath: filePath,
      fileName: fileName,
      onSendProgress: onSendProgress,
    );
  }

  Future<ChatRoomUpdateData> updateChatRoomName({
    required int chatId,
    required String roomName,
  }) async {
    try {
      final request = ChatRoomUpdateRequest(roomName: roomName);
      final response = await _dio.patch<Map<String, dynamic>>(
        '$_chatRoomsPath/$chatId',
        data: request.toJson(),
      );
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '채팅방 이름을 수정하지 못했습니다.',
      );
      final data = _requireDataMap(body, '채팅방 이름 수정 응답 형식이 올바르지 않습니다.');

      return ChatRoomUpdateData(
        chatId: _requireInt(data['chatId'], fieldName: 'chatId'),
        roomName: data['roomName']?.toString() ?? roomName,
        updatedAt: _requireDateTime(data['updatedAt'], fieldName: 'updatedAt'),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> leaveChatRoom({required int chatId}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '$_chatRoomsPath/$chatId/leave',
      );
      _requireSuccessBody(
        response: response,
        fallbackMessage: '채팅방을 나가지 못했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<ChatMessageSendData> _sendMessage({
    required int chatId,
    required ChatMessageSendRequest request,
    String? filePath,
    String? fileName,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData();
      formData.files.add(
        MapEntry(
          'request',
          MultipartFile.fromBytes(
            utf8.encode(jsonEncode(request.toJson())),
            filename: 'request.json',
            contentType: DioMediaType.parse(Headers.jsonContentType),
          ),
        ),
      );

      if (filePath != null) {
        formData.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              filePath,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '$_chatRoomsPath/$chatId/messages',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
        onSendProgress: onSendProgress,
      );
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '메시지를 전송하지 못했습니다.',
      );
      final data = _requireDataMap(body, '메시지 전송 응답 형식이 올바르지 않습니다.');

      return ChatMessageSendData(
        messageId: _requireInt(data['messageId'], fieldName: 'messageId'),
        chatId: _requireInt(data['chatId'], fieldName: 'chatId'),
        senderId: _requireInt(data['senderId'], fieldName: 'senderId'),
        content: data['content']?.toString() ?? '',
        messageType: _messageType(data['messageType']),
        createdAt: _requireDateTime(data['createdAt'], fieldName: 'createdAt'),
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on ChatApiException {
      rethrow;
    } catch (_) {
      throw const ChatApiException(message: '메시지 전송 응답을 처리하지 못했습니다.');
    }
  }

  Map<String, dynamic> _requireSuccessBody({
    required Response<Map<String, dynamic>> response,
    required String fallbackMessage,
  }) {
    final body = response.data;

    if (body == null) {
      throw const ChatApiException(message: '서버 응답이 비어 있습니다.');
    }

    if (body['success'] != true) {
      throw ChatApiException(
        message: body['message']?.toString() ?? fallbackMessage,
        code: body['status']?.toString(),
        statusCode: response.statusCode,
      );
    }

    return body;
  }

  Map<String, dynamic> _requireDataMap(
    Map<String, dynamic> body,
    String errorMessage,
  ) {
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw ChatApiException(message: errorMessage);
  }

  int _requireInt(dynamic value, {required String fieldName}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed != null) return parsed;
    throw ChatApiException(message: '$fieldName 값을 확인할 수 없습니다.');
  }

  int _intOrDefault(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  bool _boolOrDefault(dynamic value, [bool fallback = false]) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().trim().toLowerCase();
    if (normalized == 'true') return true;
    if (normalized == 'false') return false;
    return fallback;
  }

  DateTime _requireDateTime(dynamic value, {required String fieldName}) {
    final parsed = _dateTimeOrNull(value);
    if (parsed != null) return parsed;
    throw ChatApiException(message: '$fieldName 값을 확인할 수 없습니다.');
  }

  DateTime? _dateTimeOrNull(dynamic value) {
    if (value is DateTime) return value;
    final raw = value?.toString();
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  List<String> _stringList(dynamic value) {
    if (value is! List) return const <String>[];
    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList(growable: false);
  }

  ChatMessageType _messageType(dynamic value) {
    return switch (value?.toString().toUpperCase()) {
      'TEXT' => ChatMessageType.text,
      'IMAGE' => ChatMessageType.image,
      'VIDEO' => ChatMessageType.video,
      'FILE' => ChatMessageType.file,
      'SYSTEM' => ChatMessageType.system,
      _ => ChatMessageType.unknown,
    };
  }

  ChatApiException _mapDioException(DioException error) {
    final rawData = error.response?.data;
    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);
      return ChatApiException(
        message: data['message']?.toString() ?? '요청에 실패했습니다.',
        code: data['status']?.toString(),
        statusCode: error.response?.statusCode,
      );
    }

    return ChatApiException(
      message: '서버와 통신할 수 없습니다.',
      statusCode: error.response?.statusCode,
    );
  }
}
