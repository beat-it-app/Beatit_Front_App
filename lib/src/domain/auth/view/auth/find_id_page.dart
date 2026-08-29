import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/auth/provider/find_id_provider.dart';
import 'package:beatit_front_app/src/domain/auth/widget/result_box.dart';

class FindIdPage extends ConsumerStatefulWidget {
  const FindIdPage({super.key});

  @override
  ConsumerState<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends ConsumerState<FindIdPage> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  Future<void> _sendEmailCode() async {
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(findIdentifierProvider.notifier)
        .sendCode(email: emailController.text.trim());

    if (!mounted) {
      return;
    }

    if (success) {
      codeController.clear();
    }
  }

  Future<void> _verifyEmailCode() async {
    FocusScope.of(context).unfocus();

    await ref
        .read(findIdentifierProvider.notifier)
        .verifyCode(
          email: emailController.text.trim(),
          code: codeController.text.trim(),
        );
  }

  void _goToLogin() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(findIdentifierProvider);

    final canSendCode =
        emailController.text.trim().isNotEmpty && !state.isLoading;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '아이디 찾기',
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
                text: '이메일 인증',
                color: colors.onSurface,
                requiredColor: null,
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
                        ref
                            .read(findIdentifierProvider.notifier)
                            .onEmailChanged();

                        setState(() {});
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.x10),

                  AppButton(
                    text: state.isSendingCode
                        ? '발송 중'
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

              if (state.emailError != null) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(
                  text: state.emailError!,
                  color: context.brands.error,
                  isError: true,
                ),
              ] else if (state.isCodeSent && !state.isVerified) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(
                  text: '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.',
                  color: context.grays.gray1,
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
                      onChanged: (_) {
                        ref
                            .read(findIdentifierProvider.notifier)
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
                AppFieldMessage(
                  text: state.codeError!,
                  color: context.brands.error,
                  isError: true,
                ),
              ] else if (state.isVerified) ...[
                const SizedBox(height: AppSpacing.x4),
                AppFieldMessage(
                  text: '인증번호 확인이 완료되었습니다.',
                  color: context.grays.gray1,
                  icon: 'assets/icons/check/check_round_green.svg',
                ),
              ],

              if (state.isVerified) ...[
                const SizedBox(height: AppSpacing.x40),

                ResultBox(label: '아이디', value: state.identifier!),

                const SizedBox(height: AppSpacing.x10),

                AppButton(
                  text: '로그인하러 가기',
                  onPressed: _goToLogin,
                  variant: ButtonVariant.outlined,
                ),
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
