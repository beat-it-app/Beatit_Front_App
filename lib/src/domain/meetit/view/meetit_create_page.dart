import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/calendar_month_dropdown.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/calendar_month_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetitCreatePage extends StatefulWidget {
  const MeetitCreatePage({super.key});

  @override
  State<MeetitCreatePage> createState() => _MeetitCreatePageState();
}

class _MeetitCreatePageState extends State<MeetitCreatePage> {
  final _meetingNameController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  /// 오늘 날짜입니다.
  /// getter로 계산해 hot reload 시 late 필드 미초기화 문제를 피합니다.
  DateTime get _today => DateUtils.dateOnly(DateTime.now());

  /// 표시 가능한 첫 번째 달: 현재 달
  DateTime get _firstCalendarMonth => DateTime(_today.year, _today.month);

  /// 표시 가능한 마지막 달: 다음 해의 같은 달
  /// 예) 2026.08 -> 2027.08까지 표시
  DateTime get _lastCalendarMonth => DateTime(_today.year + 1, _today.month);

  late DateTime _focusedMonth;

  /// 월을 이동하더라도 초기화하지 않고 계속 보존하는 후보 날짜 목록입니다.
  final Set<DateTime> _selectedCandidateDates = <DateTime>{};

  bool _isCalendarExpanded = false;

  @override
  void initState() {
    super.initState();
    _focusedMonth = _firstCalendarMonth;
  }

  @override
  void dispose() {
    _meetingNameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _handleMonthSelected(DateTime selectedMonth) {
    setState(() {
      _focusedMonth = DateTime(selectedMonth.year, selectedMonth.month);

      // 중요: 월을 바꿔도 _selectedCandidateDates는 건드리지 않습니다.
      // 이전 월에서 선택했던 후보 날짜가 그대로 유지됩니다.
    });
  }

  void _handleCandidateDatesChanged(Set<DateTime> selectedDates) {
    setState(() {
      _selectedCandidateDates
        ..clear()
        ..addAll(selectedDates.map(DateUtils.dateOnly));
    });
  }

  void _toggleCalendarExpanded() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
    });
  }

  String _formatMonth(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}. $month';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.closeOnly(
        title: '밋잇 생성하기',
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
                        text: '모임 이름',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '이름',
                        controller: _meetingNameController,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '후보 날짜 선택',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),

                      _buildMonthHeader(context),
                      const SizedBox(height: AppSpacing.x14),

                      CalendarMonthView(
                        focusedMonth: _focusedMonth,
                        today: _today,
                        selectedDays: _selectedCandidateDates,
                        isExpanded: _isCalendarExpanded,
                        onSelectionChanged: _handleCandidateDatesChanged,
                      ),

                      const SizedBox(height: AppSpacing.x4),
                      _buildCalendarExpandButton(context),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '후보 시간대 선택',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '시작',
                                  style: FontStyles.med14.copyWith(
                                    color: context.colors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.x8),
                                AppTextField(
                                  hintText: '시작 시간',
                                  controller: _startTimeController,
                                  suffixIcon: SvgPicture.asset(
                                    'assets/icons/cal/clock.svg',
                                  ),
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.x14,
                            ),
                            child: Text(
                              '-',
                              style: FontStyles.med14.copyWith(
                                color: context.colors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '종료',
                                  style: FontStyles.med14.copyWith(
                                    color: context.colors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.x8),
                                AppTextField(
                                  hintText: '끝나는 시간',
                                  controller: _endTimeController,
                                  suffixIcon: SvgPicture.asset(
                                    'assets/icons/cal/clock.svg',
                                  ),
                                  onChanged: (_) {
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.x30),

                      _RequiredLabel(
                        text: '참여 인원',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(top: AppSpacing.x8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            const _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            const _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            const _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            const _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            const _MemberInfoButton(
                              memberImage: 'assets/images/exProfile.jpg',
                              memberName: '송하은',
                              memberPart: '베이스',
                            ),
                            _AddButton(
                              onPressed: () {
                                debugPrint('추가 버튼 선택됨.');
                              },
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
                text: '등록하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: () {
                  debugPrint(
                    '선택한 후보 날짜: ${_selectedCandidateDates.toList()..sort()}',
                  );
                  // TODO: 밋잇 생성 API 연결
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    return CalendarMonthDropdown(
      selectedMonth: _focusedMonth,
      firstMonth: _firstCalendarMonth,
      lastMonth: _lastCalendarMonth,
      onMonthSelected: _handleMonthSelected,
      alignmentOffset: const Offset(0, 40),
      triggerBuilder: (context, controller) {
        return Semantics(
          button: true,
          expanded: controller.isOpen,
          label: '후보 날짜 월 선택',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (controller.isOpen) {
                controller.close();
                return;
              }

              controller.open();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatMonth(_focusedMonth),
                  style: FontStyles.bold22.copyWith(
                    color: context.colors.onSurface,
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                RotatedBox(
                  quarterTurns: controller.isOpen ? 2 : 0,
                  child: SvgPicture.asset(
                    'assets/icons/cal/toggle_down.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      context.colors.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarExpandButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Semantics(
        button: true,
        expanded: _isCalendarExpanded,
        label: _isCalendarExpanded ? '달력 접기' : '달력 전체 펼치기',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleCalendarExpanded,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x8),
            child: RotatedBox(
              quarterTurns: _isCalendarExpanded ? 2 : 0,
              child: SvgPicture.asset(
                'assets/icons/meetit/back.svg',
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  context.colors.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
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
      onTap: onPressed,
      child: Container(
        height: 34.0,
        width: 34.0,
        decoration: ShapeDecoration(
          color: context.grays.gray8,
          shape: const OvalBorder(),
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
                  shape: const OvalBorder(),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('삭제 버튼 클릭됨');
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
          style: FontStyles.med16.copyWith(color: color),
          children: [
            TextSpan(text: text),
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
