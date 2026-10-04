import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_detail_response.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_edit_page.dart';
import 'package:beatit_front_app/src/domain/meetit/widget/meetit_time_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum _MeetingTimeFilter { everyone, mostAvailable }

class MeetitDetailPage extends ConsumerStatefulWidget {
  const MeetitDetailPage({
    super.key,
    this.meetitId,
    this.detail,
    this.currentUserId,
  });

  final int? meetitId;

  final MeetitDetailData? detail;
  final int? currentUserId;

  factory MeetitDetailPage.fromResponse({
    Key? key,
    required Map<String, dynamic> response,
    required int currentUserId,
  }) {
    final detail = MeetitDetailResponse.fromJson(response).data;
    return MeetitDetailPage(
      key: key,
      meetitId: detail.meetitId,
      detail: detail,
      currentUserId: currentUserId,
    );
  }

  @override
  ConsumerState<MeetitDetailPage> createState() => _MeetitDetailPageState();
}

class _MeetitDetailPageState extends ConsumerState<MeetitDetailPage> {
  _MeetingTimeFilter? _selectedTimeFilter;
  final Set<int> _selectedParticipantIds = <int>{};
  bool _isMeetingSummaryExpanded = false;

  MeetitDetailData? _loadedDetail;
  String? _error;
  MeetitDetailData get _data => _loadedDetail ?? widget.detail!;

  @override
  void initState() {
    super.initState();
    if (widget.detail == null) Future.microtask(_load);
  }

