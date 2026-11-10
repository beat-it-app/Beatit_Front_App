import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_detail_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_room_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_member_page.dart';
import 'package:flutter/material.dart';

/// 서버의 directTo/targetId만으로 판단한다. 매핑되지 않는 경로는
/// 부정확한 상세 화면을 보여주는 대신 팀 홈으로 이동한다.
Widget? _detailFor(
  AlarmClickResponse target, {
  required String notificationTitle,
}) {
  final path = target.directTo;
  final id = target.targetId;
  if (path == '/teams/members') return const TeamMemberPage();
  if (path == '/archives') return const TeamArchiveListPage();
  if (path == null || id == null || id <= 0) return null;
  if (path.startsWith('/posts/notices/')) return PostDetailPage(noticeId: id);
  if (path.startsWith('/posts/polls/')) return PollDetailPage(pollId: id);
  if (path.startsWith('/posts/meetits/')) return MeetitDetailPage(meetitId: id);
  if (path.startsWith('/schedules/')) return CalDetailPage(scheduleId: id);
  if (path.startsWith('/archives/')) {
    return TeamArchiveDetailPage(archiveId: id);
  }
  if (path.startsWith('/chats/')) {
    return RoomChatPage(
      chatId: id,
      initialRoomName: notificationTitle,
      initialParticipantCount: 0,
    );
  }
  return null;
}

int _tabFor(String? path) {
  if (path == null) return 0;
  if (path.startsWith('/posts')) return 1;
  if (path.startsWith('/schedules')) return 2;
  if (path.startsWith('/chats')) return 3;
  return 0;
}

PostMainType _postTypeFor(String? path) {
  if (path?.startsWith('/posts/polls') ?? false) return PostMainType.poll;
  if (path?.startsWith('/posts/meetits') ?? false) return PostMainType.meetit;
  return PostMainType.notice;
}

/// 알림 목록과 포그라운드 배너가 같은 방식으로 대상 화면에 진입하도록 공유한다.
void navigateToAlarmTarget(
  NavigatorState rootNavigator,
  AlarmClickResponse target, {
  required String notificationTitle,
}) {
  final detail = _detailFor(target, notificationTitle: notificationTitle);

  // 상세에서 뒤로 갔을 때 알맞은 카테고리 목록이 보이도록 탭부터 설정한다.
  rootNavigator.pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) => MainShell(
        initialIndex: _tabFor(target.directTo),
        initialPostType: _postTypeFor(target.directTo),
      ),
    ),
    (route) => false,
  );

  if (detail == null) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!rootNavigator.mounted) return;

    // 아카이브는 하단 탭이 따로 없으므로 목록을 상세 아래에 둔다.
    if (detail is TeamArchiveDetailPage) {
      rootNavigator.push(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const TeamArchiveListPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
    rootNavigator.push(MaterialPageRoute(builder: (_) => detail));
  });
}
