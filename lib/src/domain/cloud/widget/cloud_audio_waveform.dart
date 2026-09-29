import 'dart:async';
import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';

typedef CloudAudioSelectionChanged =
    void Function(Duration start, Duration end);

/// `MusicPreviewWaveform`의 이동/확대·축소 방식을 Cloud 음원 미리보기에 맞게
/// 복제한 파형 위젯입니다.
///
/// 일반 모드에서는 중앙 playhead가 고정되고 파형을 좌우로 드래그해 seek합니다.
/// 구간 선택 모드에서는 중앙 playhead 대신 동일한 디자인의 시작/끝 handle 두 개를
/// 표시하며, handle을 화면 가장자리로 끌면 viewport가 자동으로 이동합니다.
class CloudAudioWaveform extends StatefulWidget {
  const CloudAudioWaveform({
    super.key,
    required this.waveform,
    required this.duration,
    required this.position,
    required this.onSeek,
    this.loadingProgress = 0.0,
    this.isSelectionMode = false,
    this.selectionStart = Duration.zero,
    this.selectionEnd = Duration.zero,
    this.onSelectionChanged,
    this.onSelectionChangeEnd,
  });

  final Waveform? waveform;
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onSeek;
  final double loadingProgress;

  final bool isSelectionMode;
  final Duration selectionStart;
  final Duration selectionEnd;
  final CloudAudioSelectionChanged? onSelectionChanged;
  final CloudAudioSelectionChanged? onSelectionChangeEnd;

  @override
  State<CloudAudioWaveform> createState() => _CloudAudioWaveformState();
}

enum _SelectionHandle { start, end }

class _CloudAudioWaveformState extends State<CloudAudioWaveform> {
  static const double _minVisibleFraction = 1 / 3;
  static const double _maxVisibleFraction = 1.0;
  static const double _containerHeight = 60.0;
  static const double _playheadExtension = 4.0;
  static const double _handleHitSlop = 22.0;
  static const double _autoScrollEdge = 34.0;
  static const Duration _minimumSelectionGap = Duration(milliseconds: 100);

  double _visibleFraction = _minVisibleFraction;
  double _scaleStartVisibleFraction = _minVisibleFraction;
  double _dragStartX = 0.0;
  Duration _dragStartPosition = Duration.zero;
  Duration? _selectionViewportCenter;
  Duration _selectionPanStartCenter = Duration.zero;
  int _lastPointerCount = 0;

  _SelectionHandle? _activeHandle;
  double? _activePointerX;
  double _lastKnownWidth = 0.0;
  Timer? _autoScrollTimer;

  double get _visibleSeconds {
    final durationSeconds = _durationInSeconds(widget.duration);
    if (durationSeconds <= 0) return 0.0;
    return durationSeconds * _visibleFraction;
  }

  Duration get _selectionCenter {
    final center = _selectionViewportCenter;
    if (center != null) {
      return _clampDuration(center, Duration.zero, widget.duration);
    }

    final startUs = widget.selectionStart.inMicroseconds;
    final endUs = widget.selectionEnd.inMicroseconds;
    if (endUs > startUs) {
      return Duration(microseconds: startUs + ((endUs - startUs) ~/ 2));
    }

    return _clampDuration(widget.position, Duration.zero, widget.duration);
  }

  Duration get _viewportCenter =>
      widget.isSelectionMode ? _selectionCenter : widget.position;

  @override
  void didUpdateWidget(covariant CloudAudioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isSelectionMode && widget.isSelectionMode) {
      final startUs = widget.selectionStart.inMicroseconds;
      final endUs = widget.selectionEnd.inMicroseconds;
      _selectionViewportCenter = endUs > startUs
          ? Duration(microseconds: startUs + ((endUs - startUs) ~/ 2))
          : widget.position;
    } else if (oldWidget.isSelectionMode && !widget.isSelectionMode) {
      _stopAutoScroll();
      _activeHandle = null;
      _activePointerX = null;
      _selectionViewportCenter = null;
    }

