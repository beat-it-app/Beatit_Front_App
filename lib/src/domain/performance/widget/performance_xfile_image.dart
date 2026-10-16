import 'dart:typed_data';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 갤러리에서 선택한 파일과 메모리 기반 더미 XFile을 동일하게 표시한다.
/// 기존 UI 레이아웃은 부모 위젯에서 결정하고 이미지 디코딩만 담당한다.
class PerformanceXFileImage extends StatefulWidget {
  const PerformanceXFileImage({
    super.key,
    required this.file,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final XFile file;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<PerformanceXFileImage> createState() => _PerformanceXFileImageState();
}

class _PerformanceXFileImageState extends State<PerformanceXFileImage> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = widget.file.readAsBytes();
  }

  @override
  void didUpdateWidget(covariant PerformanceXFileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file) _bytes = widget.file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
    future: _bytes,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Image.memory(
          snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          gaplessPlayback: true,
        );
      }
      return Container(
        width: widget.width,
        height: widget.height,
        color: context.grays.gray8,
        alignment: Alignment.center,
        child: snapshot.hasError
            ? Icon(Icons.broken_image_outlined, color: context.grays.gray5)
            : null,
      );
    },
  );
}
