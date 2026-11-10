import 'dart:math' as math;

import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
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

  late int _currentIndex;

  late final List<Widget> _pages;

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
    final selectedTeam = ref.watch(currentTeamProvider).asData?.value;
    final displayIndex = _requiresTeam(_currentIndex) && selectedTeam == null
        ? 0
        : _currentIndex;

    return Scaffold(
      body: IndexedStack(index: displayIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: displayIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}
