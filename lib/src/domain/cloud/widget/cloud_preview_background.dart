import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Cloud의 모든 Preview 화면에서 공통으로 사용하는 배경이다.
///
/// PDF / Audio / Video / Link Preview가 동일한 배경을 사용하도록
/// 각 Preview 내부에서 직접 Gradient를 정의하지 않는다.
class CloudPreviewBackground extends StatelessWidget {
  const CloudPreviewBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [
            context.grays.white,
            context.grays.white,
            context.grays.gray7,
          ],
        ),
      ),
      child: child,
    );
  }
}
