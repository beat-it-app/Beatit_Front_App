import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class DropdownTestPage extends StatefulWidget {
  const DropdownTestPage({super.key});

  @override
  State<DropdownTestPage> createState() => _DropdownTestPageState();
}

class _DropdownTestPageState extends State<DropdownTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.all,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(0, 68),

        addMenuItems: [
          AppDropdownItem(
            label: '공지 작성하기',
            onPressed: () {
              debugPrint('공지 작성 화면 이동');
            },
          ),
          AppDropdownItem(
            label: '투표 생성하기',
            onPressed: () {
              debugPrint('투표 생성 화면 이동');
            },
          ),
          AppDropdownItem(
            label: '밋잇 생성하기',
            onPressed: () {
              debugPrint('밋잇 생성 화면 이동');
            },
          ),
        ],

        onSearchPressed: () {
          debugPrint('공지 검색');
        },
      ),
      // appBar: AppTopAppBar.backMore(
      //   title: '이기주, 노영서, 이현영',
      //   moreMenuOffset: const Offset(-16, 56),
      //   moreMenuItems: [
      //     AppDropdownItem(
      //       label: '수정하기',
      //       onPressed: () {
      //         debugPrint('수정');
      //       },
      //     ),
      //     AppDropdownItem(
      //       label: '삭제하기',
      //       onPressed: () {
      //         debugPrint('삭제');
      //       },
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(children: []),
      ),
    );
  }
}
