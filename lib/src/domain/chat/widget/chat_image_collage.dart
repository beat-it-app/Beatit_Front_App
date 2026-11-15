import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// 사진 개수에 따라 한 채팅 말풍선 안에서만 배치를 바꾸는 위젯입니다.
/// 전송 단위나 메시지 묶음 판단은 기존 채팅 로직에서 그대로 담당합니다.
class ChatImageCollage extends StatelessWidget {
  const ChatImageCollage({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  static const double _maxWidth = 245;
  static const double _gap = AppSpacing.x4;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final tiles = _tileRects(itemCount, width);
          final height = tiles.fold<double>(
            0,
            (current, tile) => tile.bottom > current ? tile.bottom : current,
          );
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  for (var index = 0; index < tiles.length; index++)
                    Positioned.fromRect(
                      rect: tiles[index],
                      child: itemBuilder(context, index),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static List<Rect> _tileRects(int count, double width) {
    if (count <= 0) return const [];
    final tiles = <Rect>[];
    final half = (width - _gap) / 2;
    final third = (width - _gap * 2) / 3;

    void add(double x, double y, double w, double h) {
      tiles.add(Rect.fromLTWH(x, y, w, h));
    }

    void row(int columns, int length, double y) {
      final size = (width - _gap * (columns - 1)) / columns;
      for (var i = 0; i < length; i++) {
        add(i * (size + _gap), y, size, size);
      }
    }

    void twoByTwo(double y) {
      row(2, 2, y);
      row(2, 2, y + half + _gap);
    }

    void heroThree(double y) {
      // 왼쪽 큰 사진 1장 + 오른쪽 위·아래 2장.
      add(0, y, half, width);
      add(half + _gap, y, half, half);
      add(half + _gap, y + half + _gap, half, half);
    }

    void five(double y) {
      row(2, 2, y);
      row(3, 3, y + half + _gap);
    }

    switch (count) {
      case 1:
        add(0, 0, width, width);
        break;
      case 2:
        row(2, 2, 0);
        break;
      case 3:
        heroThree(0);
        break;
      case 4:
        twoByTwo(0);
        break;
      case 5:
        five(0);
        break;
      case 6:
        row(3, 3, 0);
        row(3, 3, third + _gap);
        break;
      case 7:
        heroThree(0);
        twoByTwo(width + _gap);
        break;
      case 8:
        twoByTwo(0);
        twoByTwo(width + _gap);
        break;
      case 9:
        for (var r = 0; r < 3; r++) {
          row(3, 3, r * (third + _gap));
        }
        break;
      case 10:
        // 동일한 5장 구성을 두 번 배치합니다 (2+3 / 2+3).
        five(0);
        five(half + third + _gap * 2);
        break;
      default:
        for (var r = 0; r < (count + 2) ~/ 3; r++) {
          row(3, (count - r * 3).clamp(0, 3).toInt(), r * (third + _gap));
        }
    }
    return tiles;
  }
}
