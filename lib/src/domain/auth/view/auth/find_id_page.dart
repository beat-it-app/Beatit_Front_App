import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/auth/widget/result_box.dart';

class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  State<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final emailController = TextEditingController();

  bool _isEmailCodeSent = false;

  void _sendEmailCode() {
    setState(() {
      // TODO: API 연결 전 테스트용.
      _isEmailCodeSent = true;
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

              const SizedBox(height: AppSpacing.x10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: '이메일',
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
                    onPressed: () {},
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

              const SizedBox(height: AppSpacing.x40),

              ResultBox(label: '아이디', value: 'beatit1234'),

              const SizedBox(height: AppSpacing.x10),

              AppButton(
                text: '로그인하러 가기',
                onPressed: () {},
                variant: ButtonVariant.outlined,
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
