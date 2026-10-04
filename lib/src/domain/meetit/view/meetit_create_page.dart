import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottomsheets/app_time_bottomsheet.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/calendar_month_dropdown.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/calendar_month_view.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/add_member_button.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/meetit_switch_widget.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_create_request.dart';
import 'package:beatit_front_app/src/domain/etc/view/member_selection_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetitCreatePage extends ConsumerStatefulWidget {
  const MeetitCreatePage({super.key});

  @override
  ConsumerState<MeetitCreatePage> createState() => _MeetitCreatePageState();
}

class _MeetitCreatePageState extends ConsumerState<MeetitCreatePage> {
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
  bool _dateOnly = false;
  final List<MemberSelectionMember> _members = <MemberSelectionMember>[];
  bool _submitting = false;

  String? _meetingNameError;
  String? _candidateDatesError;
  String? _timeError;
  String? _membersError;

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
      if (_candidateDatesError != null && _selectedCandidateDates.isNotEmpty) {
        _candidateDatesError = null;
      }
    });
  }

  void _toggleCalendarExpanded() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
    });
  }

  void _setDateOnly(bool selected) {
    setState(() {
      _dateOnly = selected;
      if (selected) {
        _startTimeController.clear();
        _endTimeController.clear();
        _timeError = null;
      }
    });
  }

  Future<void> _chooseMembers() async {
    final selected = await Navigator.of(context).push<List<MemberSelectionMember>>(
      MaterialPageRoute(builder: (_) => MemberSelectionPage(
        initialSelectedMemberIds: _members.map((member) => member.id).toSet(),
        initialSelectedUserIds: _members.map((member) => member.userId).whereType<int>().toSet(),
      )),
    );
    if (!mounted || selected == null) return;

    setState(() {
      _members
        ..clear()
        ..addAll(selected);
      if (_membersError != null) {
        _membersError = _membersValidationMessage();
      }
    });
  }

  Future<void> _confirmClose() async {
    final confirmed = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.circle,
      contentType: ContentType.small,
      confirmText: '확인',
      cancelText: '취소',
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _chooseTime(TextEditingController controller) async {
    final parts = controller.text.split(':');
    final initialTime = parts.length == 2
        ? TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]))
        : const TimeOfDay(hour: 9, minute: 0);
    final time = await AppTimeBottomSheet.showTimePicker(
      context,
      title: identical(controller, _startTimeController)
          ? '시작 시간 선택' : '끝나는 시간 선택',
      initialTime: initialTime,
      minuteInterval: 30,
    );
    if (time == null || !mounted) return;
    setState(() {
      controller.text =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      if (_timeError != null) {
        _timeError = _timeValidationMessage();
      }
    });
  }

  String? _timeValidationMessage() {
    if (_dateOnly) return null;

    final start = _startTimeController.text.trim();
    final end = _endTimeController.text.trim();

    if (start.isEmpty && end.isEmpty) {
      return '시작 시간과 종료 시간을 모두 입력해주세요.';
    }
    if (start.isEmpty) {
      return '시작 시간을 입력해주세요.';
    }
    if (end.isEmpty) {
      return '종료 시간을 입력해주세요.';
    }

    final timePattern = RegExp(r'^(?:[01]\d|2[0-3]):(?:00|30)$');
    if (!timePattern.hasMatch(start) || !timePattern.hasMatch(end)) {
      return '시간은 30분 단위로 선택해주세요.';
    }
    if (start.compareTo(end) >= 0) {
      return '종료 시간은 시작 시간보다 늦게 설정해주세요.';
    }

    return null;
  }

  String? _membersValidationMessage() {
    final userIds = _members
        .map((member) => member.userId)
        .whereType<int>()
        .toSet();
    return userIds.length < 2 ? '참여 인원을 2명 이상 선택해주세요.' : null;
  }

  bool _validateRequiredFields() {
    final name = _meetingNameController.text.trim();

    setState(() {
      _meetingNameError = name.isEmpty ? '모임 이름을 입력해주세요.' : null;
      _candidateDatesError = _selectedCandidateDates.isEmpty
          ? '후보 날짜를 1개 이상 선택해주세요.'
          : null;
      _timeError = _timeValidationMessage();
      _membersError = _membersValidationMessage();
    });

    return _meetingNameError == null &&
        _candidateDatesError == null &&
        _timeError == null &&
        _membersError == null;
  }

  bool get _startTimeHasError {
    if (_timeError == null || _dateOnly) return false;
    final start = _startTimeController.text.trim();
    final end = _endTimeController.text.trim();
    return start.isEmpty || (start.isNotEmpty && end.isNotEmpty);
  }

  bool get _endTimeHasError {
    if (_timeError == null || _dateOnly) return false;
    final start = _startTimeController.text.trim();
    final end = _endTimeController.text.trim();
    return end.isEmpty || (start.isNotEmpty && end.isNotEmpty);
  }

  void _handleMeetingNameChanged(String value) {
    if (_meetingNameError != null && value.trim().isNotEmpty) {
      setState(() => _meetingNameError = null);
    }
  }

  Future<void> _submit() async {
    if (_submitting || !_validateRequiredFields()) return;

    final name = _meetingNameController.text.trim();
    final dates = _selectedCandidateDates.toList()..sort();
    final userIds = _members
        .map((member) => member.userId)
        .whereType<int>()
        .toSet()
        .toList();
    final start = _startTimeController.text.trim();
    final end = _endTimeController.text.trim();
    final dateOnly = _dateOnly;

    setState(() => _submitting = true);
    try {
      await ref.read(postApiProvider).createMeetit(MeetitCreateRequest(
        title: name,
        candidateDates: dates.map((date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}').toList(),
        startTime: dateOnly ? null : start, endTime: dateOnly ? null : end,
        dateOnly: dateOnly, participantUserIds: userIds,
      ));
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally { if (mounted) setState(() => _submitting = false); }
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
        onClosePressed: _confirmClose,
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
                        errorText: _meetingNameError,
                        onChanged: _handleMeetingNameChanged,
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
                      if (_candidateDatesError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: _candidateDatesError!,
                          isError: true,
                        ),
                      ],

                      const SizedBox(height: AppSpacing.x20),

                      Row(
                        children: [
                          _RequiredLabel(
                            text: '후보 시간대 선택',
                            color: colors.onSurface,
                            requiredColor: _dateOnly ? null : colors.primary,
                          ),
                          const Spacer(),
                          Text('날짜만 선택', style: FontStyles.med14.copyWith(
                            color: context.colors.onSurface,
                          )),
                          const SizedBox(width: AppSpacing.x8),
                          MeetitSwitchWidget(
                            initialValue: _dateOnly,
                            onCheckChange: _setDateOnly,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      if (!_dateOnly) Row(
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
                                  readOnly: true,
                                  isError: _startTimeHasError,
                                  onTap: () => _chooseTime(_startTimeController),
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
                                  readOnly: true,
                                  isError: _endTimeHasError,
                                  onTap: () => _chooseTime(_endTimeController),
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
                      if (!_dateOnly && _timeError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: _timeError!,
                          isError: true,
                        ),
                      ],

                      const SizedBox(height: AppSpacing.x30),

                      _RequiredLabel(
                        text: '참여 인원',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      if (_members.isEmpty)
                        AddMemberButton(
                          text: '인원 선택하기',
                          onPressed: _chooseMembers,
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(top: AppSpacing.x8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...List.generate(_members.length, (index) {
                                final member = _members[index];
                                return _MemberInfoButton(
                                  memberImage: member.profileImageUrl,
                                  memberName: member.name,
                                  memberPart: member.position ?? '',
                                  onRemove: () {
                                    setState(() {
                                      _members.removeAt(index);
                                      if (_membersError != null) {
                                        _membersError =
                                            _membersValidationMessage();
                                      }
                                    });
                                  },
                                );
                              }),
                              const SizedBox(width: AppSpacing.x8),
                              _AddButton(onPressed: _chooseMembers),
                              const SizedBox(width: AppSpacing.x8),
                            ],
                          ),
                        ),
                      if (_membersError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: _membersError!,
                          isError: true,
                        ),
                      ],
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
                onPressed: _submit,
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
    required this.onRemove,
    required this.memberName,
    required this.memberPart,
    required this.memberImage,
  });

  final String memberName;
  final String memberPart;
  final String? memberImage;
  final VoidCallback onRemove;

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
                    image: memberImage == null || memberImage!.isEmpty ? const AssetImage('assets/images/exProfile.jpg') : NetworkImage(memberImage!) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onRemove,
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
    this.requiredColor,
  });

  final String text;
  final Color color;
  final Color? requiredColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: FontStyles.med16.copyWith(color: color),
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
