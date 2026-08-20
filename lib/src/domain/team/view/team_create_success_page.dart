import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

class TeamCreateSuccessPage extends StatelessWidget {
  const TeamCreateSuccessPage({super.key, required this.teamName});

  final String teamName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final now = DateTime.now();
    final formattedDate =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColor.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/team_success_bg.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/appbar/back.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            AppColor.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSpacing.x16),
                          Center(
                            child: SvgPicture.asset(
                              'assets/icons/profile/profile1.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x12),
                          Text(
                            '$formattedDate 생성된 팀',
                            style: FontStyles.med16.copyWith(
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            teamName,
                            style: FontStyles.bold34.copyWith(
                              color: AppColor.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.x40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              width: double.infinity,
                              height: 300,
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.lg,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x70),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '"$teamName"의 생성을 환영합니다.',
                                  style: FontStyles.semi14.copyWith(
                                    color: AppColor.beatOrange1,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.x8),
                                Text(
                                  '팀 생성이 완료되었어요!\n팀 페이지에서 멤버를 초대해보세요.',
                                  style: FontStyles.semi20.copyWith(
                                    color: AppColor.white,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x24),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x20,
                    0,
                    AppSpacing.x20,
                    AppSpacing.x24,
                  ),
                  //Todo: 버튼 다크모드 제외
                  child: AppButton(
                    text: '팀 페이지 가기',
                    variant: ButtonVariant.primary,
                    width: ButtonWidth.expand,
                    height: ButtonHeight.normal,
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
