import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

class CompleteSignupPage extends StatelessWidget {
  final String userName;

  const CompleteSignupPage({super.key, this.userName = '송하은'});

  void _handleStartPressed(BuildContext context) {
    // TODO: 시작하기 버튼을 누른 뒤 이동할 화면 연결
    // 예시:
    // context.go('/home');
    // 또는 Navigator.of(context).pushReplacement(...);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 90.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '가입 완료!',
                            style: FontStyles.bold46.copyWith(
                              color: colors.onSurface,
                              height: 1.2,
                              letterSpacing: -0.92,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x10),
                          Text(
                            '$userName 님, 빗잇 가입을 환영합니다.',
                            style: FontStyles.med16.copyWith(
                              color: context.grays.gray2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.x50),
                          Image.asset(
                            'assets/images/auth/gift_box.png',
                            width: 266,
                            fit: BoxFit.fitWidth,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '시작하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: () {
                  _handleStartPressed(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