  Future<void> _load() async {
    if (widget.meetitId == null) {
      setState(() => _error = '밋잇 ID가 없습니다.');
      return;
    }
    try {
      final detail = await ref
          .read(postApiProvider)
          .getMeetit(widget.meetitId!);
      if (mounted)
        setState(() {
          _loadedDetail = detail;
          _error = null;
        });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  List<DateTime> get _dates {
    return _data.candidateDates
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .map(DateUtils.dateOnly)
        .toList(growable: false);
  }

  TimeOfDay get _startTime => _data.dateOnly
      ? const TimeOfDay(hour: 0, minute: 0)
      : _parseTimeOfDay(_data.startTime);
  TimeOfDay get _endTime => _data.dateOnly
      ? const TimeOfDay(hour: 0, minute: 30)
      : _parseTimeOfDay(_data.endTime);

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
    if (_loadedDetail == null && widget.detail == null) {
      return Scaffold(
        body: Center(
          child: _error == null
              ? const CircularProgressIndicator()
              : Text(_error!),
        ),
      );
    }
    final colors = Theme.of(context).colorScheme;
    final data = _data;

    return Scaffold(
      appBar: _buildAppBar(data),
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
                      const SizedBox(height: AppSpacing.x10),
                      if (data.maxMemberOptimalSlots.isNotEmpty) ...[
                        _SectionLabel(
                          text: '우리 모임 날짜',
                          iconPath: 'assets/icons/meetit/clock.svg',
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: AppSpacing.x10),
                        _buildMeetingSummary(context, data),
                        const SizedBox(height: AppSpacing.x16),
                      ],
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
                text: data.isParticipant
                    ? (_hasCurrentUserResponded(data) ? '수정하기' : '응답하기')
                    : '응답할 수 없음',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                isDisabled: !data.isParticipant,
                onPressed: data.isParticipant ? _openEditPage : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(MeetitDetailData data) {
    final currentUserId = _currentUserId;
    final isCreator = currentUserId != null && data.creatorId == currentUserId;
    final items = <AppDropdownItem>[
      if (data.isParticipant)
        AppDropdownItem(
          label: _hasCurrentUserResponded(data) ? '수정하기' : '응답하기',
          onPressed: _openEditPage,
        ),
      if (isCreator)
        AppDropdownItem(
          label: '삭제하기',
          onPressed: _confirmDelete,
        ),
    ];

    if (items.isEmpty) {
      return AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).maybePop(),
      );
    }

    return AppTopAppBar.backMore(
      onBackPressed: () => Navigator.of(context).maybePop(),
      moreMenuOffset: const Offset(-16, 56),
      moreMenuItems: items,
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await AppPopup.show(
      context,
      title: '삭제하시겠습니까?',
      content: '삭제한 내용은 복구할 수 없습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.circle,
      confirmText: '삭제',
      cancelText: '취소',
    );
    if (confirmed != true || !mounted) return;

    await _deleteMeetit();
  }

  Future<void> _deleteMeetit() async {
    final meetitId = _data.meetitId;
    try {
      await ref.read(postApiProvider).deleteMeetit(meetitId);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Widget _buildMeetingSummary(BuildContext context, MeetitDetailData data) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvailabilityBadge(
              context,
              totalInvitedCount: data.totalInvitedCount,
              availableCount: data.maxOverlappingCount,
            ),
            const SizedBox(height: AppSpacing.x14),
            if (visibleSuggestions.isEmpty)
              Text(
                '아직 가능한 시간이 없어요.',
                style: FontStyles.med14.copyWith(color: context.grays.gray3),
              )
            else
              for (var index = 0; index < visibleSuggestions.length; index++) ...[
                if (index > 0) const SizedBox(height: AppSpacing.x20),
                _buildMeetingSuggestion(
                  context,
                  suggestion: visibleSuggestions[index],
                  dateOnly: data.dateOnly,
                ),
              ],
            if (suggestions.length > 1) ...[
              const SizedBox(height: AppSpacing.x8),
              Center(
                child: Semantics(
                  button: true,
                  label: _isMeetingSummaryExpanded
                      ? '모임 날짜 목록 접기'
                      : '모임 날짜 목록 펼치기',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _isMeetingSummaryExpanded = !_isMeetingSummaryExpanded;
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
                          width: 22,
                          height: 22,
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
    );
  }

  Widget _buildAvailabilityBadge(
    BuildContext context, {
    required int totalInvitedCount,
    required int availableCount,
  }) {
    return Container(
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
    );
  }

  Widget _buildMeetingSuggestion(
    BuildContext context, {
    required MeetitOptimalSlot suggestion,
    required bool dateOnly,
  }) {
    return Text(
      _formatOptimalSlot(suggestion, dateOnly: dateOnly),
      style: FontStyles.semi20.copyWith(color: context.grays.black),
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
    final currentUserId = _currentUserId;
    if (currentUserId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('사용자 정보를 불러올 수 없습니다.')));
      return;
    }
    if (!data.isParticipant) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('밋잇 참여 대상이 아닙니다.')));
      return;
    }

    final result = await Navigator.of(context).push<MeetitEditResult>(
      MaterialPageRoute<MeetitEditResult>(
        builder: (_) => MeetitEditPage(
          title: data.title,
          candidateDates: _dates,
          startTime: _startTime,
          endTime: _endTime,
          timetableGrid: data.timetableGrid,
          totalInvitedCount: data.totalInvitedCount,
          currentUserId: currentUserId,
          dateOnly: data.dateOnly,
          isCreator: data.creatorId == currentUserId,
        ),
      ),
    );

    if (result == null || !mounted) return;
    if (result.deleteRequested) {
      await _deleteMeetit();
      return;
    }

    final selected = result.selection;
    if (selected == null) return;

    try {
      await ref.read(postApiProvider).submitMeetitResponse(
        data.meetitId,
        selected,
        dateOnly: data.dateOnly,
      );
      await _load();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  int? get _currentUserId =>
      widget.currentUserId ?? ref.read(authProvider).value?.userId;

  bool _hasCurrentUserResponded(MeetitDetailData data) {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return false;

    return data.respondedParticipants.any(
      (participant) => participant.userId == currentUserId,
    );
  }

  TimeOfDay _parseTimeOfDay(String? value) {
    final parts = (value ?? '').split(':');
    if (parts.length < 2) return const TimeOfDay(hour: 0, minute: 0);

    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatOptimalSlot(
    MeetitOptimalSlot slot, {
    required bool dateOnly,
  }) {
    final start = slot.wallClockStart;
    final end = slot.wallClockEnd;
    if (start == null || end == null) {
      return '${slot.startDateTime} - ${slot.endDateTime}';
    }

    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[start.weekday - 1];
    final dateText = '${start.month}/${start.day} $weekday요일';

    if (dateOnly) return dateText;

    return '$dateText ${_formatTime(TimeOfDay.fromDateTime(start))} - '
        '${_formatTime(TimeOfDay.fromDateTime(end))}';
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
