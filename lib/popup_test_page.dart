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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('팝업 사용 예시 페이지')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // 1. circle 경고 + small content + 버튼 2개 + horizontal
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
                text: '작성 중단 팝업',
                variant: ButtonVariant.primary,
              ),
            ),

            const SizedBox(height: 16),

            // 2. triangle 경고 + small content + 버튼 2개 + horizontal
            Center(
              child: AppButton(
                onPressed: () async {
                  final confirmed = await AppPopup.show(
                    context,
                    title: '정말 삭제하시겠습니까?',
                    content: '삭제된 게시물은\n복구할 수 없습니다.',
                    warningType: WarningType.triangle,
                    contentType: ContentType.small,
                    buttonNum: ButtonNum.two,
                    buttonSymmetric: ButtonSymmetric.horizontal,
                    confirmText: '확인',
                    cancelText: '취소',
                  );

                  if (!mounted) return;

                  if (confirmed == true) {
                    debugPrint('삭제 기능이 실행되었습니다.');
                  }
                },
                text: '삭제 경고 팝업',
                variant: ButtonVariant.primary,
              ),
            ),

            const SizedBox(height: 16),

            // 3. circle 경고 + content 없음 + 버튼 1개
            Center(
              child: AppButton(
                onPressed: () async {
                  final confirmed = await AppPopup.show(
                    context,
                    title: '이름은 10글자 이내로\n작성해주세요.',
                    warningType: WarningType.circle,
                    contentType: ContentType.none,
                    buttonNum: ButtonNum.one,
                    confirmText: '확인',
                  );

                  if (!mounted) return;

                  if (confirmed == true) {
                    debugPrint('글자 수 안내 팝업을 확인했습니다.');
                  }
                },
                text: '글자 수 안내 팝업',
                variant: ButtonVariant.primary,
              ),
            ),

            const SizedBox(height: 16),

            // 4. 경고 없음 + large contentWidget + 버튼 2개 + vertical
            Center(
              child: AppButton(
                onPressed: () async {
                  final confirmed = await AppPopup.show(
                    context,
                    title: '운영진 변경',
                    warningType: WarningType.none,
                    contentType: ContentType.large,
                    buttonNum: ButtonNum.two,
                    buttonSymmetric: ButtonSymmetric.vertical,
                    confirmText: '확인',
                    cancelText: '취소',
                    contentWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            '노',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: '노영서',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' 님을\n운영진으로 추가하시겠습니까?'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  if (!mounted) return;

                  if (confirmed == true) {
                    debugPrint('운영진 변경 기능이 실행되었습니다.');
                  }
                },
                text: '운영진 변경 팝업',
                variant: ButtonVariant.primary,
              ),
            ),

            const SizedBox(height: 16),

            // 5. 경고 없음 + content 없음 + 버튼 2개 + horizontal
            Center(
              child: AppButton(
                onPressed: () async {
                  final confirmed = await AppPopup.show(
                    context,
                    title: '팀을 탈퇴하시겠습니까?',
                    warningType: WarningType.none,
                    contentType: ContentType.none,
                    buttonNum: ButtonNum.two,
                    buttonSymmetric: ButtonSymmetric.horizontal,
                    confirmText: '확인',
                    cancelText: '취소',
                  );

                  if (!mounted) return;

                  if (confirmed == true) {
                    debugPrint('팀 탈퇴 기능이 실행되었습니다.');
                  }
                },
                text: '기본 확인 팝업',
                variant: ButtonVariant.primary,
              ),
            ),

            const SizedBox(height: 16),

            // 6. 경고 없음 + content 없음 + 버튼 2개 + vertical
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
                    debugPrint('팀 가입 기능이 실행되었습니다.');
                  }
                },
                text: '팀 가입 팝업',
                variant: ButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
