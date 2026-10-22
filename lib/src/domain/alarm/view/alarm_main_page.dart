import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/alarm_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/view/alarm_loading_page.dart';
import 'package:beatit_front_app/src/domain/alarm/view/alarm_setting_page.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/alarm_item.dart';
import 'package:beatit_front_app/src/domain/auth/provider/mypage_provider.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_detail_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_room_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:beatit_front_app/src/domain/post/view/post_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_member_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmMainPage extends ConsumerStatefulWidget {
  const AlarmMainPage({super.key});

  @override
  ConsumerState<AlarmMainPage> createState() => _AlarmMainPageState();
}

class _AlarmMainPageState extends ConsumerState<AlarmMainPage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_loadMoreWhenNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(alarmProvider.notifier).fetchFirstPage();
    });
  }

  void _loadMoreWhenNeeded() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 240) {
      ref.read(alarmProvider.notifier).fetchNextPage();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(alarmProvider.notifier).fetchFirstPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_loadMoreWhenNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  void _showError(String? message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? '알림을 처리하지 못했습니다.')));
  }

  Future<void> _markAllAsRead() async {
    final success = await ref.read(alarmProvider.notifier).markAllAsRead();
    if (!success && mounted) _showError(ref.read(alarmProvider).errorMessage);
  }

  Future<void> _onTapNotification(AlarmNotification notification) async {
    final teamState = ref.read(currentTeamProvider);
    final activeTeamId = teamState.asData?.value?.teamId;
    final alarmState = ref.read(alarmProvider);
    final differentTeam =
        activeTeamId != null &&
        alarmState.teamId != null &&
        activeTeamId != alarmState.teamId;

    AlarmClickResponse? target;
    if (differentTeam) {
      // 목록을 조회한 뒤 팀이 바뀐 경우, 서버의 팀 전환 API를 사용한다.
      target = await _openTeamLoading(
        teamName: alarmState.teamName ?? '팀',
        notificationId: notification.id,
      );
    } else {
      // 현재 팀에서 보는 인앱 알림은 읽음 API로 처리한다.
      target = await ref
          .read(alarmProvider.notifier)
          .readNotification(notification.id);
    }

    if (!mounted) return;
    if (target == null) {
      _showError(ref.read(alarmProvider).errorMessage);
      return;
    }

    // PATCH /read는 팀을 전환하지 않는다. 조회 후 서버의 팀이 변경된
    // 경합 상황에도 /click으로 서버/클라이언트 팀을 일치시킨다.
    bool switchedTeam = differentTeam;
    if (!differentTeam &&
        activeTeamId != null &&
        activeTeamId != target.targetTeamId) {
      final switched = await _openTeamLoading(
        teamName: target.targetTeamName,
        notificationId: notification.id,
      );
      if (!mounted) return;
      if (switched == null) {
        _showError(ref.read(alarmProvider).errorMessage);
        return;
      }
      target = switched;
      switchedTeam = true;
    }

    if (switchedTeam) {
      ref.invalidate(currentTeamProvider);
      ref.invalidate(teamDetailProvider);
      ref.read(myPageProvider.notifier).fetchMyPage();
      ref.invalidate(alarmProvider);
    }
    final destination = target;
    if (destination == null) return;
    _navigateToTarget(destination, notificationTitle: notification.title);
  }

  Future<AlarmClickResponse?> _openTeamLoading({
    required String teamName,
    required int notificationId,
  }) {
    return Navigator.of(context).push<AlarmClickResponse>(
      MaterialPageRoute(
        builder: (_) => AlarmLoadingPage(
          teamName: teamName,
          switchTeam: () => ref
              .read(alarmProvider.notifier)
              .readNotification(notificationId, switchTeam: true),
        ),
      ),
    );
  }

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
    if (path.startsWith('/posts/notices/')) {
      return PostDetailPage(noticeId: id);
    }
    if (path.startsWith('/posts/polls/')) {
      return PollDetailPage(pollId: id);
    }
    if (path.startsWith('/posts/meetits/')) {
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
    if (path?.startsWith('/posts/polls') ?? false) {
      return PostMainType.poll;
    }
    if (path?.startsWith('/posts/meetits') ?? false) {
      return PostMainType.meetit;
    }
    return PostMainType.notice;
  }

  void _navigateToTarget(
    AlarmClickResponse target, {
    required String notificationTitle,
  }) {
    final detail = _detailFor(target, notificationTitle: notificationTitle);
    final rootNavigator = Navigator.of(context, rootNavigator: true);

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(alarmProvider);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppTopAppBar.backMore(
        title: state.teamName ?? '알림',
        onBackPressed: () => Navigator.of(context).maybePop(),
        moreMenuOffset: const Offset(-16, 56),
        moreMenuItems: [
          AppDropdownItem(label: '모두 읽음으로 표시', onPressed: _markAllAsRead),
          AppDropdownItem(
            label: '알림 설정',
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AlarmSettingPage())),
          ),
        ],
      ),
      body: state.isLoading && state.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? '아직 도착한 알림이 없어요.',
                    textAlign: TextAlign.center,
                    style: FontStyles.med16.copyWith(color: colors.onSurface),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(alarmProvider.notifier).fetchFirstPage(),
                    child: Text(state.errorMessage == null ? '새로고침' : '다시 시도'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(alarmProvider.notifier).fetchFirstPage(),
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  0.0,
                  AppSpacing.x20,
                  0.0,
                  AppSpacing.x24,
                ),
                itemCount:
                    state.notifications.length +
                    (state.isLoadingMore || state.errorMessage != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    if (state.isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.x20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return TextButton(
                      onPressed: () => state.isLast
                          ? ref.read(alarmProvider.notifier).fetchFirstPage()
                          : ref.read(alarmProvider.notifier).fetchNextPage(),
                      child: const Text('알림을 불러오지 못했습니다. 다시 시도'),
                    );
                  }
                  final item = state.notifications[index];
                  return AlarmItemWidget(
                    key: ValueKey(item.id),
                    notification: item,
                    isBusy: state.activeNotificationId == item.id,
                    onTap:
                        state.activeNotificationId != null || state.isReadingAll
                        ? null
                        : () => _onTapNotification(item),
                  );
                },
              ),
            ),
    );
  }
}
