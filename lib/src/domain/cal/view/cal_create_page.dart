import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/domain/cal/widget/add_member_button.dart';
import 'package:beatit_front_app/src/domain/cal/widget/label_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

class CalCreatePage extends StatefulWidget {
  const CalCreatePage({super.key});

  @override
  State<CalCreatePage> createState() => _CalCreatePageState();
}

class _CalCreatePageState extends State<CalCreatePage> {
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
      appBar: AppTopAppBar.closeOnly(
        onClosePressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x4,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RequiredLabel(
                        text: '일정 이름',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '일정 이름을 작성하세요.',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        messageText: _isEmailCodeSent
                            ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                            : null,
                        messageColor: colors.onSurfaceVariant,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '날짜',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '날짜를 선택하세요.',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        messageText: _isEmailCodeSent
                            ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                            : null,
                        messageColor: colors.onSurfaceVariant,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/calendar.svg',
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '장소',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '모임 장소를 검색하세요.',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        messageText: _isEmailCodeSent
                            ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                            : null,
                        messageColor: colors.onSurfaceVariant,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/search.svg',
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '시간',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: '시작 시간',
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              messageText: _isEmailCodeSent
                                  ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                                  : null,
                              messageColor: colors.onSurfaceVariant,
                              suffixIcon: SvgPicture.asset(
                                'assets/icons/cal/clock.svg',
                              ),
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          Text('-'),
                          const SizedBox(width: AppSpacing.x10),
                          Expanded(
                            child: AppTextField(
                              hintText: '끝나는 시간',
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              messageText: _isEmailCodeSent
                                  ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                                  : null,
                              messageColor: colors.onSurfaceVariant,
                              suffixIcon: SvgPicture.asset(
                                'assets/icons/cal/clock.svg',
                              ),
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '일정 설명',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextArea(
                        hintText: '모임에 어울리는 일정 소개글을 작성해주세요.',
                        controller: emailController,
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '참여 인원',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      // AddMemberButton(text: '인원 선택하기', onPressed: () {}),
                      // const SizedBox(height: AppSpacing.x16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(top: AppSpacing.x8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),

                            _AddButton(
                              onPressed: () {
                                print('추가 버튼 선택됨.');
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '음원',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '음원을 선택하세요.',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        messageText: _isEmailCodeSent
                            ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                            : null,
                        messageColor: colors.onSurfaceVariant,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/delete.svg',
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      Center(child: _AddButton(onPressed: () {})),
                      const SizedBox(height: AppSpacing.x16),

                      AppTextField(
                        label: '파일',
                        hintText: '음원을 선택하세요.',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        messageText: _isEmailCodeSent
                            ? '인증 번호가 발송되었습니다. 3분 이내로 인증번호를 입력해주세요.'
                            : null,
                        messageColor: colors.onSurfaceVariant,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/delete.svg',
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      Center(child: _AddButton(onPressed: () {})),

                      const SizedBox(height: AppSpacing.x16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: '생성하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: () {
                  // TODO: 회원가입 API 연결
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('추가 버튼 선택됨.');
      },
      child: Container(
        height: 34.0,
        width: 34.0,
        decoration: ShapeDecoration(
          color: context.grays.gray8,
          shape: OvalBorder(),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/cal/plus.svg',
            width: 24.0,
            height: 24.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _MemberInfoButton extends StatelessWidget {
  const _MemberInfoButton({
    required this.memberName,
    required this.memberPart,
    required this.memberImage,
  });

  final String memberName;
  final String memberPart;
  final String memberImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 60.0,
                width: 60.0,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage(memberImage),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () {
                    print('삭제 버튼 클릭됨');
                  },
                  child: SizedBox(
                    width: 26.0,
                    height: 26.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 22.0,
                          width: 22.0,
                          decoration: ShapeDecoration(
                            color: context.colors.surface,
                            shape: const OvalBorder(),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/cal/delete.svg',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.x8),

          Text(
            memberName,
            style: FontStyles.semi18.copyWith(color: context.grays.gray1),
          ),
          Text(
            memberPart,
            style: FontStyles.reg14.copyWith(color: context.grays.gray4),
          ),
        ],
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
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
          children: [
            TextSpan(text: text),
            if (requiredColor != null)
              TextSpan(
                text: ' *',
                style: TextStyle(color: requiredColor),
              ),
          ],
        ),
      ),
    );
  }
}
