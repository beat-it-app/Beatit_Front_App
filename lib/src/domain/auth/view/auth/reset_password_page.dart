import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/auth/provider/reset_password_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.identifier,
    required this.email,
  });

  final String identifier;
  final String email;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordCheckVisible = false;

  bool get _isPasswordValid {
    final password = passwordController.text;

    final hasMinLength = password.length >= 8;
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[#*]').hasMatch(password);

    return hasMinLength && hasNumber && hasSpecial;
  }

  String? get _passwordErrorText {
    if (passwordController.text.isEmpty) {
      return null;
    }

    if (!_isPasswordValid) {
      return '숫자, 특수기호(#,*)를 포함한 8자리 이상 문자여야 합니다.';
    }

    return null;
  }

  String? get _passwordCheckErrorText {
    final password = passwordController.text;
    final passwordCheck = passwordCheckController.text;

    if (passwordCheck.isEmpty) {
      return null;
    }

    if (password != passwordCheck) {
      return '비밀번호가 일치하지 않습니다.';
    }

    return null;
  }

  bool get _isInputValid {
    return _isPasswordValid &&
        passwordController.text == passwordCheckController.text &&
        passwordCheckController.text.isNotEmpty;
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(resetPasswordProvider.notifier)
        .resetPassword(
          identifier: widget.identifier,
          email: widget.email,
          newPassword: passwordController.text,
        );

    if (!mounted || !success) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordCheckController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(resetPasswordProvider);

    final canSubmit = _isInputValid && !state.isLoading;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '비밀번호 재설정',
                      style: FontStyles.bold28.copyWith(
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.x4),

                    Text(
                      '원하는 비밀번호를 입력하여 재설정하세요.',
                      style: FontStyles.reg12.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.x50),

                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: passwordController,
                      builder: (context, value, _) {
                        return AppTextField(
                          label: '비밀번호',
                          hintText: '비밀번호',
                          requiredMark: true,
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          errorText: _passwordErrorText,
                          onChanged: (_) {
                            setState(() {});
                          },
                          suffixIcon: value.text.isEmpty
                              ? null
                              : _PasswordVisibilityButton(
                                  isVisible: _isPasswordVisible,
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.x10),

                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: passwordCheckController,
                      builder: (context, value, _) {
                        return AppTextField(
                          hintText: '비밀번호 확인',
                          controller: passwordCheckController,
                          obscureText: !_isPasswordCheckVisible,
                          errorText: _passwordCheckErrorText,
                          onChanged: (_) {
                            setState(() {});
                          },
                          suffixIcon: value.text.isEmpty
                              ? null
                              : _PasswordVisibilityButton(
                                  isVisible: _isPasswordCheckVisible,
                                  onTap: () {
                                    setState(() {
                                      _isPasswordCheckVisible =
                                          !_isPasswordCheckVisible;
                                    });
                                  },
                                ),
                        );
                      },
                    ),

                    if (state.resetError != null) ...[
                      const SizedBox(height: AppSpacing.x4),
                      AppFieldMessage(text: state.resetError!, isError: true),
                    ],
                  ],
                ),
              ),

              AppButton(
                text: state.isResettingPassword ? '재설정 중' : '확인',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: canSubmit ? _resetPassword : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  const _PasswordVisibilityButton({
    required this.isVisible,
    required this.onTap,
  });

  final bool isVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: isVisible
            ? SvgPicture.asset('assets/icons/auth/eye_off.svg')
            : SvgPicture.asset('assets/icons/auth/eye_on.svg'),
      ),
    );
  }
}
