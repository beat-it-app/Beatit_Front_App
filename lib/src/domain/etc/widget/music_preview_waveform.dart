import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';

class MusicPreviewWaveform extends StatefulWidget {
  const MusicPreviewWaveform({
    super.key,
    required this.waveform,
    required this.duration,
    required this.position,
    required this.onSeek,
    this.loadingProgress = 0.0,
  });

  final Waveform? waveform;
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onSeek;
  final double loadingProgress;

  @override
  State<MusicPreviewWaveform> createState() => _MusicPreviewWaveformState();
}

class _MusicPreviewWaveformState extends State<MusicPreviewWaveform> {
  static const double _minVisibleSeconds = 10.0;
  static const double _maxVisibleSeconds = 30.0;
  static const double _containerHeight = 60.0;
  static const double _playheadExtension = 4.0;

  double _visibleSeconds = _minVisibleSeconds;
  double _scaleStartVisibleSeconds = _minVisibleSeconds;
  double _dragStartX = 0.0;
  Duration _dragStartPosition = Duration.zero;
  int _lastPointerCount = 0;

  double get _effectiveMaxVisibleSeconds {
    final seconds =
        widget.duration.inMicroseconds / Duration.microsecondsPerSecond;
    if (seconds <= 0) return _maxVisibleSeconds;
    return math.min(_maxVisibleSeconds, math.max(_minVisibleSeconds, seconds));
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _scaleStartVisibleSeconds = _visibleSeconds;
    _dragStartX = details.localFocalPoint.dx;
    _dragStartPosition = widget.position;
    _lastPointerCount = details.pointerCount;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details, double width) {
    if (details.pointerCount >= 2) {
      final nextVisibleSeconds = (_scaleStartVisibleSeconds / details.scale)
          .clamp(_minVisibleSeconds, _effectiveMaxVisibleSeconds)
          .toDouble();

      if (nextVisibleSeconds != _visibleSeconds) {
        setState(() {
          _visibleSeconds = nextVisibleSeconds;
        });
      }

      _lastPointerCount = details.pointerCount;
      return;
    }

    if (details.pointerCount == 1) {
      if (_lastPointerCount != 1) {
        _dragStartX = details.localFocalPoint.dx;
        _dragStartPosition = widget.position;
      }

      final dragDistance = details.localFocalPoint.dx - _dragStartX;
      final secondsPerPixel = width == 0 ? 0.0 : _visibleSeconds / width;
      final movedSeconds = dragDistance * secondsPerPixel;
      final targetSeconds =
          _durationInSeconds(_dragStartPosition) - movedSeconds;

      widget.onSeek(_durationFromSeconds(targetSeconds));
    }

    _lastPointerCount = details.pointerCount;
  }

  Duration _durationFromSeconds(double seconds) {
    final maxSeconds = _durationInSeconds(widget.duration);
    final clamped = seconds.clamp(0.0, maxSeconds).toDouble();

    return Duration(
      microseconds: (clamped * Duration.microsecondsPerSecond).round(),
    );
  }

  double _durationInSeconds(Duration duration) {
    return duration.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _containerHeight + (_playheadExtension * 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _handleScaleStart,
            onScaleUpdate: (details) {
              _handleScaleUpdate(details, constraints.maxWidth);
            },
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _MusicPreviewWaveformPainter(
                  waveform: widget.waveform,
                  duration: widget.duration,
                  position: widget.position,
                  visibleSeconds: _visibleSeconds,
                  loadingProgress: widget.loadingProgress,
                  backgroundColor: context.grays.white,
                  borderColor: context.grays.gray7,
                  waveformColor: context.grays.gray3,
                  playheadBorderColor: context.grays.gray5,
                  playheadFillColor: context.grays.white,
                  containerHeight: _containerHeight,
                  playheadExtension: _playheadExtension,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MusicPreviewWaveformPainter extends CustomPainter {
  const _MusicPreviewWaveformPainter({
    required this.waveform,
    required this.duration,
    required this.position,
    required this.visibleSeconds,
    required this.loadingProgress,
    required this.backgroundColor,
    required this.borderColor,
    required this.waveformColor,
    required this.playheadBorderColor,
    required this.playheadFillColor,
    required this.containerHeight,
    required this.playheadExtension,
  });

  static const double _playheadWidth = 8.0;
  static const double _playheadBorderWidth = 1.0;
  static const double _waveformBarWidth = 3.0;
  static const double _waveformBarGap = 3.0;

  final Waveform? waveform;
  final Duration duration;
  final Duration position;
  final double visibleSeconds;
  final double loadingProgress;
  final Color backgroundColor;
  final Color borderColor;
  final Color waveformColor;
  final Color playheadBorderColor;
  final Color playheadFillColor;
  final double containerHeight;
  final double playheadExtension;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final top = playheadExtension;
    final bottom = top + containerHeight;
    final waveformRect = Rect.fromLTRB(0, top, size.width, bottom);
    final waveformRRect = RRect.fromRectAndRadius(
      waveformRect,
      const Radius.circular(18),
    );

    canvas.drawRRect(
      waveformRRect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = backgroundColor,
    );

    canvas.drawRRect(
      waveformRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = borderColor,
    );

    canvas.save();
    canvas.clipRRect(waveformRRect);

    if (waveform != null &&
        duration > Duration.zero &&
        waveform!.duration > Duration.zero) {
      _paintWaveform(canvas, waveformRect);
    } else if (loadingProgress > 0.0 && loadingProgress < 1.0) {
      canvas.drawRect(
        Rect.fromLTWH(
          waveformRect.left,
          waveformRect.bottom - 2.0,
          waveformRect.width * loadingProgress.clamp(0.0, 1.0),
          2.0,
        ),
        Paint()..color = waveformColor.withValues(alpha: 0.25),
      );
    }

    canvas.restore();
    _paintPlayhead(canvas, size);
  }

  void _paintPlayhead(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        centerX - (_playheadWidth / 2),
        0,
        _playheadWidth,
        size.height,
      ),
      const Radius.circular(4.0),
    );

    canvas.drawRRect(
      outerRect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = playheadBorderColor,
    );

    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        centerX - (_playheadWidth / 2) + _playheadBorderWidth,
        _playheadBorderWidth,
        _playheadWidth - (_playheadBorderWidth * 2),
        size.height - (_playheadBorderWidth * 2),
      ),
      const Radius.circular(3.0),
    );

