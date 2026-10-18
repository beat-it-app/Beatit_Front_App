import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_main_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_list_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/mypage/my_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_entry_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_main_page.dart';
import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.initialIndex = 0,
    this.initialPostType = PostMainType.notice,
  });

  final int initialIndex;
  final PostMainType initialPostType;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
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

  void _onNavigationTap(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _currentIndex, children: _pages),
    bottomNavigationBar: AppBottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onNavigationTap,
    ),
  );
}
