import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_main_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    // TODO: 실제 팀 메인 화면으로 교체
    _TemporaryMainPage(title: '홈'),

    _TemporaryMainPage(title: '공지'),
    CalMainPage(),
    _TemporaryMainPage(title: '채팅'),

    // TODO: 실제 마이페이지 화면으로 교체
    _TemporaryMainPage(title: '마이페이지'),
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
    return SafeArea(child: Center(child: Text(title)));
  }
}
