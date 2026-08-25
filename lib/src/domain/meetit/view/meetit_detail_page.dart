import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_detail_response.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_edit_page.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/meetit_time_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum _MeetingTimeFilter { everyone, mostAvailable }

class MeetitDetailPage extends StatefulWidget {
  const MeetitDetailPage({super.key, this.detail, this.currentUserId = 5});

  /// 실제 API 연결 후에는 response.data를 그대로 전달합니다.
  /// null이면 명세와 동일한 sample 응답으로 화면을 확인합니다.
  final MeetitDetailData? detail;
  final int currentUserId;

  factory MeetitDetailPage.fromResponse({
    Key? key,
    required Map<String, dynamic> response,
    required int currentUserId,
  }) {
    return MeetitDetailPage(
      key: key,
      detail: MeetitDetailResponse.fromJson(response).data,
      currentUserId: currentUserId,
    );
  }

  @override
  State<MeetitDetailPage> createState() => _MeetitDetailPageState();
}

class _MeetitDetailPageState extends State<MeetitDetailPage> {
  _MeetingTimeFilter? _selectedTimeFilter;
  final Set<int> _selectedParticipantIds = <int>{};
  bool _isMeetingSummaryExpanded = false;

  MeetitDetailData get _data => widget.detail ?? MeetitDetailData.sample;

  List<DateTime> get _dates {
    return _data.candidateDates
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .map(DateUtils.dateOnly)
        .toList(growable: false);
  }

  TimeOfDay get _startTime => _parseTimeOfDay(_data.startTime);
  TimeOfDay get _endTime => _parseTimeOfDay(_data.endTime);

