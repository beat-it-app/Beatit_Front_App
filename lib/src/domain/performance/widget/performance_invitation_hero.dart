import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_ticket_carousel.dart';
import 'package:flutter/material.dart';

/// 최초 진입 시 안내 문구는 즉시 보이고, 1초 뒤 티켓만 아래에서 올라온다.
/// 카드의 중심은 안내 문구가 아닌 화면의 중심을 기준으로 배치한다.
class PerformanceInvitationHero extends StatefulWidget {
  const PerformanceInvitationHero({
    super.key,
    required this.performance,
    required this.entrance,
  });

  final PerformanceDetailModel performance;
  final Animation<double> entrance;

  @override
  State<PerformanceInvitationHero> createState() =>
      _PerformanceInvitationHeroState();
}

class _PerformanceInvitationHeroState extends State<PerformanceInvitationHero> {
  int _currentTicket = 0;

  // 참고 이미지에서 파란 선으로 표시한 티켓 위치.
  // 위젯 크기(화면 높이 50%, 가로:세로 5:8)는 건드리지 않고
  // 티켓만 내려서 하단 화살표와 안내 문구는 기존 위치에 유지한다.
  static const double _ticketDownOffset = 52;

  @override
  Widget build(BuildContext context) {
    final textColor = context.colors.onSurface;
    final brand = context.colors.primary;

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: constraints.maxHeight < 550 ? 14 : 38,
            left: 12,
            right: 12,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: _currentTicket == 0
                        ? '티켓을 터치해서\n'
                        : '티켓을 오른쪽으로 넘겨서\n',
                  ),
                  TextSpan(
                    text: _currentTicket == 0 ? '모바일 초대장' : '공연 소개글',
                    style: FontStyles.bold22.copyWith(color: brand),
                  ),
                  const TextSpan(text: '을 확인해보세요!'),
                ],
              ),
              textAlign: TextAlign.center,
              style: FontStyles.bold22.copyWith(color: textColor, height: 1.4),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: widget.entrance,
              builder: (context, child) {
                final progress = widget.entrance.value;
                // 작은 화면에서는 화살표 영역을 침범하지 않도록 보정량을 제한한다.
                final downOffset = math.min(
                  _ticketDownOffset,
                  constraints.maxHeight * 0.075,
                );
                return IgnorePointer(
                  ignoring: progress < 0.95,
                  child: Opacity(
                    opacity: progress,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        downOffset +
                            (1 - progress) * constraints.maxHeight * 0.52,
                      ),
                      child: child,
                    ),
                  ),
                );
              },
              child: PerformanceTicketCarousel(
                performance: widget.performance,
                onPageChanged: (index) =>
                    setState(() => _currentTicket = index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
