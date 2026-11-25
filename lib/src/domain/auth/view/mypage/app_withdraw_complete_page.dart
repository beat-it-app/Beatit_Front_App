import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppWithdrawCompletePage extends StatelessWidget {
  const AppWithdrawCompletePage({super.key});

  void _goToSignin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SigninPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _goToSignin(context);
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppTopAppBar.backOnly(
          onBackPressed: () => _goToSignin(context),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // 상단 느낌표 원형 아이콘
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/popup/circle.svg',
                        width: 60,
                        height: 60,
                        colorFilter: ColorFilter.mode(
                          context.grays.gray7,
                          BlendMode.srcIn,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/popup/point.svg',
                        width: 30,
                        height: 30,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x30),

                // 메인 타이틀
                Text(
                  '회원 탈퇴 신청이\n완료되었습니다.',
                  textAlign: TextAlign.center,
                  style: FontStyles.bold34.copyWith(
                    color: colors.onSurface,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x50),

                // 유예 기간 안내 문구
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: FontStyles.semi16.copyWith(
                      color: context.grays.gray4,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: '앞으로 7일 동안 계정 유예 기간이 유지됩니다.\n'),
                      const TextSpan(text: '탈퇴를 취소하고 싶으시다면 7일 이내에 다시 로그인하여\n'),
                      TextSpan(
                        text: '[복구하기]',
                        style: FontStyles.semi16.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const TextSpan(text: '를 눌러주세요.'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x10),

                // 감사 인사
                Text(
                  '그동안 빗잇을 이용해주셔서 감사합니다.',
                  textAlign: TextAlign.center,
                  style: FontStyles.semi16.copyWith(color: context.grays.gray4),
                ),
                const Spacer(flex: 3),

                // 하단 확인 버튼
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x20),
                  child: AppButton(
                    text: '확인',
                    variant: ButtonVariant.black,
                    width: ButtonWidth.expand,
                    height: ButtonHeight.normal,
                    onPressed: () => _goToSignin(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
