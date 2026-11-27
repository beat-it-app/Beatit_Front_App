import 'package:flutter/material.dart';

/// 화면 전체를 덮고 터치와 뒤로가기를 막는 로딩 오버레이.
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key});

  /// [task]가 끝날 때까지 오버레이를 띄운다.
  ///
  /// [task] 안에서 화면 스택을 교체해 오버레이가 이미 사라졌어도 안전하다.
  static Future<T> during<T>(
    BuildContext context,
    Future<T> Function() task,
  ) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final route = DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AppLoadingOverlay(),
    );
    navigator.push(route);

    try {
      return await task();
    } finally {
      // 맨 위 화면이 아니라 이 오버레이만 골라서 닫는다.
      if (route.isActive) navigator.removeRoute(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
