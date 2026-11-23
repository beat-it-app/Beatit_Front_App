/// FCM data.category는 백엔드 NotificationCategory enum 값이다.
/// Android의 알림 채널과 알림창 묶음(groupKey)에 같은 분류를 사용한다.
enum AlarmPushGroup {
  chat('beatit_chat_v1', '채팅', 'beatit.group.chat', 2100000001),
  post('beatit_post_v1', '게시물 · 공지', 'beatit.group.post', 2100000002),
  calendar('beatit_calendar_v1', '일정', 'beatit.group.calendar', 2100000003),
  team('beatit_team_v1', '팀 활동', 'beatit.group.team', 2100000004);

  const AlarmPushGroup(
    this.channelId,
    this.label,
    this.groupKey,
    this.summaryId,
  );

  final String channelId;
  final String label;
  final String groupKey;
  final int summaryId;

  /// 새 타입이 추가되어도 directTo를 보조 신호로 사용한다.
  /// 알 수 없는 알림은 팀 활동으로 표시하여 유실되지 않게 한다.
  static AlarmPushGroup fromData(Map<String, dynamic> data) {
    final category = (data['category'] ?? '').toString().toUpperCase();
    final type = (data['type'] ?? '').toString().toUpperCase();
    final path = (data['directTo'] ?? '').toString().toLowerCase();

    if (category == 'CHAT' || type == 'CHAT_MESSAGE' ||
        path.startsWith('/chats/')) {
      return AlarmPushGroup.chat;
    }
    if (category == 'CALENDAR' || type.startsWith('SCHEDULE_') ||
        path.startsWith('/schedules/')) {
      return AlarmPushGroup.calendar;
    }
    if (category == 'NOTICE' || category == 'POLL' ||
        category == 'MEETIT' || category == 'POST' ||
        type.startsWith('NOTICE_') || type.startsWith('POLL_') ||
        type.startsWith('MEETIT_') || type.startsWith('COMMENT_') ||
        path.startsWith('/posts/')) {
      return AlarmPushGroup.post;
    }
    return AlarmPushGroup.team;
  }
}
