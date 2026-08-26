import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/find_id_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/reset_password_page.dart';
import 'package:beatit_front_app/src/domain/auth/widget/text_link_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isSaveLogin = false;
  bool _isPasswordVisible = false;

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

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            ),

                            const SizedBox(height: AppSpacing.x10),

                            AppTextField(
                              hintText: '비밀번호',
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
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
                              text: '로그인하기',
                              width: ButtonWidth.expand,
                              height: ButtonHeight.normal,
                              variant: ButtonVariant.primary,
                              onPressed: () {},
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
