import 'dart:math' as math;

import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/pending_alarm_push_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/util/alarm_push_navigation.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_switch_provider.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_main_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_list_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/mypage/my_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_entry_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_main_page.dart';
import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({
    super.key,
    this.initialIndex = 0,
    this.initialPostType = PostMainType.notice,
  });

  final int initialIndex;
  final PostMainType initialPostType;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const Duration _noTeamToastDuration = Duration(seconds: 2);
  static const String _noTeamMessage = '현재 로그인된 팀이 없습니다.';

  bool _isNoTeamToastVisible = false;
  bool _isOpeningPush = false;

  late int _currentIndex;

  late final List<Widget> _pages;

  /// 한 번이라도 들어간 탭만 화면을 만들어, 보지 않는 탭의 API 호출을 막는다.
  final Set<int> _visitedTabs = <int>{};

  @override
  void initState() {
    super.initState();
    _pages = [
      const TeamEntryPage(),
      PostMainPage(initialType: widget.initialPostType),
      const CalMainPage(),
      const ListChatPage(),
      const MyPageView(),
    ];
    _currentIndex = widget.initialIndex.clamp(
      0,
      defaultAppNavigationItems.length - 1,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _openPendingPush();
    });
  }

  Future<void> _openPendingPush() async {
    if (!mounted || _isOpeningPush) return;
    final session = ref.read(authProvider).asData?.value;
    if (session == null || !session.createdProfile) return;

    final message = ref.read(pendingAlarmPushProvider.notifier).take();
    if (message == null) return;
    _isOpeningPush = true;
    try {
      await openAlarmFromPush(
        ref: ref,
        navigator: Navigator.of(context, rootNavigator: true),
        message: message,
      );
    } finally {
      _isOpeningPush = false;
      if (mounted && ref.read(pendingAlarmPushProvider) != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _openPendingPush();
        });
      }
    }
  }

  bool _requiresTeam(int index) => index >= 1 && index <= 3;

  void _onNavigationTap(int index) {
    if (_requiresTeam(index)) {
      final teamState = ref.read(currentTeamProvider).asData;
      if (teamState == null) return;
      if (teamState.value == null) {
        _showNoTeamToast();
        return;
      }
    }

    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  void _showNoTeamToast() {
    if (_isNoTeamToastVisible) return;

    _isNoTeamToastVisible = true;
    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColor.gray1,
        elevation: 0,
        shape: const StadiumBorder(),
        width: math.min(
          248.0,
          MediaQuery.sizeOf(context).width - AppSpacing.x16 * 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
        duration: _noTeamToastDuration,
        content: SizedBox(
          height: AppSpacing.x50,
          child: Center(
            child: Text(
              _noTeamMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.med16.copyWith(color: AppColor.white),
            ),
          ),
        ),
      ),
    );

    controller.closed.whenComplete(() => _isNoTeamToastVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    // 이미 메인 화면을 사용 중일 때 푸시를 누르면 즉시 처리하고,
    // 로그인/앱 시작 중 들어온 푸시는 위 initState 콜백에서 처리한다.
    ref.listen(pendingAlarmPushProvider, (previous, next) {
      if (next == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openPendingPush();
      });
    });
    // 팀이 바뀌면 방문 기록을 비운다. 현재 탭은 바로 아래에서 다시 등록되고,
    // 나머지 탭은 제거된 뒤 다음에 들어갈 때 새로 조회한다.
    ref.listen(teamSwitchProvider, (previous, next) {
      setState(_visitedTabs.clear);
    });
    final selectedTeam = ref.watch(currentTeamProvider).asData?.value;
    final displayIndex = _requiresTeam(_currentIndex) && selectedTeam == null
        ? 0
        : _currentIndex;
    _visitedTabs.add(displayIndex);

    return Scaffold(
      body: IndexedStack(
        index: displayIndex,
        children: [
          for (var i = 0; i < _pages.length; i++)
            _visitedTabs.contains(i) ? _pages[i] : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: displayIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}
