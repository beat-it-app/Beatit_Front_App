import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

/// 음성/영상 재생바에서 사용하는 현재 위치 및 반복 구간 시간 표시.
class AppPlaybackTimeLabels extends StatelessWidget {
  const AppPlaybackTimeLabels({
    super.key,
    required this.position,
    required this.duration,
    this.isSelectionMode = false,
    this.selectionStart = Duration.zero,
    this.selectionEnd = Duration.zero,
  });

  final Duration position;
  final Duration duration;
  final bool isSelectionMode;
  final Duration selectionStart;
  final Duration selectionEnd;

  String _format(Duration value) {
    final safe = value.isNegative ? Duration.zero : value;
    final hours = safe.inHours;
    final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0
        ? '$hours:$minutes:$seconds'
        : '${safe.inMinutes}:$seconds';
  }

  Widget _time(
    BuildContext context,
    String title,
    Duration value, {
    TextAlign alignment = TextAlign.start,
    bool emphasized = false,
  }) {
    return Semantics(
      label: '$title ${_format(value)}',
      child: Text(
        _format(value),
        textAlign: alignment,
        style: FontStyles.med16.copyWith(
          color: emphasized ? context.brands.beatOrange1 : context.grays.gray5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isSelectionMode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _time(context, '현재 재생 시간', position),
          _time(context, '전체 길이', duration, alignment: TextAlign.end),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _selectionLabel(context, '시작', selectionStart, TextAlign.start),
        ),
        Expanded(
          child: _selectionLabel(
            context,
            '재생 중',
            position,
            TextAlign.center,
            emphasized: true,
          ),
        ),
        Expanded(
          child: _selectionLabel(context, '끝', selectionEnd, TextAlign.end),
        ),
      ],
    );
  }

  Widget _selectionLabel(
    BuildContext context,
    String title,
    Duration value,
    TextAlign alignment, {
    bool emphasized = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: switch (alignment) {
        TextAlign.start => CrossAxisAlignment.start,
        TextAlign.end => CrossAxisAlignment.end,
        _ => CrossAxisAlignment.center,
      },
      children: [
        _time(
          context,
          title,
          value,
          alignment: alignment,
          emphasized: emphasized,
        ),
      ],
    );
  }
}
