import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backTitle(title: "회원가입"),
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
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: '아이디',
                              hintText: '아이디',
                              requiredMark: true,
                              controller: null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          AppButton(
                            text: '중복 확인',
                            width: ButtonWidth.small,
                            height: ButtonHeight.small,
                            variant: ButtonVariant.black,
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      AppTextField(
                        label: '비밀번호',
                        hintText: '비밀번호',
                        requiredMark: true,
                        controller: null,
                      ),

                      const SizedBox(height: AppSpacing.x10),

                      AppTextField(
                        hintText: '비밀번호 확인',
                        requiredMark: true,
                        controller: null,
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: '이메일',
                              hintText: '이메일',
                              requiredMark: true,
                              controller: null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          AppButton(
                            text: '인증번호 발송',
                            width: ButtonWidth.medium,
                            height: ButtonHeight.small,
                            variant: ButtonVariant.black,
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x4,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/check/check_round_off.svg',
                                ),
                                const SizedBox(width: AppSpacing.x8),
                                Text(
                                  '전체 동의하기',
                                  style: FontStyles.semi14,
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.x16),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/check/check_off.svg',
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
                                SvgPicture.asset(
                                  'assets/icons/auth/back.svg',
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.x8),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/check/check_off.svg',
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
                                SvgPicture.asset(
                                  'assets/icons/auth/back.svg',
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
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  
  }
}