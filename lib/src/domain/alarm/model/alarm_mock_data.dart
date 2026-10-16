import 'alarm_notification.dart';

/// API 연동 전 화면 미리보기 전용 데이터. 실제 알림과 혼용하지 않는다.
List<AlarmNotification> alarmPreviewNotifications({
  required int currentTeamId,
  required String currentTeamName,
}) {
  final now = DateTime.now();
  final teamName = currentTeamName;
  final teamId = currentTeamId;
  return [
    AlarmNotification(
      id: 1,
      teamId: teamId,
      teamName: teamName,
      title: '$teamName 밴드 일정 설정',
      content: '명서님이 공지사항을 등록했습니다.',
      createdAt: now.subtract(const Duration(minutes: 1)),
      directTo: '/posts/notices',
    ),
    AlarmNotification(
      id: 2,
      teamId: teamId,
      teamName: teamName,
      title: '게시글 좋아요!',
      content: '권우혁님이 [중요]모임 안내 공지에 좋아요를 눌렀습니다.',
      createdAt: now.subtract(const Duration(minutes: 3)),
      directTo: '/posts/notices',
    ),
    AlarmNotification(
      id: 3,
      teamId: teamId + 1,
      teamName: '잘나가는밴드',
      title: '잘나가는밴드 공지사항 등록',
      content: '이기주님이 공지사항을 등록했습니다.',
      createdAt: now.subtract(const Duration(minutes: 3)),
      directTo: '/posts/notices',
    ),
    AlarmNotification(
      id: 4,
      teamId: teamId,
      teamName: teamName,
      title: '게시글 좋아요!',
      content: '송하은님이 [이번 밴드 공연 공지]에 좋아요를 눌렀습니다.',
      createdAt: now.subtract(const Duration(days: 1)),
      directTo: '/posts/notices',
    ),
    AlarmNotification(
      id: 5,
      teamId: teamId,
      teamName: teamName,
      title: '게시글 좋아요!',
      content: '송하은님이 [이번 밴드 공연 공지]에 좋아요를 눌렀습니다.',
      createdAt: now.subtract(const Duration(days: 11)),
      directTo: '/posts/notices',
      isRead: true,
    ),
    AlarmNotification(
      id: 6,
      teamId: teamId,
      teamName: teamName,
      title: '게시글 좋아요!',
      content: '송하은님이 [이번 밴드 공연 공지]에 좋아요를 눌렀습니다.',
      createdAt: now.subtract(const Duration(days: 11)),
      directTo: '/posts/notices',
      isRead: true,
    ),
  ];
}

