import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/model/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/find_id_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/reset_password_page.dart';
import 'package:beatit_front_app/src/domain/auth/widget/text_link_button.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isSaveLogin = false;
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

    await ref.read(authProvider.notifier).login(
          identifier: idController.text.trim(),
          password: passwordController.text,
          rememberMe: _isSaveLogin,
        );
  }

  void _toggleSaveLogin() {
    setState(() {
      _isSaveLogin = !_isSaveLogin;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _goToFindIdPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FindIdPage()));
  }

  void _goToResetPasswordPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
  }

  void _handleLoginSuccess(AuthSession session) {
    if (session.createdProfile) {
      // TODO: 실제 메인 화면 route가 확정되면 여기에서 이동.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 성공 - 메인 화면 이동 대상입니다.')),
      );
      return;
    }

    // TODO: 실제 프로필 생성 화면 route가 확정되면 여기에서 이동.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('로그인 성공 - 프로필 생성 화면 이동 대상입니다.')),
    );
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
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
            backgroundColor: AppColor.black,
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
                          vertical: AppSpacing.x70,
                          horizontal: AppSpacing.x20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/auth/sub_logo.svg',
                                  ),
                                ),
                              ],
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
                                      color: AppColor.white,
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
                                  text: '아이디찾기',
                                  color: context.grays.gray2,
                                  onTap: _goToFindIdPage,
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
                                  text: '비밀번호찾기',
                                  color: context.grays.gray2,
                                  onTap: _goToResetPasswordPage,
                                ),
                              ],
                            ),
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
