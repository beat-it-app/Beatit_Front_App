import 'dart:typed_data';

import 'package:beatit_front_app/src/domain/performance/widget/performance_setlist_image_exporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('팀의 여러 PNG 조각을 누락 없이 한 장으로 세로 결합한다', () {
    final first = img.Image(width: 4, height: 3, numChannels: 4);
    final second = img.Image(width: 4, height: 5, numChannels: 4);
    img.fill(first, color: img.ColorRgb8(255, 0, 0));
    img.fill(second, color: img.ColorRgb8(0, 0, 255));

    final result = stitchSetlistPngParts(<Uint8List>[
      Uint8List.fromList(img.encodePng(first)),
      Uint8List.fromList(img.encodePng(second)),
    ]);
    final decoded = img.decodePng(result)!;

    expect(decoded.width, 4);
    expect(decoded.height, 8);
    expect(decoded.getPixel(0, 0).r, 255);
    expect(decoded.getPixel(0, 2).r, 255);
    expect(decoded.getPixel(0, 3).b, 255);
    expect(decoded.getPixel(0, 7).b, 255);
  });
}
