import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// 팀 클라우드의 재생 영역과 파일 작업 영역을 분리합니다.
/// 하단 버튼의 실제 높이를 제외한 공간만 재생 화면에 전달합니다.
class CloudMediaPreviewLayout extends StatelessWidget {
  const CloudMediaPreviewLayout({super.key, required this.child, this.actions});

  final Widget child;
  final Widget? actions;

  /// 파형/타임라인 본체 높이. 조작 가능한 최소 크기와 과도한 확대를 제한합니다.
  static double timelineHeight(double width) =>
      (width * 0.16).clamp(44.0, 80.0).toDouble();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
          if (actions != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x16,
                AppSpacing.x8,
                AppSpacing.x16,
                AppSpacing.x16,
              ),
              child: Align(alignment: Alignment.centerLeft, child: actions!),
            ),
        ],
      ),
    );
  }
}
