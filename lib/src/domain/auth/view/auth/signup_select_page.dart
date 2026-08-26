import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/auth/model/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/widget/social_login_button.dart';
import 'package:beatit_front_app/src/domain/auth/widget/text_link_button.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signup_page.dart';

class SignupSelectPage extends ConsumerStatefulWidget {
  const SignupSelectPage({super.key});

  @override
  ConsumerState<SignupSelectPage> createState() => _SignupSelectPageState();
}

class _SignupSelectPageState extends ConsumerState<SignupSelectPage> {
  void _goToSignupPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupPage()));
  }

  void _goToSigninPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SigninPage()));
  }

  Future<void> _loginWithGoogle() async {
    final authState = ref.read(authProvider);

    if (authState.isLoading) {
      return;
    }

    await ref.read(authProvider.notifier).loginWithGoogle();
  }

  void _handleGoogleLoginSuccess(AuthSession session) {
    if (session.createdProfile) {
      // TODO: 실제 메인 화면 route가 확정되면 여기에서 이동.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google 로그인 성공 - 메인 화면 이동 대상입니다.')),
      );
      return;
    }

    // TODO: 실제 프로필 생성 화면 route가 확정되면 여기에서 이동.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google 로그인 성공 - 프로필 생성 화면 이동 대상입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (session) {
          if (!mounted || session == null) {
            return;
          }

          _handleGoogleLoginSuccess(session);
        },
        error: (error, stackTrace) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColor.black,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.x70,
                  horizontal: AppSpacing.x20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x8,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/auth/main_logo.svg',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '음악 모임 공간은 ',
                              style: FontStyles.semi16.copyWith(
                                color: AppColor.white,
                                letterSpacing: -0.64,
                              ),
                            ),
                            Text(
                              '빗잇',
                              style: FontStyles.exbold16.copyWith(
                                color: AppColor.white,
                                letterSpacing: -0.64,
                              ),
                            ),
                            Text(
                              '에서 !',
                              style: FontStyles.semi16.copyWith(
                                color: AppColor.white,
                                letterSpacing: -0.64,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 200.0),
                    Column(
                      children: [
                        SocialLoginButton.naver(
                          onPressed: () {
                            // TODO: 네이버 로그인 연결
                          },
                        ),

                        const SizedBox(height: AppSpacing.x10),

                        SocialLoginButton.google(onPressed: _loginWithGoogle),

                        const SizedBox(height: AppSpacing.x10),

                        SocialLoginButton.kakao(
                          onPressed: () {
                            // TODO: 카카오 로그인 연결
                          },
                        ),

                        const SizedBox(height: AppSpacing.x20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextLinkButton(
                              text: '로그인하기',
                              color: context.grays.gray2,
                              onTap: _goToSigninPage,
                            ),
                            const SizedBox(width: AppSpacing.x20),
                            Text(
                              '|',
                              style: FontStyles.semi14.copyWith(
                                color: context.grays.gray2,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x20),
                            TextLinkButton(
                              text: '회원가입',
                              color: context.grays.gray2,
                              onTap: _goToSignupPage,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.x40),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
