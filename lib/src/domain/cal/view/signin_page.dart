import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppTwoAppBar.add(title: ""),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.x24,
                        horizontal: AppSpacing.x12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //_EmptyChatList()
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _EmptyChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '채팅 목록이 없습니다.',
            style: FontStyles.bold22.copyWith(color: context.grays.black),
          ),
          const SizedBox(height: AppSpacing.x10),
          Text(
            '멤버 목록을 눌러 채팅을 시작해보세요.',
            style: FontStyles.med16.copyWith(color: context.grays.gray5),
          ),
        ],
      ),
    );
  }
}
