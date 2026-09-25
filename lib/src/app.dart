import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/member_selection_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
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
    LocationSearchPage(),

    MusicSearchPage(),
    CalMainPage(),

    MemberSelectionPage(
      members: const [
        MemberSelectionMember(
          id: '1',
          name: '권우혁',
          role: MemberSelectionRole.manager,
          profileImageUrl: 'https://...',
        ),
        MemberSelectionMember(
          id: '2',
          name: '박소연',
          role: MemberSelectionRole.member,
          profileImageUrl: 'https://...',
        ),
        MemberSelectionMember(
          id: '3',
          name: '이기주',
          role: MemberSelectionRole.leader,
          profileImageUrl: 'https://...',
        ),
        MemberSelectionMember(
          id: '4',
          name: '이희빈',
          role: MemberSelectionRole.member,
          profileImageUrl: 'https://...',
        ),
      ],
    ),

    // TODO: 실제 마이페이지 화면으로 교체
    MusicPreviewPage(
      musicTitle: 'Test Music',
      artist: 'Test Artist',
      imageUrl: 'https://picsum.photos/600/600',
      previewUrl: 'https://cdn.truefilesize.com/mp3/sample-500kb.mp3',
    ),
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
