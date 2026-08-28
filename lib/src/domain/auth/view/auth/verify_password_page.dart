import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/auth/widget/result_box.dart';

class VerifyPasswordPage extends StatefulWidget {
  const VerifyPasswordPage({super.key});

  @override
  State<VerifyPasswordPage> createState() => _VerifyPasswordPageState();
}

class _VerifyPasswordPageState extends State<VerifyPasswordPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final emailController = TextEditingController();

  bool _isIdDuplicated = false;

  bool _isPasswordVisible = false;
  bool _isPasswordCheckVisible = false;

  bool _isEmailCodeSent = false;

  bool _isTermsAgreed = false;
  bool _isPrivacyAgreed = false;

  bool get _isAllAgreed {
    return _isTermsAgreed && _isPrivacyAgreed;
  }

  bool get _isPasswordValid {
    final password = passwordController.text;

    final hasMinLength = password.length >= 8;
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[#*]').hasMatch(password);

    return hasMinLength && hasNumber && hasSpecial;
  }

  String? get _idErrorText {
    if (_isIdDuplicated) {
      return '중복되는 아이디입니다.';
    }

    return null;
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

  bool get _canSubmit {
    return idController.text.isNotEmpty &&
        !_isIdDuplicated &&
        _isPasswordValid &&
        passwordController.text == passwordCheckController.text &&
        passwordCheckController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        _isAllAgreed;
  }

  void _checkDuplicateId() {
    setState(() {
      // TODO: API 연결 전 테스트용.
      // 중복 확인 버튼을 누르면 바로 중복 아이디로 처리.
      _isIdDuplicated = true;
    });
  }

  void _sendEmailCode() {
    setState(() {
      // TODO: API 연결 전 테스트용.
      _isEmailCodeSent = true;
    });
  }

  void _toggleAllAgreements() {
    final nextValue = !_isAllAgreed;

    setState(() {
      _isTermsAgreed = nextValue;
      _isPrivacyAgreed = nextValue;
    });
  }

  void _toggleTermsAgreement() {
    setState(() {
      _isTermsAgreed = !_isTermsAgreed;
    });
  }

  void _togglePrivacyAgreement() {
    setState(() {
      _isPrivacyAgreed = !_isPrivacyAgreed;
    });
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    emailController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '비밀번호 재설정',
                style: FontStyles.bold28.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                '가입한 이메일을 통해 인증 후 아이디를 확인해주세요.',
                style: FontStyles.reg12.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.x50),

              _RequiredLabel(
                text: '아이디',
                color: colors.onSurface,
                requiredColor: colors.primary,
              ),
              const SizedBox(height: AppSpacing.x8),
              AppTextField(
                hintText: '아이디',
                controller: idController,
                isError: _idErrorText != null,
                onChanged: (_) {
                  setState(() {
                    _isIdDuplicated = false;
                  });
                },
              ),
              if (_idErrorText != null) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(text: _idErrorText!, isError: true),
              ],

              const SizedBox(height: AppSpacing.x20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '이메일',
                      hintText: '이메일',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x10),
                  AppButton(
                    text: _isEmailCodeSent ? '재전송' : '인증번호 발송',
                    width: ButtonWidth.medium,
                    height: ButtonHeight.small,
                    variant: ButtonVariant.black,
                    onPressed: _sendEmailCode,
                  ),
                ],
              ),
              if (_isEmailCodeSent) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(
                  text: '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.',
                  color: colors.onSurfaceVariant,
                ),
              ],

              const SizedBox(height: AppSpacing.x10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: '인증번호',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) {},
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x10),
                  AppButton(
                    text: '확인',
                    width: ButtonWidth.medium,
                    height: ButtonHeight.small,
                    variant: ButtonVariant.black,
                    onPressed: () {
                      //TODO: 인증번호와 email을 함께 api로 보내고, 인증번호가 맞는지 확인.

                      //TODO: 인증번호가 맞으면, 비밀번호 재설정 페이지 이동.
                    },
                  ),
                ],
              ),
              //FIXME: 인증번호가 맞는지/틀리는지에 따라 다른 값이 들어가야 함.
              if (_isEmailCodeSent) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(
                  text: '인증번호가 일치하지 않습니다.',
                  color: context.brands.error,
                  isError: true,
                ),
                AppFieldMessage(
                  text: '인증번호 확인이 완료되었습니다.',
                  color: context.grays.gray1,
                  icon: 'assets/icons/check/check_round_green.svg',
                ),
              ],

              const SizedBox(height: AppSpacing.x20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({
    required this.text,
    required this.color,
    required this.requiredColor,
  });

  final String text;
  final Color color;
  final Color requiredColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: FontStyles.semi16.copyWith(color: color),
          children: [
            TextSpan(text: text),
            TextSpan(
              text: ' *',
              style: FontStyles.semi16.copyWith(color: requiredColor),
            ),
          ],
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
    final colors = Theme.of(context).colorScheme;

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
