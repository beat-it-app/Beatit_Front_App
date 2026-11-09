import 'dart:math' as math;

import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_ticket.dart';
import 'package:flutter/material.dart';

/// 1 ↔ 2 ↔ 3으로만 이동하는 유한 캐러셀.
/// 처음에는 세 카드가 정면으로 포개지고, 첫 터치 후 2번을 중심으로 펼쳐진다.
/// 아래쪽을 회전축으로 두어 위쪽이 더 넓게 벌어지는 부채 모양을 만든다.
class PerformanceTicketCarousel extends StatefulWidget {
  const PerformanceTicketCarousel({
    super.key,
    required this.performance,
    this.onPageChanged,
  });

  final PerformanceDetailModel performance;
  final ValueChanged<int>? onPageChanged;

  @override
  State<PerformanceTicketCarousel> createState() =>
      _PerformanceTicketCarouselState();
}

class _PerformanceTicketCarouselState extends State<PerformanceTicketCarousel> {
  static const _faces = InvitationTicketFace.values;
  static const double _fanAngle = 0.25;
  static const Duration _animationDuration = Duration(milliseconds: 480);

  int _selectedIndex = 0;
  bool _isFanned = false;
  bool _isDragging = false;
  bool _openedDuringDrag = false;
  double _dragDistance = 0;
  double _dragExtent = 1;

  void _select(int index) {
    final next = index.clamp(0, _faces.length - 1).toInt();
    setState(() {
      _isFanned = true;
      _selectedIndex = next;
      _dragDistance = 0;
      _isDragging = false;
      _openedDuringDrag = false;
    });
    widget.onPageChanged?.call(next);
  }

  void _onTicketTapped(int index) {
    if (!_isFanned) {
      // 처음 펼쳐지는 순간에만 정보 티켓(2번)을 중앙에 놓는다.
      _select(1);
    } else if (index != _selectedIndex) {
      // 현재 보이는 양옆 카드만 선택 가능. 마지막/첫 카드에서 반대편으로 순환하지 않는다.
      _select(index);
    }
  }