    if (oldWidget.duration != widget.duration) {
      _visibleFraction = _minVisibleFraction;
      if (widget.isSelectionMode) {
        _selectionViewportCenter = _selectionCenter;
      }
    }
  }

  void _handleScaleStart(ScaleStartDetails details, double width) {
    _lastKnownWidth = width;
    _scaleStartVisibleFraction = _visibleFraction;
    _dragStartX = details.localFocalPoint.dx;
    _dragStartPosition = widget.position;
    _selectionPanStartCenter = _selectionCenter;
    _lastPointerCount = details.pointerCount;

    if (!widget.isSelectionMode || details.pointerCount >= 2) {
      _activeHandle = null;
      _activePointerX = null;
      _stopAutoScroll();
      return;
    }

    _activeHandle = _hitTestSelectionHandle(details.localFocalPoint.dx, width);
    _activePointerX = details.localFocalPoint.dx;

    if (_activeHandle != null) {
      _ensureAutoScrollTimer();
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details, double width) {
    _lastKnownWidth = width;

    if (details.pointerCount >= 2) {
      _activeHandle = null;
      _activePointerX = null;
      _stopAutoScroll();

      final nextVisibleFraction = (_scaleStartVisibleFraction / details.scale)
          .clamp(_minVisibleFraction, _maxVisibleFraction)
          .toDouble();

      if (nextVisibleFraction != _visibleFraction) {
        setState(() {
          _visibleFraction = nextVisibleFraction;
        });
      }

      _lastPointerCount = details.pointerCount;
      return;
    }

    if (details.pointerCount != 1) {
      _lastPointerCount = details.pointerCount;
      return;
    }

    if (_lastPointerCount != 1) {
      _dragStartX = details.localFocalPoint.dx;
      _dragStartPosition = widget.position;
      _selectionPanStartCenter = _selectionCenter;
    }

    if (widget.isSelectionMode) {
      _activePointerX = details.localFocalPoint.dx;

      if (_activeHandle != null) {
        _updateActiveHandleFromPointer(width);
      } else {
        _panSelectionViewport(details.localFocalPoint.dx, width);
      }
    } else {
      final dragDistance = details.localFocalPoint.dx - _dragStartX;
      final secondsPerPixel = width == 0 ? 0.0 : _visibleSeconds / width;
      final movedSeconds = dragDistance * secondsPerPixel;
      final targetSeconds =
          _durationInSeconds(_dragStartPosition) - movedSeconds;

      widget.onSeek(_durationFromSeconds(targetSeconds));
    }

    _lastPointerCount = details.pointerCount;
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (widget.isSelectionMode && _activeHandle != null) {
      widget.onSelectionChangeEnd?.call(
        widget.selectionStart,
        widget.selectionEnd,
      );
    }

    _activeHandle = null;
    _activePointerX = null;
    _lastPointerCount = 0;
    _stopAutoScroll();
  }

  _SelectionHandle? _hitTestSelectionHandle(double x, double width) {
    final startX = _timeToX(widget.selectionStart, width);
    final endX = _timeToX(widget.selectionEnd, width);

    final startDistance = (x - startX).abs();
    final endDistance = (x - endX).abs();

    if (startDistance > _handleHitSlop && endDistance > _handleHitSlop) {
      return null;
    }

    return startDistance <= endDistance
        ? _SelectionHandle.start
        : _SelectionHandle.end;
  }

  void _panSelectionViewport(double currentX, double width) {
    if (width <= 0 || _visibleSeconds <= 0) return;

    final dragDistance = currentX - _dragStartX;
    final secondsPerPixel = _visibleSeconds / width;
    final movedSeconds = dragDistance * secondsPerPixel;
    final centerSeconds =
        _durationInSeconds(_selectionPanStartCenter) - movedSeconds;

    setState(() {
      _selectionViewportCenter = _durationFromSeconds(centerSeconds);
    });
  }

  void _updateActiveHandleFromPointer(double width) {
    final handle = _activeHandle;
    final pointerX = _activePointerX;
    if (handle == null || pointerX == null || width <= 0) return;

    final target = _xToTime(pointerX.clamp(0.0, width).toDouble(), width);
    _emitSelectionForHandle(handle, target);
  }

  void _emitSelectionForHandle(_SelectionHandle handle, Duration target) {
    final callback = widget.onSelectionChanged;
    if (callback == null || widget.duration <= Duration.zero) return;

    final gapUs = math
        .min(
          _minimumSelectionGap.inMicroseconds,
          widget.duration.inMicroseconds,
        )
        .toInt();

    if (handle == _SelectionHandle.start) {
      final maxStartUs = math
          .max(0, widget.selectionEnd.inMicroseconds - gapUs)
          .toInt();
      final nextStart = Duration(
        microseconds: target.inMicroseconds.clamp(0, maxStartUs).toInt(),
      );
      callback(nextStart, widget.selectionEnd);
      return;
    }

    final minEndUs = math
        .min(
          widget.duration.inMicroseconds,
          widget.selectionStart.inMicroseconds + gapUs,
        )
        .toInt();
    final nextEnd = Duration(
      microseconds: target.inMicroseconds
          .clamp(minEndUs, widget.duration.inMicroseconds)
          .toInt(),
    );
    callback(widget.selectionStart, nextEnd);
  }

  void _ensureAutoScrollTimer() {
    _autoScrollTimer ??= Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _tickAutoScroll(),
    );
  }

  void _tickAutoScroll() {
    if (!mounted ||
        !widget.isSelectionMode ||
        _activeHandle == null ||
        _activePointerX == null ||
        _lastKnownWidth <= 0 ||
        _visibleSeconds <= 0) {
      return;
    }

    final width = _lastKnownWidth;
    final x = _activePointerX!;
    double direction = 0.0;
    double intensity = 0.0;

    if (x < _autoScrollEdge) {
      direction = -1.0;
      intensity = ((_autoScrollEdge - x) / _autoScrollEdge)
          .clamp(0.0, 1.0)
          .toDouble();
    } else if (x > width - _autoScrollEdge) {
      direction = 1.0;
      intensity = ((x - (width - _autoScrollEdge)) / _autoScrollEdge)
          .clamp(0.0, 1.0)
          .toDouble();
    }

    if (direction == 0.0 || intensity == 0.0) return;

    final currentCenter = _durationInSeconds(_selectionCenter);
    final deltaSeconds = _visibleSeconds * 0.008 * intensity * direction;
    final nextCenter = _clampViewportCenterSeconds(
      currentCenter + deltaSeconds,
    );

    if ((nextCenter - currentCenter).abs() < 0.000001) return;

    setState(() {
      _selectionViewportCenter = _durationFromSeconds(nextCenter);
    });

    _updateActiveHandleFromPointer(width);
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  double _clampViewportCenterSeconds(double seconds) {
    final durationSeconds = _durationInSeconds(widget.duration);
    if (durationSeconds <= 0) return 0.0;

    final halfVisible = _visibleSeconds / 2;
    if (_visibleSeconds >= durationSeconds) {
      return durationSeconds / 2;
    }

    return seconds.clamp(halfVisible, durationSeconds - halfVisible).toDouble();
  }

  double _timeToX(Duration time, double width) {
    if (width <= 0 || _visibleSeconds <= 0) return width / 2;

    final centerSeconds = _durationInSeconds(_viewportCenter);
    final windowStart = centerSeconds - (_visibleSeconds / 2);
    final timeSeconds = _durationInSeconds(time);
    return ((timeSeconds - windowStart) / _visibleSeconds) * width;
  }

  Duration _xToTime(double x, double width) {
    if (width <= 0 || _visibleSeconds <= 0) return Duration.zero;

    final centerSeconds = _durationInSeconds(_viewportCenter);
    final windowStart = centerSeconds - (_visibleSeconds / 2);
    final fraction = (x / width).clamp(0.0, 1.0);
    return _durationFromSeconds(windowStart + (_visibleSeconds * fraction));
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

  Duration _clampDuration(Duration value, Duration minimum, Duration maximum) {
    if (value < minimum) return minimum;
    if (value > maximum) return maximum;
    return value;
  }

  @override
  void dispose() {
    _stopAutoScroll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _containerHeight + (_playheadExtension * 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _lastKnownWidth = constraints.maxWidth;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: (details) {
              _handleScaleStart(details, constraints.maxWidth);
            },
            onScaleUpdate: (details) {
              _handleScaleUpdate(details, constraints.maxWidth);
            },
            onScaleEnd: _handleScaleEnd,
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _CloudAudioWaveformPainter(
                  waveform: widget.waveform,
                  duration: widget.duration,
                  viewportPosition: _viewportCenter,
                  visibleSeconds: _visibleSeconds,
                  loadingProgress: widget.loadingProgress,
                  isSelectionMode: widget.isSelectionMode,
                  selectionStart: widget.selectionStart,
                  selectionEnd: widget.selectionEnd,
                  backgroundColor: context.grays.white,
                  borderColor: context.grays.gray7,
                  waveformColor: context.grays.gray3,
                  playheadBorderColor: context.grays.gray5,
                  playheadFillColor: context.grays.white,
                  selectionFillColor: context.brands.beatOrange5,
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

class _CloudAudioWaveformPainter extends CustomPainter {
  const _CloudAudioWaveformPainter({
    required this.waveform,
    required this.duration,
    required this.viewportPosition,
    required this.visibleSeconds,
    required this.loadingProgress,
    required this.isSelectionMode,
    required this.selectionStart,
    required this.selectionEnd,
    required this.backgroundColor,
    required this.borderColor,
    required this.waveformColor,
    required this.playheadBorderColor,
    required this.playheadFillColor,
    required this.selectionFillColor,
    required this.containerHeight,
    required this.playheadExtension,
  });

  static const double _playheadWidth = 8.0;
  static const double _playheadBorderWidth = 1.0;
  static const double _waveformBarWidth = 3.0;
  static const double _waveformBarGap = 3.0;

  final Waveform? waveform;
  final Duration duration;
  final Duration viewportPosition;
  final double visibleSeconds;
  final double loadingProgress;
  final bool isSelectionMode;
  final Duration selectionStart;
  final Duration selectionEnd;
  final Color backgroundColor;
  final Color borderColor;
  final Color waveformColor;
  final Color playheadBorderColor;
  final Color playheadFillColor;
  final Color selectionFillColor;
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

    if (isSelectionMode && duration > Duration.zero && visibleSeconds > 0) {
      _paintSelectionFill(canvas, waveformRect);
    }

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

    if (isSelectionMode) {
      _paintSelectionHandles(canvas, size);
    } else {
      _paintPlayhead(canvas, size.width / 2, size.height);
    }
  }

  void _paintSelectionFill(Canvas canvas, Rect rect) {
    final startX = _timeToX(selectionStart, rect.width);
    final endX = _timeToX(selectionEnd, rect.width);
    final left = math.max(rect.left, math.min(startX, endX));
    final right = math.min(rect.right, math.max(startX, endX));

    if (right <= left) return;

    canvas.drawRect(
      Rect.fromLTRB(left, rect.top, right, rect.bottom),
      Paint()
        ..style = PaintingStyle.fill
        ..color = selectionFillColor,
    );
  }

  void _paintSelectionHandles(Canvas canvas, Size size) {
    final startX = _timeToX(selectionStart, size.width);
    final endX = _timeToX(selectionEnd, size.width);

    if (startX >= -_playheadWidth && startX <= size.width + _playheadWidth) {
      _paintPlayhead(canvas, startX, size.height);
    }
    if (endX >= -_playheadWidth && endX <= size.width + _playheadWidth) {
      _paintPlayhead(canvas, endX, size.height);
    }
  }

  void _paintPlayhead(Canvas canvas, double centerX, double height) {
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - (_playheadWidth / 2), 0, _playheadWidth, height),
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
        height - (_playheadBorderWidth * 2),
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

    final positionSeconds = _durationInSeconds(viewportPosition);
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

  double _timeToX(Duration time, double width) {
    if (width <= 0 || visibleSeconds <= 0) return width / 2;

    final windowStart =
        _durationInSeconds(viewportPosition) - (visibleSeconds / 2);
    return ((_durationInSeconds(time) - windowStart) / visibleSeconds) * width;
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
  bool shouldRepaint(covariant _CloudAudioWaveformPainter oldDelegate) {
    return oldDelegate.waveform != waveform ||
        oldDelegate.duration != duration ||
        oldDelegate.viewportPosition != viewportPosition ||
        oldDelegate.visibleSeconds != visibleSeconds ||
        oldDelegate.loadingProgress != loadingProgress ||
        oldDelegate.isSelectionMode != isSelectionMode ||
        oldDelegate.selectionStart != selectionStart ||
        oldDelegate.selectionEnd != selectionEnd ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.waveformColor != waveformColor ||
        oldDelegate.playheadBorderColor != playheadBorderColor ||
        oldDelegate.playheadFillColor != playheadFillColor ||
        oldDelegate.selectionFillColor != selectionFillColor;
  }
}