    canvas.drawRRect(
      innerRect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = playheadFillColor,
    );
  }

  void _paintWaveform(Canvas canvas, Rect rect) {
    final source = waveform!;
    final waveformWidth = source.positionToPixel(source.duration).toInt();
    if (waveformWidth <= 0) return;

    final positionSeconds = _durationInSeconds(position);
    final durationSeconds = _durationInSeconds(duration);
    final windowStart = positionSeconds - (visibleSeconds / 2);
    final barStep = _waveformBarWidth + _waveformBarGap;

    for (
      double x = rect.left + (_waveformBarWidth / 2);
      x < rect.right - (_waveformBarWidth / 2);
      x += barStep
    ) {
      final fraction = (x - rect.left) / rect.width;
      final timeSeconds = windowStart + (visibleSeconds * fraction);

      if (timeSeconds < 0 || timeSeconds > durationSeconds) {
        continue;
      }

      final sampleDuration = Duration(
        microseconds: (timeSeconds * Duration.microsecondsPerSecond).round(),
      );
      final sampleIndex = source
          .positionToPixel(sampleDuration)
          .toInt()
          .clamp(0, waveformWidth - 1);

      final minY = _normalize(
        source.getPixelMin(sampleIndex),
        rect.height,
        source.flags,
      );
      final maxY = _normalize(
        source.getPixelMax(sampleIndex),
        rect.height,
        source.flags,
      );

      final rawTop = math.min(minY, maxY);
      final rawBottom = math.max(minY, maxY);
      final centerY = rect.center.dy;
      final amplitude = math.max(3.0, (rawBottom - rawTop) / 2);
      final barTop = (centerY - amplitude).clamp(
        rect.top + 4.0,
        rect.bottom - 4.0,
      );
      final barBottom = (centerY + amplitude).clamp(
        rect.top + 4.0,
        rect.bottom - 4.0,
      );

      canvas.drawLine(
        Offset(x, barTop.toDouble()),
        Offset(x, barBottom.toDouble()),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _waveformBarWidth
          ..strokeCap = StrokeCap.round
          ..color = waveformColor,
      );
    }
  }

  double _durationInSeconds(Duration value) {
    return value.inMicroseconds / Duration.microsecondsPerSecond;
  }

  double _normalize(int sample, double height, int flags) {
    if (flags == 0) {
      final value = 32768 + sample.clamp(-32768, 32767);
      return height - 1 - value * height / 65536;
    }

    final value = 128 + sample.clamp(-128, 127);
    return height - 1 - value * height / 256;
  }

  @override
  bool shouldRepaint(covariant _MusicPreviewWaveformPainter oldDelegate) {
    return oldDelegate.waveform != waveform ||
        oldDelegate.duration != duration ||
        oldDelegate.position != position ||
        oldDelegate.visibleSeconds != visibleSeconds ||
        oldDelegate.loadingProgress != loadingProgress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.waveformColor != waveformColor ||
        oldDelegate.playheadBorderColor != playheadBorderColor ||
        oldDelegate.playheadFillColor != playheadFillColor;
  }
}
