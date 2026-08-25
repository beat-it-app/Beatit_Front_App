import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_detail_response.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/meetit_switch_widget.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/meetit_time_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetitEditPage extends StatefulWidget {
  const MeetitEditPage({
    super.key,
    required this.title,
    required this.candidateDates,
    required this.startTime,
    required this.endTime,
    required this.timetableGrid,
    required this.totalInvitedCount,
    required this.currentUserId,
  });

  final String title;
  final List<DateTime> candidateDates;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<MeetitTimetableSlot> timetableGrid;
  final int totalInvitedCount;
  final int currentUserId;

  @override
  State<MeetitEditPage> createState() => _MeetitEditPageState();
}

class _MeetitEditPageState extends State<MeetitEditPage> {
  bool _showAllSchedule = false;
  bool _isGridGestureActive = false;
  Set<DateTime> _mySelection = <DateTime>{};

  @override
  void initState() {
    super.initState();
    _mySelection = _selectionFromResponse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backMore(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
        onMorePressed: () {},
        moreMenuOffset: const Offset(-16, 56),
        moreMenuItems: [
          AppDropdownItem(
            label: '삭제하기',
            onPressed: () {
              debugPrint('삭제');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x24,
            AppSpacing.x16,
            0,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  // 그리드 안에서 pointerDown이 발생하면 세로 스크롤을 즉시 잠급니다.
                  // 그래서 위/아래로 드래그해도 페이지가 움직이지 않고 셀 선택만 됩니다.
                  physics: _isGridGestureActive
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          letterSpacing: -0.68,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x24),
                      _buildTimeTable(context),
                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '작성 완료',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                isDisabled: _showAllSchedule,
                onPressed: () {
                  Navigator.of(context).pop(Set<DateTime>.of(_mySelection));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionLabel(
              text: '시간표',
              iconPath: 'assets/icons/meetit/calendar.svg',
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '전체 시간표',
                  style: FontStyles.med12.copyWith(
                    color: _showAllSchedule
                        ? context.brands.beatOrange1
                        : context.grays.gray3,
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                MeetitSwitchWidget(
                  initialValue: _showAllSchedule,
                  onCheckChange: (isShow) {
                    setState(() {
                      _showAllSchedule = isShow;
                      _isGridGestureActive = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/meetit/information.svg',
              height: 14.0,
              width: 14.0,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Text(
                _showAllSchedule
                    ? '현재 수정 내용과 전체 시간표를 함께 표시하며, 이 상태에서는 수정할 수 없어요.'
                    : '아래 시간표를 드래그하여 참여 가능한 시간을 체크해주세요.',
                style: FontStyles.med14.copyWith(color: context.grays.gray5),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x12),
        MeetitTimeGrid(
          dates: widget.candidateDates,
          startTime: widget.startTime,
          endTime: widget.endTime,
          timetableGrid: widget.timetableGrid,
          totalInvitedCount: widget.totalInvitedCount,
          mode: MeetitTimeGridMode.edit,
          editableSelection: _mySelection,
          editableUserId: widget.currentUserId,
          showAllSchedule: _showAllSchedule,
          onEditableSelectionChanged: (nextSelection) {
            setState(() {
              _mySelection = Set<DateTime>.of(nextSelection);
            });
          },
          onEditGestureStateChanged: (isActive) {
            if (_isGridGestureActive == isActive) return;
            setState(() {
              _isGridGestureActive = isActive;
            });
          },
        ),
      ],
    );
  }

  /// 현재 사용자의 선택 역시 서버 timetableGrid의 availableUserIds에서 읽습니다.
  /// 별도의 participant availability 더미를 만들지 않습니다.
  Set<DateTime> _selectionFromResponse() {
    final result = <DateTime>{};

    for (final slot in widget.timetableGrid) {
      if (!slot.availableUserIds.contains(widget.currentUserId)) continue;

      final parsed = _parseSlotStartTime(slot.slotStartTime);
      if (parsed != null) {
        result.add(parsed);
      }
    }

    return result;
  }

  DateTime? _parseSlotStartTime(String value) {
    if (value.length < 16) return null;
    return DateTime.tryParse(value.substring(0, 16));
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.text,
    required this.iconPath,
    required this.color,
  });

  final String text;
  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 18.0,
            width: 18.0,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 6.0),
          Text(text, style: FontStyles.semi16.copyWith(color: color)),
        ],
      ),
    );
  }
}
