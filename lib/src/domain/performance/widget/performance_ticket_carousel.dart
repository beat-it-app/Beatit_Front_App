import 'dart:math' as math;

import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_ticket.dart';
import 'package:flutter/material.dart';

/// 세 장의 티켓이 정면으로 겹쳐서 시작한 뒤, 아래쪽을 축으로 부채처럼 펼쳐진다.
/// 펼쳐진 뒤에는 좌/우 드래그 진행량을 따라 움직이고, 놓으면 중심 티켓을 교체한다.
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
  static const double _fanAngle = 0.27;

  int _selectedIndex = 0;
  bool _isFanned = false;
  bool _isDragging = false;
  double _dragDistance = 0;
  double _dragExtent = 1;

  int _sideFor(int index, int center) {
    if (index == center) return 0;
    return (index - center + _faces.length) % _faces.length == 1 ? 1 : -1;
  }

  void _select(int index) {
    setState(() {
      if (!_isFanned) {
        _isFanned = true;
        _selectedIndex = 1; // 펼칠 때 행사 정보 티켓을 중앙에 놓는다.
      } else {
        _selectedIndex = index;
      }
      _dragDistance = 0;
      _isDragging = false;
    });
    widget.onPageChanged?.call(_selectedIndex);
  }

  void _tapTicket(int index) {
    if (!_isFanned || index != _selectedIndex) {
      _select(index);
    } else {
      _select((_selectedIndex + 1) % _faces.length);
    }
  }

  void _finishDrag(double velocity) {
    if (!_isDragging) return;
    final distance = _dragDistance;
    final shouldTurn = distance.abs() > _dragExtent * 0.23 ||
        velocity.abs() > 360;
    if (shouldTurn) {
      if (!_isFanned) {
        _select(1);
      } else {
        _select((_selectedIndex + (distance < 0 ||
                    (distance == 0 && velocity < 0)
                ? 1
                : -1) +
            _faces.length) %
            _faces.length);
      }
    } else {
      setState(() {
        _dragDistance = 0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 이전의 높이*5/8 고정보다 넓게: 화면 폭의 최대 76%.
        // 작은 화면에서는 높이를 먼저 조절하고, 항상 중앙 정렬한다.
        final targetHeight = MediaQuery.sizeOf(context).height * 0.52;
        final ticketHeight = math.min(
          targetHeight,
          math.min(constraints.maxHeight * 0.91, constraints.maxWidth * 1.58),
        );
        final ticketWidth = math.min(
          constraints.maxWidth * 0.76,
          ticketHeight * 0.70,
        );
        final spread = ticketWidth * 0.55;
        _dragExtent = spread;

        final order = <int>[
          for (var i = 0; i < _faces.length; i++)
            if (i != _selectedIndex) i,
          _selectedIndex,
        ];
        final dragProgress = (_dragDistance.abs() / spread).clamp(0.0, 1.0);
        final dragDirection = _dragDistance < 0 ? 1 : -1;
        final nextIndex =
            (_selectedIndex + dragDirection + _faces.length) % _faces.length;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (_) {
            setState(() {
              _isDragging = true;
              _dragDistance = 0;
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragDistance = (_dragDistance + details.delta.dx)
                  .clamp(-spread, spread);
            });
          },
          onHorizontalDragEnd: (details) =>
              _finishDrag(details.primaryVelocity ?? 0),
          onHorizontalDragCancel: () => _finishDrag(0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              for (final index in order)
                TweenAnimationBuilder<double>(
                  key: ValueKey('ticket_$index'),
                  duration: _isDragging
                      ? Duration.zero
                      : const Duration(milliseconds: 480),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(
                    end: !_isFanned
                        ? 0
                        : _isDragging
                            ? _sideFor(index, _selectedIndex) *
                                    (1 - dragProgress) +
                                _sideFor(index, nextIndex) * dragProgress
                            : _sideFor(index, _selectedIndex).toDouble(),
                  ),
                  builder: (context, slot, child) => Transform.translate(
                    offset: Offset(
                      slot * spread,
                      slot.abs() * 8, // 양 옆 카드의 윗부분이 더 넓게 펼쳐지도록
                    ),
                    child: Transform.rotate(
                      angle: slot * _fanAngle,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    ),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _tapTicket(index),
                    child: SizedBox(
                      width: ticketWidth,
                      height: ticketHeight,
                      child: PerformanceInvitationTicket(
                        performance: widget.performance,
                        face: _faces[index],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
