import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('부모 위젯')),
      body: Column(
        children: [
          Center(
            child: AppButton(
              onPressed: () async {
                final confirmed = await AppPopup.show(
                  context,
                  title: '작성을 중단하시겠습니까?',
                  content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
                  warningType: WarningType.circle,
                  contentType: ContentType.small,
                  buttonNum: ButtonNum.two,
                  buttonSymmetric: ButtonSymmetric.horizontal,
                  confirmText: '확인',
                  cancelText: '취소',
                );

                if (!mounted) return;

                if (confirmed == true) {
                  debugPrint('작성 중단 기능이 실행되었습니다.');
                }
              },
              text: '팝업 열기',
              variant: ButtonVariant.primary,
            ),
          ),
          Center(
            child: AppButton(
              onPressed: () async {
                final confirmed = await AppPopup.show(
                  context,
                  title: '팀 "잘나가는 밴드"에\n가입하시겠습니까?',
                  warningType: WarningType.none,
                  contentType: ContentType.none,
                  buttonNum: ButtonNum.two,
                  buttonSymmetric: ButtonSymmetric.vertical,
                  confirmText: '예',
                  cancelText: '아니요',
                );

                if (!mounted) return;

                if (confirmed == true) {
                  debugPrint('작성 중단 기능이 실행되었습니다.');
                }
              },
              text: '팝업 열기',
              variant: ButtonVariant.primary,
            ),
          ),
        ],
      ),
    );
  }
}
