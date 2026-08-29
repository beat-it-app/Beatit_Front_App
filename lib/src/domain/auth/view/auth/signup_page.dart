import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

import 'package:beatit_front_app/src/domain/auth/provider/signup_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:beatit_front_app/src/domain/auth/widget/privacy_consent_popup.dart';
import 'package:beatit_front_app/src/domain/auth/widget/service_consent_popup.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordCheckVisible = false;

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

  bool _canVerifyCode(SignupState state) {
    return state.isCodeSent &&
        !state.isVerified &&
        !state.isLoading &&
        codeController.text.trim().isNotEmpty;
  }

  bool _canSubmit(SignupState state) {
    return idController.text.trim().isNotEmpty &&
        state.isIdentifierChecked &&
        _isPasswordValid &&
        passwordController.text == passwordCheckController.text &&
        passwordCheckController.text.isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        state.isVerified &&
        _isAllAgreed &&
        !state.isSubmitting;
  }

  Future<void> _checkDuplicateId() async {
    final identifier = idController.text.trim();

    if (identifier.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    await ref
        .read(signupProvider.notifier)
        .checkIdentifier(identifier: identifier);
  }

  Future<void> _sendEmailCode() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await ref
        .read(signupProvider.notifier)
        .sendEmailCode(email: email);

    if (!mounted || !success) {
      return;
    }

    codeController.clear();
    setState(() {});
  }

  Future<void> _verifyEmailCode() async {
    FocusScope.of(context).unfocus();

    await ref
        .read(signupProvider.notifier)
        .verifyEmailCode(
          email: emailController.text.trim(),
          code: codeController.text.trim(),
        );
  }

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(signupProvider.notifier)
        .signup(
          identifier: idController.text.trim(),
          password: passwordController.text,
          email: emailController.text.trim(),
        );

    if (!mounted || !success) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다.')));

    ref.read(signupProvider.notifier).reset();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SigninPage()));
  }

  void _onIdentifierChanged() {
    ref.read(signupProvider.notifier).onIdentifierChanged();

    setState(() {});
  }

  void _onEmailChanged() {
    ref.read(signupProvider.notifier).onEmailChanged();

    codeController.clear();

    setState(() {});
  }

  void _onCodeChanged() {
    ref.read(signupProvider.notifier).onCodeChanged();

    setState(() {});
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
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final signupState = ref.watch(signupProvider);

    final canCheckIdentifier =
        idController.text.trim().isNotEmpty && !signupState.isLoading;

    final canSendEmailCode =
        emailController.text.trim().isNotEmpty && !signupState.isLoading;

    final canVerifyCode = _canVerifyCode(signupState);

    final canSubmit = _canSubmit(signupState);

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
                              isError: signupState.identifierError != null,
                              onChanged: (_) {
                                _onIdentifierChanged();
                              },
                            ),
                          ),

                          const SizedBox(width: AppSpacing.x10),

                          AppButton(
                            text: signupState.isCheckingIdentifier
                                ? '확인 중'
                                : '중복 확인',
                            width: ButtonWidth.small,
                            height: ButtonHeight.small,
                            variant: ButtonVariant.black,
                            onPressed: canCheckIdentifier
                                ? _checkDuplicateId
                                : null,
                          ),
                        ],
                      ),

                      if (signupState.identifierError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: signupState.identifierError!,
                          isError: true,
                        ),
                      ] else if (signupState.isIdentifierChecked) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: '사용 가능한 아이디입니다.',
                          color: colors.onSurfaceVariant,
                        ),
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
                              isError: signupState.emailError != null,
                              onChanged: (_) {
                                _onEmailChanged();
                              },
                            ),
                          ),

                          const SizedBox(width: AppSpacing.x10),

                          AppButton(
                            text: signupState.isSendingCode
                                ? '발송 중'
                                : signupState.isCodeSent
                                ? '재전송'
                                : '인증번호 발송',
                            width: ButtonWidth.medium,
                            height: ButtonHeight.small,
                            variant: ButtonVariant.black,
                            onPressed: canSendEmailCode ? _sendEmailCode : null,
                          ),
                        ],
                      ),

                      if (signupState.emailError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: signupState.emailError!,
                          isError: true,
                        ),
                      ] else if (signupState.isCodeSent &&
                          !signupState.isVerified) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.',
                          color: colors.onSurfaceVariant,
                          icon: 'assets/icons/check/check_round_green.svg',
                        ),
                      ],

                      const SizedBox(height: AppSpacing.x10),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: '인증번호',
                              controller: codeController,
                              keyboardType: TextInputType.text,
                              isError: signupState.codeError != null,
                              onChanged: (_) {
                                _onCodeChanged();
                              },
                            ),
                          ),

                          const SizedBox(width: AppSpacing.x10),

                          AppButton(
                            text: signupState.isVerifyingCode
                                ? '확인 중'
                                : signupState.isVerified
                                ? '인증 완료'
                                : '확인',
                            width: ButtonWidth.medium,
                            height: ButtonHeight.small,
                            variant: ButtonVariant.black,
                            onPressed: canVerifyCode ? _verifyEmailCode : null,
                          ),
                        ],
                      ),

                      if (signupState.codeError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: signupState.codeError!,
                          isError: true,
                        ),
                      ] else if (signupState.isVerified) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: '이메일 인증이 완료되었습니다.',
                          color: colors.onSurfaceVariant,
                          icon: 'assets/icons/check/check_round_green.svg',
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

                      if (signupState.signupError != null) ...[
                        const SizedBox(height: AppSpacing.x20),
                        AppFieldMessage(
                          text: signupState.signupError!,
                          isError: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: signupState.isSubmitting ? '가입 중...' : '회원가입 완료',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: canSubmit ? _signup : null,
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
