import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostMainPage extends StatefulWidget {
  const PostMainPage({super.key});

  @override
  State<PostMainPage> createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  @override
  void initState() {
    super.initState();
  }

  // void _goToCalCreatePage() {
  //   Navigator.of(
  //     context,
  //   ).push(MaterialPageRoute(builder: (_) => const CalCreatePage()));
  // }
  //
  // void _goToCalDetialPage() {
  //   Navigator.of(
  //     context,
  //   ).push(MaterialPageRoute(builder: (_) => const CalDetailPage()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.add,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(0, 68),

        addMenuItems: [
          AppDropdownItem(
            label: '일정 생성하기',
            onPressed: () {
              // _goToCalCreatePage();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x12,
            AppSpacing.x16,
            0,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: AppSpacing.x30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildMonthHeader(context),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '공지',
                      style: FontStyles.bold34.copyWith(
                        color: context.colors.onSurface,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.x4),

                    // RotatedBox(
                    //   quarterTurns: controller.isOpen ? 2 : 0,
                    //   child: SvgPicture.asset(
                    //     'assets/icons/cal/toggle_down.svg',
                    //     width: 24,
                    //     height: 24,
                    //     colorFilter: ColorFilter.mode(
                    //       context.colors.onSurface,
                    //       BlendMode.srcIn,
                    //     ),
                    //   ),
                    // ),
                    SvgPicture.asset(
                      'assets/icons/post/toggle_down.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        context.colors.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.x24),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '[중요] 합주실 사용 공지',
                            style: FontStyles.bold20.copyWith(
                              color: context.grays.black,
                            ),
                          ),
                          Text(
                            '[중요] 합주실 사용 공지',
                            style: FontStyles.med16.copyWith(
                              color: context.grays.gray5,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: context.grays.gray8,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.x10,
                                vertical: AppSpacing.x4,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/post/good.svg',
                                  ),
                                  Text(
                                    '16',
                                    style: FontStyles.med16.copyWith(
                                      color: context.grays.black,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/post/chat.svg',
                                  ),
                                  Text(
                                    '55',
                                    style: FontStyles.med16.copyWith(
                                      color: context.grays.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Text(
                            '2026.04.08 10:16 · 작성자 송하은',
                            style: FontStyles.reg12.copyWith(
                              color: context.grays.gray4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: context.grays.gray7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildPostHeader(BuildContext context) {
  //   return PostDropdown(
  //     selectedMonth: _focusedDay,
  //     firstMonth: _firstCalendarDay,
  //     lastMonth: _lastCalendarDay,
  //     onMonthSelected: _handleMonthSelected,
  //     triggerBuilder: (context, controller) {
  //       return Semantics(
  //         button: true,
  //         expanded: controller.isOpen,
  //         label: '월 선택',
  //         child: GestureDetector(
  //           behavior: HitTestBehavior.opaque,
  //           onTap: () {
  //             if (controller.isOpen) {
  //               controller.close();
  //               return;
  //             }
  //
  //             controller.open();
  //           },
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 _formatMonth(_focusedDay),
  //                 style: FontStyles.bold34.copyWith(
  //                   color: context.colors.onSurface,
  //                 ),
  //               ),
  //
  //               const SizedBox(width: AppSpacing.x4),
  //
  //               RotatedBox(
  //                 quarterTurns: controller.isOpen ? 2 : 0,
  //                 child: SvgPicture.asset(
  //                   'assets/icons/cal/toggle_down.svg',
  //                   width: 24,
  //                   height: 24,
  //                   colorFilter: ColorFilter.mode(
  //                     context.colors.onSurface,
  //                     BlendMode.srcIn,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
}
