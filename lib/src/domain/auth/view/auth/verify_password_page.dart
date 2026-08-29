import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/auth/provider/reset_password_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/reset_password_page.dart';

class VerifyPasswordPage extends ConsumerStatefulWidget {
  const VerifyPasswordPage({super.key});

  @override
  ConsumerState<VerifyPasswordPage> createState() => _VerifyPasswordPageState();
}

class _VerifyPasswordPageState extends ConsumerState<VerifyPasswordPage> {
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  void _onIdentityChanged() {
    ref.read(resetPasswordProvider.notifier).onIdentityChanged();

    codeController.clear();

    setState(() {});
  }

  Future<void> _sendEmailCode() async {
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(resetPasswordProvider.notifier)
        .sendCode(
          identifier: idController.text.trim(),
          email: emailController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      codeController.clear();
      setState(() {});
    }
  }

  Future<void> _verifyEmailCode() async {
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(resetPasswordProvider.notifier)
        .verifyCode(
          email: emailController.text.trim(),
          code: codeController.text.trim(),
        );

    if (!mounted || !success) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResetPasswordPage(
          identifier: idController.text.trim(),
          email: emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    emailController.dispose();
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(resetPasswordProvider);

    final canSendCode =
        idController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        !state.isLoading;

    final canVerifyCode =
        state.isCodeSent &&
        codeController.text.trim().isNotEmpty &&
        !state.isLoading;

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
                '가입한 아이디와 이메일을 인증해주세요.',
                style: FontStyles.reg12.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: AppSpacing.x50),

              _RequiredLabel(
                text: '아이디',
                color: colors.onSurface,
                requiredColor: null,
              ),

              const SizedBox(height: AppSpacing.x8),

              AppTextField(
                hintText: '아이디',
                controller: idController,
                isError: state.identityError != null,
                onChanged: (_) {
                  _onIdentityChanged();
                },
              ),

              const SizedBox(height: AppSpacing.x20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '이메일 인증',
                      requiredMark: false,
                      hintText: '이메일',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      isError: state.identityError != null,
                      onChanged: (_) {
                        _onIdentityChanged();
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.x10),

                  AppButton(
                    text: state.isSendingCode
                        ? '전송 중'
                        : state.isCodeSent
                        ? '재전송'
                        : '인증번호 발송',
                    width: ButtonWidth.medium,
                    height: ButtonHeight.small,
                    variant: ButtonVariant.black,
                    onPressed: canSendCode ? _sendEmailCode : null,
                  ),
                ],
              ),

              if (state.identityError != null) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(text: state.identityError!, isError: true),
              ] else if (state.isCodeSent) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(
                  text: '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.',
                  color: colors.onSurfaceVariant,
                  icon: 'assets/icons/check/check_round_green.svg',
                ),
              ],

              const SizedBox(height: AppSpacing.x10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: '인증번호',
                      controller: codeController,
                      isError: state.codeError != null,
                      onChanged: (_) {
                        ref
                            .read(resetPasswordProvider.notifier)
                            .onCodeChanged();

                        setState(() {});
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.x10),

                  AppButton(
                    text: state.isVerifyingCode ? '확인 중' : '확인',
                    width: ButtonWidth.medium,
                    height: ButtonHeight.small,
                    variant: ButtonVariant.black,
                    onPressed: canVerifyCode ? _verifyEmailCode : null,
                  ),
                ],
              ),

              if (state.codeError != null) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(text: state.codeError!, isError: true),
              ],
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
    this.requiredColor,
  });

  final String text;
  final Color color;
  final Color? requiredColor;

  @override
  Widget build(BuildContext context) {
    if (requiredColor == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: FontStyles.semi16.copyWith(color: color)),
      );
    }

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