  void _onDragStart(DragStartDetails _) {
    setState(() {
      _openedDuringDrag = !_isFanned;
      if (_openedDuringDrag) {
        _isFanned = true;
        _selectedIndex = 1;
      }
      _isDragging = true;
      _dragDistance = 0;
    });
    if (_openedDuringDrag) widget.onPageChanged?.call(1);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_openedDuringDrag) return;
    setState(() {
      _dragDistance = (_dragDistance + details.delta.dx)
          .clamp(-_dragExtent, _dragExtent)
          .toDouble();
    });
  }

  void _onDragEnd(double velocity) {
    if (!_isDragging) return;
    if (_openedDuringDrag) {
      setState(() {
        _isDragging = false;
        _openedDuringDrag = false;
        _dragDistance = 0;
      });
      return;
    }

    final turn = _dragDistance.abs() > _dragExtent * 0.23 ||
        velocity.abs() > 360;
    // 손가락을 왼쪽으로 밀면 3번 방향, 오른쪽으로 밀면 1번 방향.
    final motion = velocity.abs() > 360 ? velocity : _dragDistance;
    final direction = motion < 0 ? 1 : -1;
    final next = turn
        ? (_selectedIndex + direction).clamp(0, _faces.length - 1).toInt()
        : _selectedIndex;
    _select(next);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 디바이스 화면 높이의 50%를 목표로 하되, 작은 화면에서는
        // 상단 안내 문구와 하단 화살표 영역을 침범하지 않도록 줄인다.
        // 너비는 반드시 높이의 5/8로 계산해 원래 티켓 비율을 유지한다.
        final targetHeight = MediaQuery.sizeOf(context).height * 0.50;
        final ticketHeight = math.max(
          0.0,
          math.min(
            targetHeight,
            math.min(
              constraints.maxHeight - 156,
              constraints.maxWidth * 8 / 5,
            ),
          ),
        );
        final ticketWidth = ticketHeight * 5 / 8;
        // 0.55 → 0.82: 아래쪽은 약 18%만 겹치고, 위쪽은 더 넓게 펼쳐진다.
        final spread = ticketWidth * 0.82;
        _dragExtent = spread;

        final desiredPage = _isDragging && !_openedDuringDrag
            ? (_selectedIndex - _dragDistance / spread)
                .clamp(0.0, (_faces.length - 1).toDouble())
                .toDouble()
            : _selectedIndex.toDouble();
        final duration = _isDragging ? Duration.zero : _animationDuration;
        // 양옆 티켓이 중앙 티켓 뒤에 겹쳐 있어도 탭하기 쉽도록
        // 중앙 티켓 바깥의 실제 노출 영역에 탭 타깃을 별도로 배치한다.
        final sideTapWidth = math.max(
          0.0,
          (constraints.maxWidth - ticketWidth) / 2,
        );
        final sideTapTop = (constraints.maxHeight - ticketHeight) / 2;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: _onDragStart,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: (details) =>
              _onDragEnd(details.primaryVelocity ?? 0),
          onHorizontalDragCancel: () => _onDragEnd(0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: _isFanned ? 1 : 0),
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
            builder: (context, fanProgress, _) => TweenAnimationBuilder<double>(
              tween: Tween<double>(end: desiredPage),
              duration: duration,
              curve: Curves.easeOutCubic,
              builder: (context, page, _) {
                // 멀리 있는 카드를 먼저 그리고 현재 중앙에 가까운 카드를 위에 놓는다.
                final order = List<int>.generate(_faces.length, (i) => i)
                  ..sort((a, b) =>
                      (b - page).abs().compareTo((a - page).abs()));
                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    for (final index in order)
                      _buildTicket(
                        index: index,
                        slot: (index - page) * fanProgress,
                        spread: spread,
                        width: ticketWidth,
                        height: ticketHeight,
                      ),
                    // 첫 탭으로 부채꼴이 펼쳐진 뒤에는 카드의 보이는
                    // 바깥쪽 부분을 누르는 것만으로 이전/다음 카드가 중앙으로 온다.
                    // 첫 번째에는 오른쪽(2번), 마지막에는 왼쪽(2번)만 존재.
                    if (_isFanned && sideTapWidth > 0 && !_isDragging) ...[
                      if (_selectedIndex > 0)
                        Positioned(
                          left: 0,
                          top: sideTapTop,
                          width: sideTapWidth,
                          height: ticketHeight,
                          child: Semantics(
                            button: true,
                            label: '이전 티켓 보기',
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _select(_selectedIndex - 1),
                            ),
                          ),
                        ),
                      if (_selectedIndex < _faces.length - 1)
                        Positioned(
                          right: 0,
                          top: sideTapTop,
                          width: sideTapWidth,
                          height: ticketHeight,
                          child: Semantics(
                            button: true,
                            label: '다음 티켓 보기',
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _select(_selectedIndex + 1),
                            ),
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTicket({
    required int index,
    required double slot,
    required double spread,
    required double width,
    required double height,
  }) {
    final distance = slot.abs();
    // 선택된 1번/3번에서 반대편 끝 카드는 아예 보이거나 눌리지 않도록 한다.
    // 페이지가 전환되는 순간에는 자연스럽게 서서히 사라지게 한다.
    final opacity = distance <= 1
        ? 1.0
        : ((1.25 - distance) / 0.25).clamp(0.0, 1.0).toDouble();

    final angle = slot * _fanAngle;
    // bottomCenter 회전에서는 윗모서리 하나가 원래 카드보다 위로 솟는다.
    // 회전으로 상승하는 거리를 보정한 다음, 양옆 카드의 최상단이 중앙 카드보다
    // 약 20px 낮게 배치되도록 만든다. 드래그 중간에도 자연스럽게 보간된다.
    final topCornerRise =
        math.sin(angle.abs()) * width / 2 -
        (1 - math.cos(angle)) * height;
    final verticalOffset = distance * 20 + topCornerRise;

    return IgnorePointer(
      ignoring: opacity < 0.99 || (!_isFanned && index != 0),
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(slot * spread, verticalOffset),
          child: Transform.rotate(
            angle: angle,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onTicketTapped(index),
              child: SizedBox(
                width: width,
                height: height,
                child: PerformanceInvitationTicket(
                  performance: widget.performance,
                  face: _faces[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
