import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_detail_response.dart';
import 'package:flutter/material.dart';

enum MeetitTimeGridMode { detail, edit }

enum MeetitTimeGridSummaryFilter { heatmap, everyone, mostAvailable }

class MeetitTimeGrid extends StatefulWidget {
  const MeetitTimeGrid({
    super.key,
    required this.dates,
    required this.startTime,
    required this.endTime,
    required this.timetableGrid,
    required this.totalInvitedCount,
    this.dateOnly = false,
    this.mode = MeetitTimeGridMode.detail,
    this.summaryFilter = MeetitTimeGridSummaryFilter.heatmap,
    this.selectedParticipantIds = const <int>{},
    this.entireMemberOptimalSlots = const <MeetitOptimalSlot>[],
    this.maxMemberOptimalSlots = const <MeetitOptimalSlot>[],
    this.editableSelection = const <DateTime>{},
    this.showAllSchedule = false,
    this.editableUserId,
    this.onEditableSelectionChanged,
    this.onEditGestureStateChanged,
  });

  /// 백엔드 candidateDates 그대로 파싱한 날짜 목록입니다.
  final List<DateTime> dates;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  /// 백엔드 timetableGrid를 그대로 전달합니다.
  /// 프론트에서 참여자별 availability 목록으로 재구성하지 않습니다.
  final List<MeetitTimetableSlot> timetableGrid;

  /// 기본 heatmap의 색상 강도 기준입니다.
  final int totalInvitedCount;
  final bool dateOnly;

  final MeetitTimeGridMode mode;
  final MeetitTimeGridSummaryFilter summaryFilter;

  /// 참여자 토글에서 선택한 userId입니다.
  final Set<int> selectedParticipantIds;

  /// 서버가 계산해서 내려준 최적 시간 범위를 그대로 사용합니다.
  final List<MeetitOptimalSlot> entireMemberOptimalSlots;
  final List<MeetitOptimalSlot> maxMemberOptimalSlots;

  /// edit 모드에서 현재 사용자가 선택한 30분 셀입니다.
  final Set<DateTime> editableSelection;
  final bool showAllSchedule;

  /// edit 모드에서 현재 수정 중인 사용자의 ID입니다.
  /// 전체 시간표를 켰을 때 서버의 기존 선택을 제거하고 현재 편집값으로 덮어쓰기 위해 사용합니다.
  final int? editableUserId;

  final ValueChanged<Set<DateTime>>? onEditableSelectionChanged;

  /// 편집 그리드에 포인터가 눌려 있는 동안 부모 세로 스크롤을 잠그기 위한 콜백입니다.
  final ValueChanged<bool>? onEditGestureStateChanged;

  @override
  State<MeetitTimeGrid> createState() => _MeetitTimeGridState();
}

class _MeetitTimeGridState extends State<MeetitTimeGrid> {
  static const int _slotMinutes = 30;
  static const double _timeLabelWidth = 65.0;
  static const double _headerHeight = 54.0;

  /// 30분 셀 하나의 고정 크기입니다.
  static const double _cellWidth = 50.0;
  static const double _cellHeight = 40.0;
  static const double _horizontalDragAreaHeight = 40.0;

  /// 자정 이후(00시~종료)와 전날 저녁(시작~24시) 사이의 표시용 공백.
  /// 30분 셀 2개의 높이이므로 정확히 1시간만큼 떨어져 보입니다.
  static const double _overnightGapHeight = _cellHeight * 2;

  final ScrollController _horizontalScrollController = ScrollController();

  /// 최신 백엔드 timetableGrid에는 응답자가 없는 슬롯도 포함됩니다.
  /// 이 목록을 기준으로 활성 칸을 판정해야 다음 날 새벽 날짜가 이중 확장되지 않습니다.
  Set<DateTime> _validSlotStarts = <DateTime>{};

  Set<DateTime> _editableSlots = <DateTime>{};
  Set<DateTime> _dragBaseSelection = <DateTime>{};
  _GridPosition? _dragStart;
  bool _dragAddsSelection = true;
  int? _dateDragStartIndex;
  Set<DateTime> _dateDragBaseSelection = <DateTime>{};
  bool _dateDragAddsSelection = true;

