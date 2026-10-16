import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_mock_data.dart';
import 'package:beatit_front_app/src/domain/alarm/view/alarm_loading_page.dart';
import 'package:beatit_front_app/src/domain/alarm/view/alarm_setting_page.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/alarm_item.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_detail_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_room_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_member_page.dart';
import 'package:flutter/material.dart';

/// 알림 목록 UI. API 연동 전이므로 실제 팀 전환이나 서버 읽음 처리는 실행하지 않는다.
/// [onSwitchTeam]은 추후 알림 API 연결 단계에 팀 선택 성공/실패 동작을 주입할 수 있다.
class AlarmMainPage extends StatefulWidget {
  const AlarmMainPage({
    super.key,
    this.currentTeamId = 1,
    this.currentTeamName = '일사병 밴드',
    this.notifications,
    this.onSwitchTeam,
  });

  /// 기본값은 독립적인 화면 미리보기를 위한 샘플 팀이다.
  final int currentTeamId;
  final String currentTeamName;
  final List<AlarmNotification>? notifications;
  final Future<bool> Function(int teamId, String teamName)? onSwitchTeam;

  @override
  State<AlarmMainPage> createState() => _AlarmMainPageState();
}

class _AlarmMainPageState extends State<AlarmMainPage> {
  late List<AlarmNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.of(
      widget.notifications ?? alarmPreviewNotifications(
        currentTeamId: widget.currentTeamId,
        currentTeamName: widget.currentTeamName,
      ),
    );
  }


  // 현재 단계에서는 로컬 목록에만 표시한다. 서버 PATCH는 호출하지 않는다.
  void _markAllAsRead() {
    setState(() {
      _notifications = [
        for (final item in _notifications)
          item.teamId == widget.currentTeamId
              ? item.copyWith(isRead: true)
              : item,
      ];
    });
  }

  Future<void> _onNotificationTap(AlarmNotification item) async {
    setState(() {
      _notifications = [
        for (final notification in _notifications)
          notification.id == item.id
              ? notification.copyWith(isRead: true)
              : notification,
      ];
    });

    if (item.teamId != widget.currentTeamId) {
      final switched = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => AlarmLoadingPage(
            teamId: item.teamId,
            teamName: item.teamName,
            onSwitchTeam: widget.onSwitchTeam == null
                ? null
                : () => widget.onSwitchTeam!(item.teamId, item.teamName),
          ),
        ),
      );

      if (!mounted) return;
      if (switched != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('팀 전환은 API 연동 후 이용할 수 있어요.')),
        );
        return;
      }

      _openDestination(item, resetToHome: true);
      return;
    }

    _openDestination(item, resetToHome: false);
  }

  /// 대상 화면은 백엔드의 directTo/targetId를 기준으로 판별한다.
  /// 대상 ID가 없으면 해당 네비게이션 탭으로 이동한다.
  int _tabIndex(String? path) {
    if (path == null) return 0;
    if (path.startsWith('/posts/')) return 1;
    if (path.startsWith('/schedules')) return 2;
    if (path.startsWith('/chats') || path.startsWith('/chat')) return 3;
    return 0;
  }

  Widget? _detailPage(AlarmNotification item) {
    final path = item.directTo;
    final id = item.targetId;
    if (path == '/teams/members') return const TeamMemberPage();
    if (path == '/archives') return const TeamArchiveListPage();
    if (id == null || id <= 0 || path == null) return null;

    if (path.startsWith('/posts/notices/')) {
      return PostDetailPage(noticeId: id);
    }
    if (path.startsWith('/posts/polls/')) {
      return PollDetailPage(pollId: id);
    }
    if (path.startsWith('/posts/meetits/') || path.startsWith('/meetits/')) {
      return MeetitDetailPage(meetitId: id);
    }
    if (path.startsWith('/schedules/')) {
      return CalDetailPage(scheduleId: id);
    }
    if (path.startsWith('/archives/')) {
      return TeamArchiveDetailPage(archiveId: id);
    }
    if (path.startsWith('/chats/')) {
      return RoomChatPage(
        chatId: id,
        initialRoomName: item.title,
        initialParticipantCount: 0,
      );
    }
    return null;
  }

  void _openDestination(AlarmNotification item, {required bool resetToHome}) {
    final navigator = Navigator.of(context, rootNavigator: true);
    final detailPage = _detailPage(item);
    final tabIndex = resetToHome ? 0 : _tabIndex(item.directTo);

    // 팀 전환 후에는 기존 Shell의 선택 탭을 그대로 사용하지 않는다.
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => MainShell(initialIndex: tabIndex)),
      (route) => false,
    );

    if (detailPage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigator.mounted) {
          navigator.push(MaterialPageRoute(builder: (_) => detailPage));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopAppBar.backMore(
        title: widget.currentTeamName,
        onBackPressed: () => Navigator.of(context).maybePop(),
        moreMenuOffset: const Offset(-16, 56),
        moreMenuItems: [
          AppDropdownItem(
            label: '모두 읽음으로 표시',
            onPressed: _markAllAsRead,
          ),
          AppDropdownItem(
            label: '알림 설정',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AlarmSettingPage()),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(
                '아직 도착한 알림이 없어요.',
                style: FontStyles.med16.copyWith(color: context.grays.gray4),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x24,
                AppSpacing.x20,
                AppSpacing.x24,
                AppSpacing.x24,
              ),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return AlarmItemWidget(
                  key: ValueKey(item.id),
                  notification: item,
                  onTap: () => _onNotificationTap(item),
                );
              },
            ),
    );
  }
}
