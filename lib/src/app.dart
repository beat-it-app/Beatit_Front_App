import 'package:beatit_front_app/src/domain/auth/view/mypage/my_page.dart';
import 'package:beatit_front_app/src/domain/chat/view/chat_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_entry_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_select_page.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_main_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/member_selection_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:beatit_front_app/src/domain/post/view/post_main_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_main_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_main_page.dart';

import 'domain/team/view/team_detail_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    TeamEntryPage(),

    PostMainPage(),
    CalMainPage(),

    ListChatPage(),

    MyPageView(),
  ];

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex.clamp(
      0,
      defaultAppNavigationItems.length - 1,
    );
  }

  void _onNavigationTap(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}

class _TemporaryMainPage extends StatelessWidget {
  const _TemporaryMainPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Text(title),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CloudMainPage()),
                );
              },
              child: const Text('버튼'),
            ),
          ],
        ),
      ),
    );
  }
}
