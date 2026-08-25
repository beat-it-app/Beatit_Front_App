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

  final ScrollController _horizontalScrollController = ScrollController();

  Set<DateTime> _editableSlots = <DateTime>{};
  Set<DateTime> _dragBaseSelection = <DateTime>{};
  _GridPosition? _dragStart;
  bool _dragAddsSelection = true;

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

    if (slotCount <= 0) {
      return _buildEmptyMessage(context, '시작 시간과 종료 시간을 확인해주세요.');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableGridWidth = math.max(
          0.0,
          constraints.maxWidth - _timeLabelWidth,
        );
        final gridWidth = dates.length * _cellWidth;
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
                  // edit 중에는 그리드 내부의 좌우 drag도 셀 선택에만 사용합니다.
                  // 날짜 이동은 그리드 아래 전용 drag 영역에서만 처리합니다.
                  physics: _canEdit
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: gridWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDateHeader(context, dates),
                        _buildDataGrid(
                          context,
                          dates: dates,
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

  Widget _buildHorizontalDragArea(bool canScrollHorizontally) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: !canScrollHorizontally
          ? null
          : (details) {
              if (!_horizontalScrollController.hasClients) return;

              final position = (
                _horizontalScrollController.offset - details.delta.dx
              ).clamp(
                0.0,
                _horizontalScrollController.position.maxScrollExtent,
              ).toDouble();

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
    final gridHeight = slotCount * _cellHeight;

    return SizedBox(
      width: _timeLabelWidth,
      height: _headerHeight + gridHeight + _horizontalDragAreaHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var boundary = 0; boundary <= slotCount; boundary++)
            if (_shouldShowTimeLabel(boundary, slotCount))
              Positioned(
                left: 0,
                top: _headerHeight + boundary * _cellHeight - 8.0,
                child: Text(
                  _formatTime(_minutesForBoundary(boundary)),
                  style: FontStyles.reg14.copyWith(color: context.grays.gray2),
                ),
              ),
        ],
      ),
    );
  }

  bool _shouldShowTimeLabel(int boundary, int slotCount) {
    if (boundary == 0 || boundary == slotCount) return true;
    return _minutesForBoundary(boundary) % 60 == 0;
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
    final gridHeight = slotCount * _cellHeight;
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
                top: row * _cellHeight,
                width: _cellWidth,
                height: _cellHeight,
                child: ColoredBox(
                  color: _cellColor(
                    context,
                    slotStart: _slotForPosition(
                      dates,
                      _GridPosition(row: row, column: column),
                    ),
                  ),
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
                  startMinutes:
                      widget.startTime.hour * 60 + widget.startTime.minute,
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
    final availableUserIds = <int>{
      ...?timetableSlot?.availableUserIds,
    };

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
      final date = DateTime.tryParse(range.date);
      final start = _parseDateAndTime(range.date, range.startTime);
      final end = _parseDateAndTime(range.date, range.endTime);
      if (date == null || start == null || end == null) continue;

      if (DateUtils.isSameDay(target, date) &&
          !target.isBefore(start) &&
          target.isBefore(end)) {
        return true;
      }
    }
    return false;
  }

  /// `+09:00` offset을 UTC로 변환하지 않고, 서버가 표현한 달력상의
  /// 날짜/시각 자체를 그대로 사용하기 위한 파싱입니다.
  DateTime? _parseSlotStartTime(String value) {
    if (value.length < 16) return null;
    return DateTime.tryParse(value.substring(0, 16));
  }

  DateTime? _parseDateAndTime(String date, String time) {
    return DateTime.tryParse('${date}T$time');
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
      dy = dy.clamp(0.0, rowCount * _cellHeight - 0.001).toDouble();
    }

    if (dx < 0 || dy < 0) return null;
    if (dx >= columnCount * _cellWidth || dy >= rowCount * _cellHeight) {
      return null;
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

  int get _slotCount {
    final start = widget.startTime.hour * 60 + widget.startTime.minute;
    final end = widget.endTime.hour * 60 + widget.endTime.minute;
    if (end <= start) return 0;
    return ((end - start) / _slotMinutes).ceil();
  }

  int _minutesForRow(int row) {
    final start = widget.startTime.hour * 60 + widget.startTime.minute;
    return start + row * _slotMinutes;
  }

  int _minutesForBoundary(int boundary) {
    final start = widget.startTime.hour * 60 + widget.startTime.minute;
    return start + boundary * _slotMinutes;
  }

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
  });

  final Color lineColor;
  final int columnCount;
  final int slotCount;
  final double cellWidth;
  final double cellHeight;
  final int startMinutes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = false;

    // 가장 바깥 border: 0.5
    paint.strokeWidth = 0.5;
    canvas.drawRect(
      Rect.fromLTWH(0.25, 0.25, size.width - 0.5, size.height - 0.5),
      paint,
    );

    // 날짜 구분선: 1.0
    paint.strokeWidth = 1.0;
    for (var column = 1; column < columnCount; column++) {
      final x = column * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // 정각: 1.0 / 30분: 0.5
    for (var row = 1; row < slotCount; row++) {
      final boundaryMinutes = startMinutes + row * 30;
      paint.strokeWidth = boundaryMinutes % 60 == 0 ? 1.0 : 0.5;
      final y = row * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeetitGridLinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.columnCount != columnCount ||
        oldDelegate.slotCount != slotCount ||
        oldDelegate.cellWidth != cellWidth ||
        oldDelegate.cellHeight != cellHeight ||
        oldDelegate.startMinutes != startMinutes;
  }
}

@immutable
class _GridPosition {
  const _GridPosition({required this.row, required this.column});

  final int row;
  final int column;
}
