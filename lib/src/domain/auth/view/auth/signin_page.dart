import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/account_recovery_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signup_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/profile/create_profile_page.dart';
import 'package:beatit_front_app/src/domain/auth/widget/social_login_button.dart';
import 'package:beatit_front_app/src/domain/auth/widget/text_link_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isSaveLogin = true;
  bool _isPasswordVisible = false;

  String? _idErrorText;
  String? _passwordErrorText;

  bool get _canLogin {
    return idController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Future<void> _login() async {
    setState(() {
      _idErrorText = null;
      _passwordErrorText = null;
    });

    await ref
        .read(authProvider.notifier)
        .login(
          identifier: idController.text.trim(),
          password: passwordController.text,
          rememberMe: _isSaveLogin,
        );
  }

  Future<void> _toggleSaveLogin() async {
    if (!_isSaveLogin) {
      setState(() {
        _isSaveLogin = true;
      });
      return;
    }

    final confirmed = await AppPopup.show(
      context,
      title: '로그인 정보 저장을\n해제하시겠습니까?',
      content: '로그인 정보를 저장하지 않으면 채팅 알림을 받을 수 없습니다.',
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.horizontal,
      warningType: WarningType.circle,
      confirmText: '확인',
      cancelText: '취소',
      barrierDismissible: false,
      theme: AppTheme.light,
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _isSaveLogin = false;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _goToSignupPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupPage()));
  }

  void _goToAccountRecoveryPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AccountRecoveryPage()));
  }

  Future<void> _loginWithGoogle() async {
    final authState = ref.read(authProvider);

    if (authState.isLoading) {
      return;
    }

    await ref.read(authProvider.notifier).loginWithGoogle();
  }

  void _showUnsupportedSocialLogin(String providerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$providerName 로그인은 아직 연동되지 않았습니다.')),
    );
  }

  void _handleLoginSuccess(AuthSession session) {
    if (session.createdProfile) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
      return;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CreateProfilePage()));
  }

  void _handleLoginError(Object error) {
    if (error is AuthApiException) {
      switch (error.code) {
        case 'LOGIN-001':
          setState(() {
            _idErrorText = error.message;
          });
          return;
        case 'LOGIN-002':
          setState(() {
            _passwordErrorText = error.message;
          });
          return;
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (session) {
          if (!mounted || session == null) {
            return;
          }

          _handleLoginSuccess(session);
        },
        error: (error, stackTrace) {
          if (!mounted) {
            return;
          }

          _handleLoginError(error);
        },
      );
    });

    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) {
          final colors = Theme.of(context).colorScheme;

          return Scaffold(
            backgroundColor: colors.surface,
            resizeToAvoidBottomInset: true,
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
                          vertical: AppSpacing.x40,
                          horizontal: AppSpacing.x20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.x30,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/auth/sub_logo.svg',
                              ),
                            ),

                            const SizedBox(height: AppSpacing.x40),

                            AppTextField(
                              hintText: '아이디',
                              controller: idController,
                              errorText: _idErrorText,
                              onChanged: (_) {
                                setState(() {
                                  _idErrorText = null;
                                });
                              },
                            ),

                            const SizedBox(height: AppSpacing.x10),

                            AppTextField(
                              hintText: '비밀번호',
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              errorText: _passwordErrorText,
                              onChanged: (_) {
                                setState(() {
                                  _passwordErrorText = null;
                                });
                              },
                              suffixIcon: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _togglePasswordVisibility,
                                child: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 20,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),

                            const SizedBox(height: AppSpacing.x12),

                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _toggleSaveLogin,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    _isSaveLogin
                                        ? 'assets/icons/check/check_on.svg'
                                        : 'assets/icons/check/check_off.svg',
                                  ),
                                  const SizedBox(width: AppSpacing.x8),
                                  Text(
                                    '로그인 정보 저장하기',
                                    style: FontStyles.semi14.copyWith(
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.x30),

                            AppButton(
                              text: authState.isLoading ? '로그인 중...' : '로그인하기',
                              width: ButtonWidth.expand,
                              height: ButtonHeight.normal,
                              variant: ButtonVariant.primary,
                              onPressed: _canLogin && !authState.isLoading
                                  ? _login
                                  : null,
                            ),

                            const SizedBox(height: AppSpacing.x20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextLinkButton(
                                  text: '회원가입',
                                  color: context.grays.gray2,
                                  onTap: _goToSignupPage,
                                ),
                                const SizedBox(width: AppSpacing.x12),
                                Text(
                                  '|',
                                  style: FontStyles.semi14.copyWith(
                                    color: context.grays.gray2,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.x12),
                                TextLinkButton(
                                  text: '아이디 · 비밀번호 찾기',
                                  color: context.grays.gray2,
                                  onTap: _goToAccountRecoveryPage,
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.x24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocialLoginButton.naver(
                                  height: 48,
                                  variant: SocialLoginButtonVariant.circle,
                                  onPressed: () {
                                    _showUnsupportedSocialLogin('네이버');
                                  },
                                ),
                                const SizedBox(width: AppSpacing.x12),
                                SocialLoginButton.google(
                                  height: 48,
                                  variant: SocialLoginButtonVariant.circle,
                                  onPressed: _loginWithGoogle,
                                ),
                                const SizedBox(width: AppSpacing.x12),
                                SocialLoginButton.kakao(
                                  height: 48,
                                  variant: SocialLoginButtonVariant.circle,
                                  onPressed: () {
                                    _showUnsupportedSocialLogin('카카오');
                                  },
                                ),
                                const SizedBox(width: AppSpacing.x12),
                                SocialLoginButton.apple(
                                  height: 48,
                                  variant: SocialLoginButtonVariant.circle,
                                  onPressed: () {
                                    _showUnsupportedSocialLogin('Apple');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x60),
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
      ),
    );
  }
}
