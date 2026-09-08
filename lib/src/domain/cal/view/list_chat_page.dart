import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/domain/cal/model/chat_message_data.dart';
import 'package:beatit_front_app/src/domain/cal/widget/chat_list_item.dart';
import 'package:flutter/material.dart';

import 'room_chat_page.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  static const ChatMemberViewData _me = ChatMemberViewData(
    id: 'user-me',
    name: '나',
    profileImageUrl: 'https://i.pravatar.cc/150?img=5',
    isMe: true,
  );

  static const ChatMemberViewData _kwonWooHyuk = ChatMemberViewData(
    id: 'user-kwon-woo-hyuk',
    name: '권우혁',
    profileImageUrl: 'https://i.pravatar.cc/150?img=11',
  );

  static const ChatMemberViewData _parkSoYeon = ChatMemberViewData(
    id: 'user-park-so-yeon',
    name: '박소연',
    profileImageUrl: 'https://i.pravatar.cc/150?img=32',
  );

  static const ChatMemberViewData _leeHyeBin = ChatMemberViewData(
    id: 'user-lee-hye-bin',
    name: '이혜빈',
    profileImageUrl: 'https://i.pravatar.cc/150?img=45',
  );

  static const ChatMemberViewData _jeonJuHyeon = ChatMemberViewData(
    id: 'user-jeon-ju-hyeon',
    name: '전주현',
    profileImageUrl: 'https://i.pravatar.cc/150?img=47',
  );

  static const ChatMemberViewData _noYoungSeo = ChatMemberViewData(
    id: 'user-no-young-seo',
    name: '노영서',
    profileImageUrl: 'https://i.pravatar.cc/150?img=40',
  );

  static const ChatMemberViewData _leeGiJu = ChatMemberViewData(
    id: 'user-lee-gi-ju',
    name: '이기주',
    profileImageUrl: 'https://i.pravatar.cc/150?img=36',
  );

  static const ChatMemberViewData _songHaEun = ChatMemberViewData(
    id: 'user-song-ha-eun',
    name: '송하은',
    profileImageUrl: 'https://i.pravatar.cc/150?img=12',
  );

  static const List<_DummyChatRoom> _dummyChatRooms = [
    _DummyChatRoom(
      id: 'room-direct-kwon',
      roomType: ChatRoomType.direct,
      roomName: '권우혁',
      dateLabel: '2026년 5월 6일 수요일',
      lastMessage: '알겠어유',
      timeText: '3분 전',
      unreadCount: 0,
      members: [_kwonWooHyuk, _me],
      messages: [
        ChatMessageViewData(
          id: 'kwon-message-1',
          senderId: 'user-kwon-woo-hyuk',
          senderName: '권우혁',
          senderProfileImageUrl: 'https://i.pravatar.cc/150?img=11',
          content: '내일 공연 있었나',
          timeText: '23:48',
          isMine: false,
        ),
        ChatMessageViewData(
          id: 'kwon-message-2',
          senderId: 'user-me',
          senderName: '나',
          content: '내가 아까 공지 올렸잖아..\n안 봤지!!!!!',
          timeText: '23:48',
          isMine: true,
          readBy: [_kwonWooHyuk],
        ),
        ChatMessageViewData(
          id: 'kwon-message-3',
          senderId: 'user-kwon-woo-hyuk',
          senderName: '권우혁',
          senderProfileImageUrl: 'https://i.pravatar.cc/150?img=11',
          content: '알겠어유',
          timeText: '23:50',
          isMine: false,
          separatorTextBefore: '오후 11:50',
        ),
      ],
    ),
    _DummyChatRoom(
      id: 'room-direct-park',
      roomType: ChatRoomType.direct,
      roomName: '박소연',
      dateLabel: '2026년 5월 6일 수요일',
      lastMessage: '한번 확인해주세요',
      timeText: '50분 전',
      unreadCount: 1,
      members: [_parkSoYeon, _me],
      messages: [
        ChatMessageViewData(
          id: 'park-message-1',
          senderId: 'user-park-so-yeon',
          senderName: '박소연',
          senderProfileImageUrl: 'https://i.pravatar.cc/150?img=32',
          content: '한번 확인해주세요',
          timeText: '18:25',
          isMine: false,
        ),
      ],
    ),
    _DummyChatRoom(
      id: 'room-direct-hye-bin',
      roomType: ChatRoomType.direct,
      roomName: '이혜빈',
      dateLabel: '2026년 5월 6일 수요일',
      lastMessage: '네-!! 이번 공지 확인했어요! 다음 한번 제가 공지 작성할게요.',
      timeText: '오후 17:45',
      unreadCount: 0,
      members: [_leeHyeBin, _me],
      messages: [],
    ),
    _DummyChatRoom(
      id: 'room-direct-jeon',
      roomType: ChatRoomType.direct,
      roomName: '전주현',
      dateLabel: '2026년 5월 6일 수요일',
      lastMessage: '넵 그렇게 할게여',
      timeText: '2026.05.06',
      unreadCount: 0,
      members: [_jeonJuHyeon, _me],
      messages: [
        ChatMessageViewData(
          id: 'jeon-message-1',
          senderId: 'user-me',
          senderName: '나',
          content: '다음 연습 시간은 오후 7시로 하면 될 것 같아요.',
          timeText: '16:08',
          isMine: true,
          readBy: [_jeonJuHyeon],
        ),
        ChatMessageViewData(
          id: 'jeon-message-2',
          senderId: 'user-jeon-ju-hyeon',
          senderName: '전주현',
          senderProfileImageUrl: 'https://i.pravatar.cc/150?img=47',
          content: '넵 그렇게 할게여',
          timeText: '16:10',
          isMine: false,
        ),
      ],
    ),
    _DummyChatRoom(
      id: 'room-group-band',
      roomType: ChatRoomType.group,
      roomName: '전주현, 노영서, 이기주, 송하은 4',
      dateLabel: '2026년 5월 6일 수요일',
      lastMessage: '하이하이',
      timeText: '2026.05.06',
      unreadCount: 0,
      members: [_jeonJuHyeon, _noYoungSeo, _leeGiJu, _songHaEun, _me],
      messages: [
        ChatMessageViewData(
          id: 'group-message-1',
          senderId: 'user-jeon-ju-hyeon',
          senderName: '전주현',
          senderProfileImageUrl: 'https://i.pravatar.cc/150?img=47',
          content: '내일 공연 있었나',
          timeText: '23:48',
          isMine: false,
        ),
        ChatMessageViewData(
          id: 'group-message-2',
          senderId: 'user-me',
          senderName: '나',
          content: '내가 아까 공지 올렸잖아..\n안 봤지!!!!!',
          timeText: '23:48',
          isMine: true,
          readBy: [_jeonJuHyeon, _noYoungSeo, _leeGiJu],
        ),
        ChatMessageViewData(
          id: 'group-message-3',
          senderId: 'user-no-young-seo',
          senderName: '노영서',
          senderProfileImageUrl: 'https://i.pravatar.cc/150?img=40',
          content: '하이하이',
          timeText: '23:50',
          isMine: false,
          separatorTextBefore: '오후 11:50',
        ),
      ],
    ),
  ];

  final List<_DummyChatRoom> _chatRooms = List<_DummyChatRoom>.of(
    _dummyChatRooms,
  );

  void _openChatRoom(int index) {
    final selectedRoom = _chatRooms[index];

    if (selectedRoom.unreadCount > 0) {
      setState(() {
        _chatRooms[index] = selectedRoom.copyWith(unreadCount: 0);
      });
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return RoomChatPage(
            roomType: selectedRoom.roomType,
            roomTitle: selectedRoom.roomName,
            dateLabel: selectedRoom.dateLabel,
            members: selectedRoom.members,
            messages: selectedRoom.messages,
            onSendMessage: (message) {
              debugPrint('[${selectedRoom.id}] 메시지 전송: $message');
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppTwoAppBar.add(title: ''),
      body: SafeArea(
        child: _chatRooms.isEmpty
            ? const _EmptyChatList()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x8,
                  AppSpacing.x20,
                  AppSpacing.x16,
                  AppSpacing.x24,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: _chatRooms.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: AppSpacing.x12);
                },
                itemBuilder: (context, index) {
                  final chatRoom = _chatRooms[index];

                  return ChatListItem(
                    roomName: chatRoom.roomName,
                    lastMessage: chatRoom.lastMessage,
                    timeText: chatRoom.timeText,
                    unreadCount: chatRoom.unreadCount,
                    profileImageUrls: chatRoom.profileImageUrls,
                    onTap: () {
                      _openChatRoom(index);
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _EmptyChatList extends StatelessWidget {
  const _EmptyChatList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '채팅 목록이 없습니다.',
              textAlign: TextAlign.center,
              style: FontStyles.bold22.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x10),
            Text(
              '멤버 목록을 눌러 채팅을 시작해보세요.',
              textAlign: TextAlign.center,
              style: FontStyles.med16.copyWith(color: context.grays.gray5),
            ),
          ],
        ),
      ),
    );
  }
}

