import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 이미지로 저장할 위젯을 잠시 Overlay에 그린 다음 그 위젯만 PNG로 캡처한다.
/// Overlay에는 로딩 화면을 위에 덮어 사용 중인 카드/곡 목록이 깜빡이지 않게 한다.
/// 일반 화면 스크롤의 RepaintBoundary를 쓰지 않으므로 현재 선택한 카드나
/// 스크롤 위치에 영향을 받지 않는다.
abstract final class PerformanceImageCapture {
  static Future<Uint8List> capture({
    required BuildContext context,
    required Widget child,
    required double width,
  }) async {
    final key = GlobalKey();
    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(
      builder: (overlayContext) => Positioned.fill(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: RepaintBoundary(
                key: key,
                child: Theme(
                  data: AppTheme.dark,
                  child: MediaQuery(
                    data: MediaQuery.of(overlayContext).copyWith(
                      textScaler: TextScaler.noScaling,
                    ),
                    child: SizedBox(width: width, child: child),
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: ColoredBox(
                color: AppColor.black,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(entry);
    try {
      // 첫 프레임에서 레이아웃/페인트가 끝나야 캡처 가능하다.
      await WidgetsBinding.instance.endOfFrame;
      // SVG 등의 에셋 로더도 그려질 기회를 한 프레임 더 준다.
      await WidgetsBinding.instance.endOfFrame;
      final boundary = key.currentContext?.findRenderObject();
      if (boundary is! RenderRepaintBoundary) {
        throw StateError('이미지 렌더 영역을 찾을 수 없습니다.');
      }
      final height = boundary.size.height;
      // GPU 최대 텍스처 크기를 고려하면서 긴 셋리스트도 한 장으로 생성.
      final scale = math.min(
        3.0,
        math.min(9000 / math.max(1, height), 4096 / width),
      );
      final image = await boundary.toImage(pixelRatio: scale);
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) throw StateError('PNG 이미지 생성에 실패했습니다.');
        return Uint8List.fromList(data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        ));
      } finally {
        image.dispose();
      }
    } finally {
      entry.remove();
      entry.dispose();
    }
  }
}
