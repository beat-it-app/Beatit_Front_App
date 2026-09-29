import 'dart:async';
import 'dart:math' as math;

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef CloudVideoSelectionChanged = void Function(Duration start, Duration end);

/// 영상 전체에서 소수의 고정 썸네일을 한 번 준비한 뒤,
/// 재생 위치/확대 배율이 변해도 같은 썸네일을 재사용하는 Cloud 영상 타임라인이다.
///
/// 메인 영상 재생과는 완전히 별개의 paused controller를 사용하므로,
/// 타임라인 썸네일 때문에 실제 영상의 재생 위치가 변경되지 않는다.
class CloudVideoTimeline extends StatefulWidget {
  const CloudVideoTimeline({
    super.key,
    required this.videoUri,
    required this.duration,
    required this.position,
    required this.isSelectionMode,
    required this.selectionStart,
    required this.selectionEnd,
    required this.onSeek,
    this.requestHeaders,
    this.onSelectionChanged,
    this.onSelectionChangeEnd,
  });

  final Uri videoUri;
  final Map<String, String>? requestHeaders;
  final Duration duration;
  final Duration position;
  final bool isSelectionMode;
  final Duration selectionStart;
  final Duration selectionEnd;
  final ValueChanged<Duration> onSeek;
  final CloudVideoSelectionChanged? onSelectionChanged;
  final CloudVideoSelectionChanged? onSelectionChangeEnd;

  @override
  State<CloudVideoTimeline> createState() => _CloudVideoTimelineState();
}

enum _SelectionHandle { start, end }

class _FixedVideoThumbnail {
  const _FixedVideoThumbnail({
    required this.index,
    required this.controller,
  });

  final int index;
  final VideoPlayerController controller;
}

class _CloudVideoTimelineState extends State<CloudVideoTimeline> {
  // Audio waveform과 동일한 zoom 범위: 1/3 ~ 3/3.
  static const double _minVisibleFraction = 1 / 3;
  static const double _maxVisibleFraction = 1.0;

  // Audio waveform과 동일한 전체 높이: 60 + 위/아래 4 = 68.
  static const double _containerHeight = 60.0;
  static const double _playheadExtension = 4.0;
  static const double _innerPadding = 6.0;

  static const double _handleHitSlop = 22.0;
  static const double _autoScrollEdge = 34.0;
  static const Duration _minimumSelectionGap = Duration(milliseconds: 100);

  // 영상 전체에서 딱 이 개수만 고정 샘플링하고 이후 계속 재사용한다.
  static const int _thumbnailCount = 8;

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

  int _thumbnailLoadId = 0;
  final Map<int, _FixedVideoThumbnail> _thumbnails = {};

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
  void initState() {
    super.initState();
    unawaited(_prepareFixedThumbnails());
  }

  @override
  void didUpdateWidget(covariant CloudVideoTimeline oldWidget) {
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
    }