  MeetitTimeGridSummaryFilter get _summaryFilter {
    return switch (_selectedTimeFilter) {
      _MeetingTimeFilter.everyone => MeetitTimeGridSummaryFilter.everyone,
      _MeetingTimeFilter.mostAvailable =>
        MeetitTimeGridSummaryFilter.mostAvailable,
      null => MeetitTimeGridSummaryFilter.heatmap,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final data = _data;

    return Scaffold(
      appBar: AppTopAppBar.backMore(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
        onMorePressed: () {},
        moreMenuOffset: const Offset(-16, 56),
        moreMenuItems: [
          AppDropdownItem(label: '수정하기', onPressed: _openEditPage),
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          letterSpacing: -0.68,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x16),
                      _buildMeetingSummary(context, data),
                      const SizedBox(height: AppSpacing.x16),
                      _buildTimeFilter(context, data),
                      const SizedBox(height: AppSpacing.x24),
                      _buildParticipantFilter(context, data),
                      const SizedBox(height: AppSpacing.x24),
                      _buildTimeTable(context, data),
                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '수정하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: _openEditPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingSummary(BuildContext context, MeetitDetailData data) {
    /// 여기서는 timetableGrid를 보고 최적 시간을 다시 계산하지 않습니다.
    /// 서버가 내려준 maxMemberOptimalSlots의 순서와 범위를 그대로 표시합니다.
    final suggestions = data.maxMemberOptimalSlots;
    final visibleSuggestions = _isMeetingSummaryExpanded
        ? suggestions
        : suggestions.take(1).toList(growable: false);

    return AnimatedSize(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x14,
        ),
        decoration: BoxDecoration(
          color: context.grays.gray8,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/meetit/clock.svg',
                  height: 16.0,
                  width: 16.0,
                  colorFilter: ColorFilter.mode(
                    context.grays.gray1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                    child: Text(
                      '우리 모임 날짜',
                      style: FontStyles.semi14.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x8),
                  if (visibleSuggestions.isEmpty)
                    Text(
                      '아직 모두가 가능한 시간이 없어요.',
                      style: FontStyles.med14.copyWith(
                        color: context.grays.gray3,
                      ),
                    )
                  else
                    for (
                      var index = 0;
                      index < visibleSuggestions.length;
                      index++
                    ) ...[
                      if (index > 0) const SizedBox(height: AppSpacing.x20),
                      _buildMeetingSuggestion(
                        context,
                        suggestion: visibleSuggestions[index],
                        totalInvitedCount: data.totalInvitedCount,
                        availableCount: data.maxOverlappingCount,
                      ),
                    ],
                  if (suggestions.length > 1) ...[
                    const SizedBox(height: AppSpacing.x8),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        right: 40.0,
                      ),
                      child: Center(
                        child: Semantics(
                          button: true,
                          label: _isMeetingSummaryExpanded
                              ? '모임 날짜 목록 접기'
                              : '모임 날짜 목록 펼치기',
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                _isMeetingSummaryExpanded =
                                    !_isMeetingSummaryExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.x8),
                              child: AnimatedRotation(
                                turns: _isMeetingSummaryExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOutCubic,
                                child: SvgPicture.asset(
                                  'assets/icons/meetit/back.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingSuggestion(
    BuildContext context, {
    required MeetitOptimalSlot suggestion,
    required int totalInvitedCount,
    required int availableCount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatOptimalSlot(suggestion),
          style: FontStyles.semi20.copyWith(color: context.grays.black),
        ),
        const SizedBox(height: AppSpacing.x10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x10,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: context.grays.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/meetit/people.svg',
                height: 14.0,
                width: 14.0,
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(
                '$totalInvitedCount명',
                style: FontStyles.med12.copyWith(color: context.grays.gray2),
              ),
              Text(
                ' • ',
                style: FontStyles.med12.copyWith(color: context.grays.gray2),
              ),
              Text(
                '$availableCount명 가능',
                style: FontStyles.med12.copyWith(
                  color: context.brands.beatOrange1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilter(BuildContext context, MeetitDetailData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          text: '모임 시간',
          iconPath: 'assets/icons/meetit/clock.svg',
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.x10),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: [
            AppToggle(
              text: '모임 전체',
              isSelected: _selectedTimeFilter == _MeetingTimeFilter.everyone,
              onChanged: (selected) {
                _onTimeFilterChanged(_MeetingTimeFilter.everyone, selected);
              },
            ),
            AppToggle(
              text:
                  '가장 많이 되는 시간 (${data.maxOverlappingCount}/${data.totalInvitedCount})',
              isSelected:
                  _selectedTimeFilter == _MeetingTimeFilter.mostAvailable,
              onChanged: (selected) {
                _onTimeFilterChanged(
                  _MeetingTimeFilter.mostAvailable,
                  selected,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _onTimeFilterChanged(_MeetingTimeFilter filter, bool selected) {
    setState(() {
      _selectedParticipantIds.clear();
      _selectedTimeFilter = selected ? filter : null;
    });
  }

  Widget _buildParticipantFilter(BuildContext context, MeetitDetailData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          text: '참여자 (${data.respondedCount})',
          iconPath: 'assets/icons/meetit/people.svg',
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(height: AppSpacing.x10),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: data.respondedParticipants
              .map((participant) {
                final isSelected = _selectedParticipantIds.contains(
                  participant.userId,
                );
                return AppToggle(
                  text: participant.name,
                  isSelected: isSelected,
                  onChanged: (selected) {
                    setState(() {
                      _selectedTimeFilter = null;
                      if (selected) {
                        _selectedParticipantIds.add(participant.userId);
                      } else {
                        _selectedParticipantIds.remove(participant.userId);
                      }
                    });
                  },
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildTimeTable(BuildContext context, MeetitDetailData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          text: '시간표',
          iconPath: 'assets/icons/meetit/calendar.svg',
          color: Theme.of(context).colorScheme.onSurface,
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
                '참여자들이 선택한 시간을 확인할 수 있어요.',
                style: FontStyles.med14.copyWith(color: context.grays.gray5),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x12),
        MeetitTimeGrid(
          dates: _dates,
          startTime: _startTime,
          endTime: _endTime,
          timetableGrid: data.timetableGrid,
          totalInvitedCount: data.totalInvitedCount,
          mode: MeetitTimeGridMode.detail,
          summaryFilter: _summaryFilter,
          selectedParticipantIds: _selectedParticipantIds,
          entireMemberOptimalSlots: data.entireMemberOptimalSlots,
          maxMemberOptimalSlots: data.maxMemberOptimalSlots,
        ),
      ],
    );
  }

  Future<void> _openEditPage() async {
    final data = _data;

    await Navigator.of(context).push<Set<DateTime>>(
      MaterialPageRoute<Set<DateTime>>(
        builder: (_) => MeetitEditPage(
          title: data.title,
          candidateDates: _dates,
          startTime: _startTime,
          endTime: _endTime,
          timetableGrid: data.timetableGrid,
          totalInvitedCount: data.totalInvitedCount,
          currentUserId: widget.currentUserId,
        ),
      ),
    );

    // 상세 화면은 서버 응답을 Source of Truth로 사용합니다.
    // 실제 API 연결 후에는 수정 저장 성공 시 상세 API를 재조회해 새 응답으로 갱신합니다.
  }

  TimeOfDay _parseTimeOfDay(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return const TimeOfDay(hour: 0, minute: 0);

    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatOptimalSlot(MeetitOptimalSlot slot) {
    final date = DateTime.tryParse(slot.date);
    if (date == null) {
      return '${slot.date} ${slot.startTime} - ${slot.endTime}';
    }

    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}/${date.day} $weekday요일 '
        '${_formatTime(_parseTimeOfDay(slot.startTime))} - '
        '${_formatTime(_parseTimeOfDay(slot.endTime))}';
  }

  String _formatTime(TimeOfDay time) {
    final isAm = time.hour < 12;
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    if (time.minute == 0) {
      return '${isAm ? '오전' : '오후'} ${hour12}시';
    }
    return '${isAm ? '오전' : '오후'} ${hour12}시 ${time.minute}분';
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
