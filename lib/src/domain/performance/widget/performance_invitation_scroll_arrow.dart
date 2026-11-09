import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 첫 화면에서는 맨 아래에 보이고, 스크롤하면 앱바 바로 밑에 붙는 화살표.
/// SVG의 기본 방향은 아래쪽이라고 가정한다. 위로 돌아갈 때 180° 회전한다.
class PerformanceInvitationScrollArrow extends StatelessWidget {
  const PerformanceInvitationScrollArrow({
    super.key,
    required this.entrance,
    required this.isExpanded,
    required this.onPressed,
  });

  final Animation<double> entrance;
  final bool isExpanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.surface,
      child: Center(
        child: AnimatedBuilder(
          animation: entrance,
          builder: (context, child) {
            final progress = entrance.value;
            return Opacity(
              opacity: progress,
              child: Transform.translate(
                offset: Offset(0, (1 - progress) * 56),
                child: child,
              ),
            );
          },
          child: Semantics(
            button: true,
            label: isExpanded ? '초대장 맨 위로 이동' : '셋리스트로 내려가기',
            child: IconButton(
              tooltip: isExpanded ? '초대장 맨 위로' : '공연 셋리스트 보기',
              onPressed: onPressed,
              icon: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOutCubic,
                child: SvgPicture.asset(
                  'assets/icons/performance/arrows.svg',
                  width: 36,
                  height: 36,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PerformanceInvitationArrowDelegate
    extends SliverPersistentHeaderDelegate {
  const PerformanceInvitationArrowDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(
    covariant PerformanceInvitationArrowDelegate oldDelegate,
  ) => oldDelegate.child != child;
}
