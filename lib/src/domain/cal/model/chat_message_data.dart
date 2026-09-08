import 'package:flutter/foundation.dart';

enum ChatRoomType { direct, group }

@immutable
class ChatMemberViewData {
  const ChatMemberViewData({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.isMe = false,
  });

  final String id;
  final String name;
  final String? profileImageUrl;
  final bool isMe;
}

@immutable
class ChatMessageViewData {
  const ChatMessageViewData({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timeText,
    required this.isMine,
    this.senderProfileImageUrl,
    this.separatorTextBefore,
    this.readBy = const [],
  });

  final String id;

  final String senderId;
  final String senderName;
  final String? senderProfileImageUrl;

  final String content;
  final String timeText;
  final bool isMine;

  /// 이 메시지 앞에 표시할 시간 구분선
  ///
  /// 예: 오후 7:25
  final String? separatorTextBefore;

  /// 현재 메시지를 읽은 상대방 목록
  ///
  /// 본인은 포함하지 않습니다.
  final List<ChatMemberViewData> readBy;

  ChatMessageViewData copyWith({
    String? content,
    String? timeText,
    List<ChatMemberViewData>? readBy,
  }) {
    return ChatMessageViewData(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderProfileImageUrl: senderProfileImageUrl,
      content: content ?? this.content,
      timeText: timeText ?? this.timeText,
      isMine: isMine,
      separatorTextBefore: separatorTextBefore,
      readBy: readBy ?? this.readBy,
    );
  }

  /// 기존 목록을 직접 수정하지 않고 새로운 읽음 목록을 반환합니다.
  ///
  /// 읽은 순서대로 뒤에 추가되기 때문에 UI에서는 새 프로필이
  /// 기존 프로필의 왼쪽에 추가됩니다.
  ChatMessageViewData addReader(ChatMemberViewData reader) {
    if (reader.isMe) {
      return this;
    }

    final alreadyRead = readBy.any(
      (existingReader) => existingReader.id == reader.id,
    );

    if (alreadyRead) {
      return this;
    }

    return copyWith(readBy: List.unmodifiable([...readBy, reader]));
  }
}
