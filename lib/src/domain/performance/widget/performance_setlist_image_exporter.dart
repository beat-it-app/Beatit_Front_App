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
          showFooter: part == partCount - 1,
        ),
      );
      parts.add(bytes);
    }

    if (parts.length == 1) return parts.single;
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
