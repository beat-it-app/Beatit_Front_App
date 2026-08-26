import 'package:beatit_front_app/src/domain/auth/widget/privacy_consent_popup.dart';
import 'package:beatit_front_app/src/domain/auth/widget/service_consent_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  Future<void> _showTermsConsentPopup() async {
    final isAgreed = await ServiceConsentPopup.show(
      context,
      title: '서비스 이용약관',
      confirmText: '동의하기',
    );

    if (!mounted || isAgreed != true) {
      return;
    }

    setState(() {
      _isTermsAgreed = true;
    });
  }

  Future<void> _showPrivacyConsentPopup() async {
    final isAgreed = await PrivacyConsentPopup.show(
      context,
      title: '개인정보 수집 및 이용 동의',
      confirmText: '동의하기',
    );

    if (!mounted || isAgreed != true) {
      return;
    }

    setState(() {
      _isPrivacyAgreed = true;
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
      appBar: AppTopAppBar.backTitle(
        title: '회원가입',
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      _RequiredLabel(
                        text: '아이디',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: '아이디',
                              controller: idController,
                              isError: _idErrorText != null,
                              onChanged: (_) {
                                setState(() {
                                  _isIdDuplicated = false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          AppButton(
                            text: '중복 확인',
                            width: ButtonWidth.small,
                            height: ButtonHeight.small,
                            variant: ButtonVariant.black,
                            onPressed: _checkDuplicateId,
                          ),
                        ],
                      ),
                      if (_idErrorText != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(text: _idErrorText!, isError: true),
                      ],

                      const SizedBox(height: AppSpacing.x20),

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
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
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

                      const SizedBox(height: AppSpacing.x20),

                      //TODO: 이메일 버튼 및 동작 로직 수정하기
                      _RequiredLabel(
                        text: '이메일',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
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

                      const SizedBox(height: AppSpacing.x20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x4,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _toggleAllAgreements,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    _isAllAgreed
                                        ? 'assets/icons/check/check_round_on.svg'
                                        : 'assets/icons/check/check_round_off.svg',
                                  ),
                                  const SizedBox(width: AppSpacing.x8),
                                  Text('전체 동의하기', style: FontStyles.semi14),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.x16),

                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _toggleTermsAgreement,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          _isTermsAgreed
                                              ? 'assets/icons/check/check_on.svg'
                                              : 'assets/icons/check/check_off.svg',
                                        ),
                                        const SizedBox(width: AppSpacing.x8),
                                        Text(
                                          '서비스 이용약관',
                                          style: FontStyles.semi14,
                                        ),
                                        const SizedBox(width: AppSpacing.x4),
                                        Text(
                                          '(필수)',
                                          style: FontStyles.semi14.copyWith(
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _AgreementDetailButton(
                                  onTap: _showTermsConsentPopup,
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.x8),

                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _togglePrivacyAgreement,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          _isPrivacyAgreed
                                              ? 'assets/icons/check/check_on.svg'
                                              : 'assets/icons/check/check_off.svg',
                                        ),
                                        const SizedBox(width: AppSpacing.x8),
                                        Text(
                                          '개인정보 수집 및 이용 동의',
                                          style: FontStyles.semi14,
                                        ),
                                        const SizedBox(width: AppSpacing.x4),
                                        Text(
                                          '(필수)',
                                          style: FontStyles.semi14.copyWith(
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _AgreementDetailButton(
                                  onTap: _showPrivacyConsentPopup,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: '회원가입 완료',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: _canSubmit
                    ? () {
                        // TODO: 회원가입 API 연결
                      }
                    : null,
              ),
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

class _AgreementDetailButton extends StatelessWidget {
  const _AgreementDetailButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: const SizedBox(
        width: 32,
        height: 32,
        child: Icon(Icons.chevron_right, size: 24),
      ),
    );
  }
}
