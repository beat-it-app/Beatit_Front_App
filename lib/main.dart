import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';

import 'src/core/theme/app_theme.dart';
import 'src/core/widgets/bottons/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beatit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Beatit'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(AppSpacing.x16),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: '중복 확인',
              width: ButtonWidth.small,
              height: ButtonHeight.small,
              variant: ButtonVariant.black,
              onPressed: null,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: '로그인하기',
              width: ButtonWidth.expand,
              height: ButtonHeight.normal,
              variant: ButtonVariant.primary,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            AppButton(
              text: '로그인하러 가기',
              width: ButtonWidth.expand,
              height: ButtonHeight.normal,
              variant: ButtonVariant.outlined,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AppTextField(
                    label: '아이디',
                    hintText: '아이디',
                    requiredMark: true,
                    controller: null,
                  ),
                ),
                const SizedBox(width: AppSpacing.x10),
                AppButton(
                  text: '중복 확인',
                  width: ButtonWidth.small,
                  height: ButtonHeight.small,
                  variant: ButtonVariant.black,
                  onPressed: () {},
                ),
              ],
            ),
            AppTextArea(
              label: '팀 소개',
              hintText: '모임에 어울리는 팀 소개글을 작성해주세요.',
              requiredMark: true,
              controller: null,
              maxLength: 200,
            )
          ],
        ),
      ),
    );
  }
}