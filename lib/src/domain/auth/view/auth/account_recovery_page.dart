import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/tabs/app_tab_bar.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/find_id_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/verify_password_page.dart';
import 'package:flutter/material.dart';

class AccountRecoveryPage extends StatefulWidget {
  const AccountRecoveryPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AccountRecoveryPage> createState() => _AccountRecoveryPageState();
}

class _AccountRecoveryPageState extends State<AccountRecoveryPage> {
  static const _labels = ['아이디 찾기', '비밀번호 재설정'];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _labels.length - 1).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppTabBar(
              labels: _labels,
              selectedIndex: _selectedIndex,
              onChanged: (index) {
                if (_selectedIndex == index) {
                  return;
                }

                FocusScope.of(context).unfocus();
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final pageWidth = constraints.maxWidth;
                  const pages = <Widget>[
                    FindIdPage(embedded: true),
                    VerifyPasswordPage(embedded: true),
                  ];

                  // 탭 변경 시 양쪽 화면을 함께 밀어주되, 입력 상태는 유지한다.
                  return ClipRect(
                    child: Stack(
                      children: [
                        for (var index = 0; index < pages.length; index++)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeInOutCubic,
                            top: 0,
                            bottom: 0,
                            left: (index - _selectedIndex) * pageWidth,
                            width: pageWidth,
                            child: IgnorePointer(
                              ignoring: index != _selectedIndex,
                              child: pages[index],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