  @override
  void initState() {
    super.initState();
    _editableSlots = _normalizeSlots(widget.editableSelection);
  }

  @override
  void didUpdateWidget(covariant MeetitTimeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(oldWidget.editableSelection, widget.editableSelection)) {
      _editableSlots = _normalizeSlots(widget.editableSelection);
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dates = widget.dates.map(DateUtils.dateOnly).toList(growable: false);
    final slotCount = _slotCount;

    if (dates.isEmpty) {
      return _buildEmptyMessage(context, '선택된 후보 날짜가 없어요.');
    }

    // 날짜만 조율할 때는 30분 시간축을 표시하지 않고 날짜 7개씩 줄바꿈합니다.
    // 참가자별 색상과 '전체/가장 많이 되는 시간' 필터는 기존 셀 계산을 재사용합니다.
    if (widget.dateOnly) {
      return _buildDateOnlyGrid(context, dates);
    }

    if (slotCount <= 0) {
      return _buildEmptyMessage(context, '시작 시간과 종료 시간을 확인해주세요.');
    }

    // 백엔드 candidateDates는 다음 날 새벽을 포함한 실제 슬롯 날짜입니다.
    // 프론트에서 날짜를 다시 늘리지 않고, 서버가 제공한 슬롯만 활성화합니다.
    _validSlotStarts = widget.timetableGrid
        .map((slot) => _parseSlotStartTime(slot.slotStartTime))
        .whereType<DateTime>()
        .toSet();
    final gridDates = dates;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableGridWidth = math.max(
          0.0,
          constraints.maxWidth - _timeLabelWidth,
        );
        final gridWidth = gridDates.length * _cellWidth;
        final canScrollHorizontally = gridWidth > availableGridWidth;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeLabels(context, slotCount),
            Expanded(
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: canScrollHorizontally,
                interactive: true,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: _canEdit
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: gridWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDateHeader(context, gridDates),
                        _buildDataGrid(
                          context,
                          dates: gridDates,
                          slotCount: slotCount,
                        ),
                        _buildHorizontalDragArea(canScrollHorizontally),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateOnlyGrid(BuildContext context, List<DateTime> dates) {
    const columnsPerRow = 7;
    final rowCount = (dates.length / columnsPerRow).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.x16),
          LayoutBuilder(
            builder: (context, constraints) {
              final rowStart = row * columnsPerRow;
              final visibleCount = math.min(columnsPerRow, dates.length - rowStart);
              final columnWidth = constraints.maxWidth / columnsPerRow;
              int indexAt(double x) {
                final column = (x / columnWidth).floor().clamp(0, visibleCount - 1);
                return rowStart + column.toInt();
              }

              final rowCells = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var column = 0; column < columnsPerRow; column++)
                    Expanded(
                      child: column < visibleCount
                          ? _buildDateOnlyCell(context, dates[rowStart + column])
                          : const SizedBox.shrink(),
                    ),
                ],
              );
              if (!_canEdit) return rowCells;

              // 날짜 한 줄도 시간표와 같이 손가락이 지나간 모든 셀을 선택/해제합니다.
              return Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  _dateDragStartIndex = indexAt(event.localPosition.dx);
                  widget.onEditGestureStateChanged?.call(true);
                },
                onPointerUp: (_) {
                  widget.onEditGestureStateChanged?.call(false);
                  if (_dateDragBaseSelection.isEmpty) _dateDragStartIndex = null;
                },
                onPointerCancel: (_) {
                  widget.onEditGestureStateChanged?.call(false);
                  _endDateDrag();
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (details) {
                    final index = _dateDragStartIndex ?? indexAt(details.localPosition.dx);
                    _dateDragStartIndex = index;
                    _dateDragBaseSelection = Set<DateTime>.of(_editableSlots);
                    _dateDragAddsSelection = !_editableSlots.contains(dates[index]);
                    _applyDateDrag(dates, index);
                  },
                  onHorizontalDragUpdate: (details) {
                    if (_dateDragStartIndex == null) return;
                    _applyDateDrag(dates, indexAt(details.localPosition.dx));
                  },
                  onHorizontalDragEnd: (_) => _endDateDrag(),
                  onHorizontalDragCancel: _endDateDrag,
                  child: rowCells,
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _applyDateDrag(List<DateTime> dates, int endIndex) {
    final startIndex = _dateDragStartIndex;
    if (startIndex == null) return;
    final next = Set<DateTime>.of(_dateDragBaseSelection);
    for (var index = math.min(startIndex, endIndex);
        index <= math.max(startIndex, endIndex);
        index++) {
      final day = DateUtils.dateOnly(dates[index]);
      if (_dateDragAddsSelection) {
        next.add(day);
      } else {
        next.remove(day);
      }
    }
    _commitEditableSelection(next);
  }

  void _endDateDrag() {
    _dateDragStartIndex = null;
    _dateDragBaseSelection = <DateTime>{};
  }

  Widget _buildDateOnlyCell(BuildContext context, DateTime date) {
    final slotStart = DateUtils.dateOnly(date);
    final enabled = _canEdit;

    return Semantics(
      button: enabled,
      selected: enabled && _editableSlots.contains(slotStart),
      label: '${date.month}월 ${date.day}일 ${_weekdayLabel(date.weekday)}요일',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: !enabled
            ? null
            : () {
                final next = Set<DateTime>.of(_editableSlots);
                if (!next.add(slotStart)) next.remove(slotStart);
                _commitEditableSelection(next);
              },
        child: Column(
          children: [
            Text(
              '${date.month}/${date.day}',
              maxLines: 1,
              style: FontStyles.semi14.copyWith(color: context.grays.gray1),
            ),
            Text(
              _weekdayLabel(date.weekday),
              style: FontStyles.semi16.copyWith(color: context.grays.gray2),
            ),
            const SizedBox(height: AppSpacing.x8),
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: _cellColor(context, slotStart: slotStart),
                border: Border.all(color: context.grays.gray2, width: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalDragArea(bool canScrollHorizontally) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: !canScrollHorizontally
          ? null
          : (details) {
              if (!_horizontalScrollController.hasClients) return;

              final position =
                  (_horizontalScrollController.offset - details.delta.dx)
                      .clamp(
                        0.0,
                        _horizontalScrollController.position.maxScrollExtent,
                      )
                      .toDouble();

              _horizontalScrollController.jumpTo(position);
            },
      child: const SizedBox(
        width: double.infinity,
        height: _horizontalDragAreaHeight,
      ),
    );
  }

  Widget _buildEmptyMessage(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x20),
      alignment: Alignment.center,
      child: Text(
        text,
        style: FontStyles.med14.copyWith(color: context.grays.gray4),
      ),
    );
  }

  Widget _buildTimeLabels(BuildContext context, int slotCount) {
    final gridHeight = slotCount * _cellHeight + _gapHeight;

    return SizedBox(
      width: _timeLabelWidth,
      height: _headerHeight + gridHeight + _horizontalDragAreaHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_gapHeight > 0) ...[
            // 위쪽 새벽 구간과 아래쪽 저녁 구간은 각각의 시간축을 표시합니다.
            // 새벽 종료/저녁 시작 경계에는 서로 다른 라벨이 필요합니다.
            for (var boundary = 0; boundary <= _tailRows; boundary++)
              if ((boundary * _slotMinutes) % 60 == 0)
                _buildTimeLabel(context, boundary * _slotMinutes,
                    boundary * _cellHeight),
            for (var boundary = _tailRows; boundary <= slotCount; boundary++)
              if ((_startMinutes +
                          (boundary - _tailRows) * _slotMinutes) %
                      60 ==
                  0)
                _buildTimeLabel(
                  context,
                  _startMinutes + (boundary - _tailRows) * _slotMinutes,
                  boundary * _cellHeight + _gapHeight,
                ),
          ] else ...[
            for (var boundary = 0; boundary <= slotCount; boundary++)
              if (_minutesForBoundary(boundary) % 60 == 0)
                _buildTimeLabel(
                  context,
                  _minutesForBoundary(boundary),
                  boundary * _cellHeight,
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeLabel(
    BuildContext context,
    int minutes,
    double top,
  ) {
    return Positioned(
      left: 0,
      top: _headerHeight + top - 8.0,
      child: Text(
        _formatTime(minutes),
        style: FontStyles.reg14.copyWith(color: context.grays.gray2),
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, List<DateTime> dates) {
    return SizedBox(
      height: _headerHeight,
      child: Row(
        children: [
          for (final date in dates)
            SizedBox(
              width: _cellWidth,
              height: _headerHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.month}/${date.day}',
                    style: FontStyles.semi14.copyWith(
                      color: context.grays.gray1,
                    ),
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    _weekdayLabel(date.weekday),
                    style: FontStyles.semi16.copyWith(
                      color: context.grays.gray2,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataGrid(
    BuildContext context, {
    required List<DateTime> dates,
    required int slotCount,
  }) {
    final gridHeight = slotCount * _cellHeight + _gapHeight;
    final gridWidth = dates.length * _cellWidth;

    final grid = SizedBox(
      width: gridWidth,
      height: gridHeight,
      child: Stack(
        children: [
          for (var row = 0; row < slotCount; row++)
            for (var column = 0; column < dates.length; column++)
              Positioned(
                left: column * _cellWidth,
                top: _rowTop(row),
                width: _cellWidth,
                height: _cellHeight,
                child: ColoredBox(
                  color:
                      _isActiveSlot(
                        _slotForPosition(
                          dates,
                          _GridPosition(row: row, column: column),
                        ),
                      )
                      ? _cellColor(
                          context,
                          slotStart: _slotForPosition(
                            dates,
                            _GridPosition(row: row, column: column),
                          ),
                        )
                      // 후보 시간대가 아닌 칸은 선택할 수 없는 회색으로 표시합니다.
                      : context.grays.gray7,
                ),
              ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _MeetitGridLinePainter(
                  lineColor: context.grays.gray1,
                  columnCount: dates.length,
                  slotCount: slotCount,
                  cellWidth: _cellWidth,
                  cellHeight: _cellHeight,
                  startMinutes: _startMinutes,
                  tailRows: _tailRows,
                  gapHeight: _gapHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!_canEdit) return grid;

    // Listener는 Gesture Arena가 승자를 정하기 전에 pointerDown을 바로 받습니다.
    // 그래서 그리드에서 드래그를 시작하는 순간 부모의 세로 ScrollView를 잠글 수 있습니다.
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => widget.onEditGestureStateChanged?.call(true),
      onPointerUp: (_) => widget.onEditGestureStateChanged?.call(false),
      onPointerCancel: (_) => widget.onEditGestureStateChanged?.call(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          final position = _positionFromOffset(
            details.localPosition,
            dates.length,
            slotCount,
          );
          if (position == null) return;

          final slot = _slotForPosition(dates, position);
          if (!_isActiveSlot(slot)) return;
          final next = Set<DateTime>.of(_editableSlots);
          if (next.contains(slot)) {
            next.remove(slot);
          } else {
            next.add(slot);
          }
          _commitEditableSelection(next);
        },
        onPanStart: (details) {
          final position = _positionFromOffset(
            details.localPosition,
            dates.length,
            slotCount,
          );
          if (position == null) return;

          _dragStart = position;
          _dragBaseSelection = Set<DateTime>.of(_editableSlots);
          final startSlot = _slotForPosition(dates, position);
          if (!_isActiveSlot(startSlot)) {
            _dragStart = null;
            return;
          }
          _dragAddsSelection = !_editableSlots.contains(startSlot);
          _applyDragSelection(dates, position);
        },
        onPanUpdate: (details) {
          final current = _positionFromOffset(
            details.localPosition,
            dates.length,
            slotCount,
            clampToGrid: true,
          );
          if (current == null || _dragStart == null) return;
          _applyDragSelection(dates, current);
        },
        onPanEnd: (_) {
          _dragStart = null;
          _dragBaseSelection = <DateTime>{};
        },
        onPanCancel: () {
          _dragStart = null;
          _dragBaseSelection = <DateTime>{};
        },
        child: grid,
      ),
    );
  }

  Color _cellColor(BuildContext context, {required DateTime slotStart}) {
    if (widget.mode == MeetitTimeGridMode.edit) {
      if (!widget.showAllSchedule) {
        return _editableSlots.contains(slotStart)
            ? context.brands.beatOrange1
            : context.brands.beatYellowContainer;
      }

      // 전체 시간표 ON: 서버에 저장된 다른 사람들의 선택 + 지금 수정 중인 내 선택을 합쳐서 표시합니다.
      // 서버의 '내 기존 선택'은 먼저 제외한 뒤 _editableSlots로 대체하기 때문에,
      // 방금 추가/삭제한 내용까지 그대로 반영된 상태로 전체 heatmap을 볼 수 있습니다.
      return _editOverlayCellColor(context, slotStart);
    }

    if (widget.summaryFilter == MeetitTimeGridSummaryFilter.everyone) {
      return _isInOptimalSlots(slotStart, widget.entireMemberOptimalSlots)
          ? context.brands.beatOrange1
          : context.grays.white;
    }

    if (widget.summaryFilter == MeetitTimeGridSummaryFilter.mostAvailable) {
      return _isInOptimalSlots(slotStart, widget.maxMemberOptimalSlots)
          ? context.brands.beatOrange1
          : context.grays.white;
    }

    final timetableSlot = _findTimetableSlot(slotStart);
    if (timetableSlot == null || timetableSlot.availableUserIds.isEmpty) {
      return context.grays.white;
    }

    final denominator = widget.selectedParticipantIds.isEmpty
        ? widget.totalInvitedCount
        : widget.selectedParticipantIds.length;

    if (denominator <= 0) return context.grays.white;

    final availableCount = widget.selectedParticipantIds.isEmpty
        ? timetableSlot.availableUserIds.length
        : widget.selectedParticipantIds
              .where(timetableSlot.availableUserIds.contains)
              .length;

    if (availableCount == 0) return context.grays.white;

    final ratio = (availableCount / denominator).clamp(0.0, 1.0).toDouble();
    return Color.lerp(context.grays.white, context.brands.beatOrange1, ratio) ??
        context.brands.beatOrange1;
  }

  Color _editOverlayCellColor(BuildContext context, DateTime slotStart) {
    final timetableSlot = _findTimetableSlot(slotStart);
    final availableUserIds = <int>{...?timetableSlot?.availableUserIds};

    final editableUserId = widget.editableUserId;
    if (editableUserId != null) {
      // 서버 응답의 기존 내 선택은 제거하고, 현재 편집 상태로 교체합니다.
      availableUserIds.remove(editableUserId);
      if (_editableSlots.contains(slotStart)) {
        availableUserIds.add(editableUserId);
      }
    }

    if (availableUserIds.isEmpty || widget.totalInvitedCount <= 0) {
      return context.grays.white;
    }

    final ratio = (availableUserIds.length / widget.totalInvitedCount)
        .clamp(0.0, 1.0)
        .toDouble();

    return Color.lerp(context.grays.white, context.brands.beatOrange1, ratio) ??
        context.brands.beatOrange1;
  }

  MeetitTimetableSlot? _findTimetableSlot(DateTime target) {
    for (final slot in widget.timetableGrid) {
      final parsed = _parseSlotStartTime(slot.slotStartTime);
      if (parsed != null && _sameMinute(parsed, target)) {
        return slot;
      }
    }
    return null;
  }

  bool _isInOptimalSlots(
    DateTime target,
    List<MeetitOptimalSlot> optimalSlots,
  ) {
    for (final range in optimalSlots) {
      final start = range.wallClockStart;
      final end = range.wallClockEnd;
      if (start == null || end == null) continue;

      if (!target.isBefore(start) && target.isBefore(end)) {
        return true;
      }
    }
    return false;
  }

  /// `+09:00` 또는 `Z`를 기기 timezone으로 변환하지 않고, 서버가 표현한
  /// 달력상의 날짜/시각 자체를 그대로 사용하기 위한 파싱입니다.
  DateTime? _parseSlotStartTime(String value) {
    if (value.length < 16) return null;
    return DateTime.tryParse(value.substring(0, 16));
  }

  bool _sameMinute(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day &&
        left.hour == right.hour &&
        left.minute == right.minute;
  }

  void _applyDragSelection(List<DateTime> dates, _GridPosition current) {
    final start = _dragStart;
    if (start == null) return;

    final minRow = math.min(start.row, current.row);
    final maxRow = math.max(start.row, current.row);
    final minColumn = math.min(start.column, current.column);
    final maxColumn = math.max(start.column, current.column);

    final next = Set<DateTime>.of(_dragBaseSelection);

    for (var row = minRow; row <= maxRow; row++) {
      for (var column = minColumn; column <= maxColumn; column++) {
        final slot = _slotForPosition(
          dates,
          _GridPosition(row: row, column: column),
        );
        if (!_isActiveSlot(slot)) continue;
        if (_dragAddsSelection) {
          next.add(slot);
        } else {
          next.remove(slot);
        }
      }
    }

    _commitEditableSelection(next);
  }

  void _commitEditableSelection(Set<DateTime> next) {
    final normalized = _normalizeSlots(next);
    setState(() {
      _editableSlots = normalized;
    });
    widget.onEditableSelectionChanged?.call(
      Set<DateTime>.unmodifiable(normalized),
    );
  }

  _GridPosition? _positionFromOffset(
    Offset offset,
    int columnCount,
    int rowCount, {
    bool clampToGrid = false,
  }) {
    var dx = offset.dx;
    var dy = offset.dy;

    if (clampToGrid) {
      dx = dx.clamp(0.0, columnCount * _cellWidth - 0.001).toDouble();
      dy = dy.clamp(0.0, rowCount * _cellHeight + _gapHeight - 0.001)
          .toDouble();
    }

    if (dx < 0 || dy < 0) return null;
    if (dx >= columnCount * _cellWidth ||
        dy >= rowCount * _cellHeight + _gapHeight) {
      return null;
    }

    // 1시간 높이의 공백에는 셀이 없으므로 탭/드래그로 선택할 수 없습니다.
    if (_gapHeight > 0) {
      final gapTop = _tailRows * _cellHeight;
      if (dy >= gapTop && dy < gapTop + _gapHeight) return null;
      if (dy >= gapTop + _gapHeight) dy -= _gapHeight;
    }

    return _GridPosition(
      row: (dy / _cellHeight).floor(),
      column: (dx / _cellWidth).floor(),
    );
  }

  DateTime _slotForPosition(List<DateTime> dates, _GridPosition position) {
    final date = dates[position.column];
    final minutes = _minutesForRow(position.row);
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  int get _startMinutes => widget.startTime.hour * 60 + widget.startTime.minute;
  int get _endMinutes => widget.endTime.hour * 60 + widget.endTime.minute;

  /// 백엔드는 종료 시간이 시작 시간과 같아도 다음 날까지 24시간을 생성합니다.
  bool get _isOvernight => _endMinutes <= _startMinutes;

  /// 새벽 구간이 있을 때만 두 시간대 사이에 공백을 둡니다.
  double get _gapHeight => _tailRows > 0 ? _overnightGapHeight : 0.0;

  double _rowTop(int row) => row * _cellHeight +
      (row >= _tailRows ? _gapHeight : 0.0);

  /// 밤을 넘기는 경우 시간표 위쪽에 먼저 놓이는 새벽 칸(0시~종료 시간) 수입니다.
  int get _tailRows => _isOvernight ? (_endMinutes / _slotMinutes).ceil() : 0;

  int get _slotCount {
    final start = _startMinutes;
    final end = _endMinutes;
    if (end <= start) {
      return _tailRows + ((24 * 60 - start) / _slotMinutes).ceil();
    }
    return ((end - start) / _slotMinutes).ceil();
  }

  int _minutesForRow(int row) {
    if (row < _tailRows) return row * _slotMinutes;
    return _startMinutes + (row - _tailRows) * _slotMinutes;
  }

  int _minutesForBoundary(int boundary) {
    if (boundary > 0 && boundary >= _slotCount) {
      return _minutesForRow(boundary - 1) + _slotMinutes;
    }
    return _minutesForRow(boundary);
  }

  /// 서버가 실제로 생성한 슬롯만 활성화합니다.
  /// candidateDates에는 새벽이 포함된 다음 날도 있으므로 날짜만으로 판단하면
  /// 마지막 날 저녁처럼 존재하지 않는 슬롯이 선택되는 오류가 생깁니다.
  bool _isActiveSlot(DateTime slot) => _validSlotStarts.contains(slot);

  bool get _canEdit {
    return widget.mode == MeetitTimeGridMode.edit && !widget.showAllSchedule;
  }

  Set<DateTime> _normalizeSlots(Iterable<DateTime> source) {
    return source
        .map(
          (value) => DateTime(
            value.year,
            value.month,
            value.day,
            value.hour,
            value.minute,
          ),
        )
        .toSet();
  }

  String _formatTime(int totalMinutes) {
    final normalized = totalMinutes % (24 * 60);
    final hour24 = normalized ~/ 60;
    final minute = normalized % 60;
    final isAm = hour24 < 12;
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

    if (minute == 0) {
      return '${isAm ? '오전' : '오후'} ${hour12}시';
    }
    return '${isAm ? '오전' : '오후'} ${hour12}시 ${minute}분';
  }

  String _weekdayLabel(int weekday) {
    const labels = <String>['월', '화', '수', '목', '금', '토', '일'];
    return labels[weekday - 1];
  }
}

class _MeetitGridLinePainter extends CustomPainter {
  const _MeetitGridLinePainter({
    required this.lineColor,
    required this.columnCount,
    required this.slotCount,
    required this.cellWidth,
    required this.cellHeight,
    required this.startMinutes,
    required this.tailRows,
    required this.gapHeight,
  });

  final Color lineColor;
  final int columnCount;
  final int slotCount;
  final double cellWidth;
  final double cellHeight;
  final int startMinutes;
  final int tailRows;
  final double gapHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = false;

    // 공백을 가로지르는 테두리/구분선을 그리지 않고 각 시간대를 분리합니다.
    void drawSection(int firstRow, int rowCount, double top) {
      if (rowCount <= 0) return;
      final width = columnCount * cellWidth;
      final height = rowCount * cellHeight;

      paint.strokeWidth = 0.5;
      canvas.drawRect(
        Rect.fromLTWH(0.25, top + 0.25, width - 0.5, height - 0.5),
        paint,
      );

      paint.strokeWidth = 1.0;
      for (var column = 1; column < columnCount; column++) {
        final x = column * cellWidth;
        canvas.drawLine(Offset(x, top), Offset(x, top + height), paint);
      }

      for (var row = 1; row < rowCount; row++) {
        final minutes = firstRow < tailRows
            ? (firstRow + row) * 30
            : startMinutes + (firstRow + row - tailRows) * 30;
        paint.strokeWidth = minutes % 60 == 0 ? 1.0 : 0.5;
        final y = top + row * cellHeight;
        canvas.drawLine(Offset(0, y), Offset(width, y), paint);
      }
    }

    if (gapHeight > 0) {
      drawSection(0, tailRows, 0);
      drawSection(tailRows, slotCount - tailRows,
          tailRows * cellHeight + gapHeight);
    } else {
      drawSection(0, slotCount, 0);
    }
  }

  @override
  bool shouldRepaint(covariant _MeetitGridLinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.columnCount != columnCount ||
        oldDelegate.slotCount != slotCount ||
        oldDelegate.cellWidth != cellWidth ||
        oldDelegate.cellHeight != cellHeight ||
        oldDelegate.startMinutes != startMinutes ||
        oldDelegate.tailRows != tailRows ||
        oldDelegate.gapHeight != gapHeight;
  }
}

@immutable
class _GridPosition {
  const _GridPosition({required this.row, required this.column});

  final int row;
  final int column;
}