/// 채팅 목록 화면 구현을 확인하기 위한 임시 채팅방 모델입니다.
///
/// ChatRoomType, ChatMemberViewData, ChatMessageViewData는
/// 기존 chat_message_view_data.dart의 모델을 그대로 사용합니다.
class _DummyChatRoom {
  const _DummyChatRoom({
    required this.id,
    required this.roomType,
    required this.roomName,
    required this.dateLabel,
    required this.lastMessage,
    required this.timeText,
    required this.unreadCount,
    required this.members,
    required this.messages,
  });

  final String id;
  final ChatRoomType roomType;

  final String roomName;
  final String dateLabel;

  final String lastMessage;
  final String timeText;
  final int unreadCount;

  final List<ChatMemberViewData> members;
  final List<ChatMessageViewData> messages;

  /// 목록의 프로필에는 본인 프로필을 제외합니다.
  List<String> get profileImageUrls {
    return members
        .where((member) => !member.isMe)
        .map((member) => member.profileImageUrl)
        .whereType<String>()
        .where((url) => url.trim().isNotEmpty)
        .toList(growable: false);
  }

  _DummyChatRoom copyWith({int? unreadCount}) {
    return _DummyChatRoom(
      id: id,
      roomType: roomType,
      roomName: roomName,
      dateLabel: dateLabel,
      lastMessage: lastMessage,
      timeText: timeText,
      unreadCount: unreadCount ?? this.unreadCount,
      members: members,
      messages: messages,
    );
  }
}