    if (oldWidget.videoUri != widget.videoUri ||
        oldWidget.duration != widget.duration) {
      unawaited(_prepareFixedThumbnails());
    }
  }

  Future<void> _prepareFixedThumbnails() async {
    final loadId = ++_thumbnailLoadId;
    await _disposeThumbnails();

    if (!mounted ||
        loadId != _thumbnailLoadId ||
        widget.duration <= Duration.zero) {
      return;
    }

    final durationUs = widget.duration.inMicroseconds;

    // 각 구간의 중앙 시점만 한 번 seek한다.
    // 이후 pan / zoom / 재생 중에는 다시 seek하지 않는다.
    for (int index = 0; index < _thumbnailCount; index += 1) {
      if (!mounted || loadId != _thumbnailLoadId) {
        return;
      }

      final sampleUs = ((durationUs * (index + 0.5)) / _thumbnailCount)
          .round()
          .clamp(0, durationUs)
          .toInt();
      final samplePosition = Duration(microseconds: sampleUs);

      final controller = VideoPlayerController.networkUrl(
        widget.videoUri,
        httpHeaders: widget.requestHeaders ?? const <String, String>{},
      );

      try {
        await controller.initialize();
        await controller.setVolume(0.0);
        await controller.setLooping(false);
        await controller.seekTo(samplePosition);
        await controller.pause();

        if (!mounted || loadId != _thumbnailLoadId) {
          await controller.dispose();
          return;
        }

        setState(() {
          _thumbnails[index] = _FixedVideoThumbnail(
            index: index,
            controller: controller,
          );
        });
      } catch (_) {
        await controller.dispose();
        // 하나의 샘플이 실패해도 나머지 고정 썸네일은 계속 준비한다.
      }
    }
  }

  Future<void> _disposeThumbnails() async {
    final values = _thumbnails.values.toList(growable: false);
    _thumbnails.clear();

    for (final thumbnail in values) {
      await thumbnail.controller.dispose();
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
      // Audio와 동일하게 0초/마지막 초 자체가 viewport 중앙까지 올 수 있다.
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
    final nextCenter = (currentCenter + deltaSeconds)
        .clamp(0.0, _durationInSeconds(widget.duration))
        .toDouble();

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

  List<Widget> _buildFixedThumbnailSegments(
    BuildContext context,
    double width,
    double height,
  ) {
    if (widget.duration <= Duration.zero || width <= 0 || height <= 0) {
      return const [];
    }

    final durationSeconds = _durationInSeconds(widget.duration);
    final centerSeconds = _durationInSeconds(_viewportCenter);
    final windowStart = centerSeconds - (_visibleSeconds / 2);
    final segmentSeconds = durationSeconds / _thumbnailCount;
    final segmentWidth = (segmentSeconds / _visibleSeconds) * width;

    final children = <Widget>[];

    for (int index = 0; index < _thumbnailCount; index += 1) {
      final segmentStart = segmentSeconds * index;
      final segmentEnd = segmentSeconds * (index + 1);
      final left = ((segmentStart - windowStart) / _visibleSeconds) * width;
      final right = ((segmentEnd - windowStart) / _visibleSeconds) * width;

      if (right <= 0 || left >= width || segmentWidth <= 0) {
        continue;
      }

      final thumbnail = _thumbnails[index];

      children.add(
        Positioned(
          left: left,
          width: segmentWidth + 0.5,
          top: 0,
          bottom: 0,
          child: thumbnail == null
              ? ColoredBox(color: context.grays.gray8)
              : _FixedThumbnailView(controller: thumbnail.controller),
        ),
      );
    }

    return children;
  }

  @override
  void dispose() {
    ++_thumbnailLoadId;
    _stopAutoScroll();
    unawaited(_disposeThumbnails());
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

          final innerWidth = math.max(
            0.0,
            constraints.maxWidth - (_innerPadding * 2),
          );
          final innerHeight = _containerHeight - (_innerPadding * 2);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: (details) {
              _handleScaleStart(details, constraints.maxWidth);
            },
            onScaleUpdate: (details) {
              _handleScaleUpdate(details, constraints.maxWidth);
            },
            onScaleEnd: _handleScaleEnd,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _CloudVideoTimelineBackgroundPainter(
                    backgroundColor: context.grays.white,
                    borderColor: context.grays.gray7,
                    containerHeight: _containerHeight,
                    playheadExtension: _playheadExtension,
                  ),
                ),
                Positioned(
                  left: _innerPadding,
                  right: _innerPadding,
                  top: _playheadExtension + _innerPadding,
                  height: innerHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: _buildFixedThumbnailSegments(
                        context,
                        innerWidth,
                        innerHeight,
                      ),
                    ),
                  ),
                ),
                CustomPaint(
                  painter: _CloudVideoTimelineForegroundPainter(
                    duration: widget.duration,
                    viewportPosition: _viewportCenter,
                    visibleSeconds: _visibleSeconds,
                    isSelectionMode: widget.isSelectionMode,
                    selectionStart: widget.selectionStart,
                    selectionEnd: widget.selectionEnd,
                    outsideSelectionColor: context.grays.white.withValues(
                      alpha: 0.65,
                    ),
                    playheadBorderColor: context.grays.gray5,
                    playheadFillColor: context.grays.white,
                    containerHeight: _containerHeight,
                    playheadExtension: _playheadExtension,
                    innerPadding: _innerPadding,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FixedThumbnailView extends StatelessWidget {
  const _FixedThumbnailView({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    if (!value.isInitialized || value.size.isEmpty) {
      return ColoredBox(color: context.grays.gray8);
    }

    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: value.size.width,
          height: value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

class _CloudVideoTimelineBackgroundPainter extends CustomPainter {
  const _CloudVideoTimelineBackgroundPainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.containerHeight,
    required this.playheadExtension,
  });

  final Color backgroundColor;
  final Color borderColor;
  final double containerHeight;
  final double playheadExtension;

  @override
  void paint(Canvas canvas, Size size) {
    final top = playheadExtension;
    final outerRect = Rect.fromLTWH(0, top, size.width, containerHeight);
    final outerRRect = RRect.fromRectAndRadius(
      outerRect,
      const Radius.circular(18.0),
    );

    canvas.drawRRect(
      outerRRect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = backgroundColor,
    );
    canvas.drawRRect(
      outerRRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant _CloudVideoTimelineBackgroundPainter old) {
    return old.backgroundColor != backgroundColor ||
        old.borderColor != borderColor ||
        old.containerHeight != containerHeight ||
        old.playheadExtension != playheadExtension;
  }
}

class _CloudVideoTimelineForegroundPainter extends CustomPainter {
  const _CloudVideoTimelineForegroundPainter({
    required this.duration,
    required this.viewportPosition,
    required this.visibleSeconds,
    required this.isSelectionMode,
    required this.selectionStart,
    required this.selectionEnd,
    required this.outsideSelectionColor,
    required this.playheadBorderColor,
    required this.playheadFillColor,
    required this.containerHeight,
    required this.playheadExtension,
    required this.innerPadding,
  });

  static const double _playheadWidth = 8.0;
  static const double _playheadBorderWidth = 1.0;

  final Duration duration;
  final Duration viewportPosition;
  final double visibleSeconds;
  final bool isSelectionMode;
  final Duration selectionStart;
  final Duration selectionEnd;
  final Color outsideSelectionColor;
  final Color playheadBorderColor;
  final Color playheadFillColor;
  final double containerHeight;
  final double playheadExtension;
  final double innerPadding;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    if (isSelectionMode) {
      _paintOutsideSelection(canvas, size);
      _paintSelectionHandles(canvas, size);
    } else {
      _paintPlayhead(canvas, size.width / 2, size.height);
    }
  }

  void _paintOutsideSelection(Canvas canvas, Size size) {
    final innerRect = Rect.fromLTWH(
      innerPadding,
      playheadExtension + innerPadding,
      math.max(0.0, size.width - (innerPadding * 2)),
      containerHeight - (innerPadding * 2),
    );

    final startX = innerRect.left + _timeToX(selectionStart, innerRect.width);
    final endX = innerRect.left + _timeToX(selectionEnd, innerRect.width);
    final left = math.max(innerRect.left, math.min(startX, endX));
    final right = math.min(innerRect.right, math.max(startX, endX));
    final paint = Paint()..color = outsideSelectionColor;

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(innerRect, const Radius.circular(12.0)),
    );

    if (left > innerRect.left) {
      canvas.drawRect(
        Rect.fromLTRB(innerRect.left, innerRect.top, left, innerRect.bottom),
        paint,
      );
    }

    if (right < innerRect.right) {
      canvas.drawRect(
        Rect.fromLTRB(right, innerRect.top, innerRect.right, innerRect.bottom),
        paint,
      );
    }

    canvas.restore();
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

  double _timeToX(Duration time, double width) {
    if (width <= 0 || visibleSeconds <= 0) return width / 2;

    final windowStart =
        _durationInSeconds(viewportPosition) - (visibleSeconds / 2);
    return ((_durationInSeconds(time) - windowStart) / visibleSeconds) * width;
  }

  double _durationInSeconds(Duration value) {
    return value.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  bool shouldRepaint(covariant _CloudVideoTimelineForegroundPainter old) {
    return old.duration != duration ||
        old.viewportPosition != viewportPosition ||
        old.visibleSeconds != visibleSeconds ||
        old.isSelectionMode != isSelectionMode ||
        old.selectionStart != selectionStart ||
        old.selectionEnd != selectionEnd ||
        old.outsideSelectionColor != outsideSelectionColor ||
        old.playheadBorderColor != playheadBorderColor ||
        old.playheadFillColor != playheadFillColor ||
        old.containerHeight != containerHeight ||
        old.playheadExtension != playheadExtension ||
        old.innerPadding != innerPadding;
  }
}
