import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/domain/cal/widget/music_list_item.dart';
import 'package:beatit_front_app/src/domain/cal/widget/add_member_button.dart';
import 'package:beatit_front_app/src/domain/cal/widget/calendar_day_item.dart';
import 'package:beatit_front_app/src/domain/cal/widget/label_box.dart';
import 'package:beatit_front_app/src/domain/cal/widget/schedule_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

class CalDetailPage extends StatefulWidget {
  const CalDetailPage({super.key});

  @override
  State<CalDetailPage> createState() => _CalDetailPageState();
}

class _CalDetailPageState extends State<CalDetailPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final emailController = TextEditingController();

  bool _isMapVisible = true;

  void _toggleMapVisibility() {
    setState(() {
      _isMapVisible = !_isMapVisible;
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x24,
            AppSpacing.x16,
            0,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4월 28일 합주',
                  style: FontStyles.bold34.copyWith(
                    color: colors.onSurface,
                    letterSpacing: -0.68,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '2026.07.22 15:47',
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    Text(
                      '｜최종수정일 2026.04.03 15:00',
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x16),

                Text(
                  '안녕하세요! 오늘 합주는 아래 두 곡 연습 예정입니다.\n파일에는 악보를 pdf로 첨부했으니 참고 부탁드려요 !\n합주는 약 3시간 진행 후 함께 점심식사 예정입니다.\n(메뉴는 아마도 닭갈비...)\n오늘은 악기 대여를 안 했으니, 본인이 지참해주세요~',
                  style: FontStyles.reg14.copyWith(color: context.grays.black),
                ),

                const SizedBox(height: AppSpacing.x20),

                Row(
                  children: [
                    LabelBox(
                      iconAddress: 'assets/icons/cal/clock.svg',
                      value: '시간',
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    Text(
                      '2026.07.28 토요일 11:00-14:00',
                      style: FontStyles.med16.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.x8),

                Row(
                  children: [
                    LabelBox(
                      iconAddress: 'assets/icons/cal/location.svg',
                      value: '위치',
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    Text(
                      '그라운드합주실 본점 A3',
                      style: FontStyles.med16.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    TextButton(
                      onPressed: _toggleMapVisibility,
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.primary,
                        backgroundColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        enableFeedback: false,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x16,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '지도보기',
                            style: FontStyles.med16.copyWith(
                              color: context.colors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: context.colors.primary,
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: _isMapVisible ? 2 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/cal/toggle_down.svg',
                              colorFilter: ColorFilter.mode(
                                context.colors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.x20),

                LabelBox(
                  iconAddress: 'assets/icons/cal/clock.svg',
                  value: '연습곡',
                ),

                const SizedBox(height: AppSpacing.x8),

                MusicListItem(
                  trackText: 'Basket Case',
                  artistText: 'Green Day',
                  onTap: () {},
                ),
                Divider(color: context.grays.gray7, height: 1),
                MusicListItem(trackText: '개화', artistText: '루시', onTap: () {}),

                const SizedBox(height: AppSpacing.x20),

                LabelBox(
                  iconAddress: 'assets/icons/cal/music_symbol.svg',
                  value: '참여자',
                ),
                const SizedBox(height: AppSpacing.x14),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.x20),
              ],
            ),
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

          const SizedBox(height: AppSpacing.x4),

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
