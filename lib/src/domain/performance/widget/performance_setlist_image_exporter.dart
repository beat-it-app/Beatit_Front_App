import 'dart:math' as math;
import 'dart:typed_data';

import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_image_capture.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_setlist_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// 팀 하나의 모든 곡을 하나의 길쭉한 PNG로 만든다.
/// 조각 단위로 캡처해 단일 초고해상도 GPU 텍스처 캡처 실패를 피한다.
abstract final class PerformanceSetlistImageExporter {
  static const int songsPerChunk = 10;

  static Future<Uint8List> export({
    required BuildContext context,
    required PerformanceSetlistTeam team,
  }) async {
    // 마지막 footer 에셋을 캡처 전에 미리 디코딩한다.
    // 로딩 중인 Image.asset이 PNG에 빈 영역으로 찍히지 않게 한다.
    await precacheImage(
      const AssetImage(PerformanceSetlistFooter.iconAssetPath),
      context,
    );

    final parts = <Uint8List>[];
    final songs = team.musics;
    final partCount = math.max(1, (songs.length / songsPerChunk).ceil());

    for (var part = 0; part < partCount; part++) {
      final start = part * songsPerChunk;
      final end = math.min(start + songsPerChunk, songs.length);
      final bytes = await PerformanceImageCapture.capture(
        context: context,
        width: PerformanceSetlistExport.imageWidth,
        pixelRatio: 2,
        child: PerformanceSetlistExport(
          team: team,
          songs: songs.sublist(start, end),
          startIndex: start,
          showHeading: part == 0,
          // footer는 별도 작은 이미지로 캡처해 반드시 최하단에 합친다.
          showFooter: false,
        ),
      );
      parts.add(bytes);
    }

    // 모든 곡의 길이와 관계없이 footer를 화면 안쪽에서 별도로 렌더링한다.
    // 마지막 곡 이미지와 연결하면 footer가 긴 캡처 영역에 잘릴 수 있다.
    final footerBytes = await PerformanceImageCapture.capture(
      context: context,
      width: PerformanceSetlistExport.imageWidth,
      pixelRatio: 2,
      child: const PerformanceSetlistFooter(),
    );
    parts.add(footerBytes);

    return compute(stitchSetlistPngParts, parts);
  }
}

/// 순수 Dart 조립. 테스트 및 isolate 실행 가능.
/// 각 조각의 아래를 다음 조각의 위와 정확히 연결한다.
Uint8List stitchSetlistPngParts(List<Uint8List> parts) {
  if (parts.isEmpty) throw ArgumentError('합칠 이미지가 없습니다.');

  final decoded = <img.Image>[];
  var totalHeight = 0;
  int? width;
  for (final part in parts) {
    final image = img.decodePng(part);
    if (image == null) throw const FormatException('셋리스트 PNG 디코딩 실패');
    if (width != null && width != image.width) {
      throw const FormatException('셋리스트 PNG 폭이 서로 다릅니다.');
    }
    width = image.width;
    decoded.add(image);
    totalHeight += image.height;
  }

  final result = img.Image(width: width!, height: totalHeight, numChannels: 4);
  var currentY = 0;
  for (final page in decoded) {
    img.compositeImage(result, page, dstY: currentY);
    currentY += page.height;
  }
  return Uint8List.fromList(img.encodePng(result));
}
