import 'dart:async';
import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/alarm_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/util/alarm_navigation.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/provider/mypage_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Android/iOS 포그라운드 FCM 알림을 실제 Navigator Overlay 위에 표시한다.
/// 백그라운드/종료 상태의 기존 시스템 푸시 알림에는 관여하지 않는다.
class ForegroundAlarmBannerHost extends ConsumerStatefulWidget {
  const ForegroundAlarmBannerHost({
    super.key,
    required this.child,
    required this.navigatorKey,
    this.messages,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  /// 테스트용 주입 스트림. null이면 Android/iOS에서 FirebaseMessaging.onMessage를 사용한다.
  final Stream<RemoteMessage>? messages;

  @override
  ConsumerState<ForegroundAlarmBannerHost> createState() =>
      _ForegroundAlarmBannerHostState();
}

class _ForegroundAlarmBannerHostState
    extends ConsumerState<ForegroundAlarmBannerHost> {
  static const _displayDuration = Duration(seconds: 20);

  StreamSubscription<RemoteMessage>? _messageSubscription;
  Timer? _hideTimer;
  OverlayEntry? _bannerEntry;
  _ForegroundAlarm? _visibleAlarm;

  @override
  void initState() {
    super.initState();
    final injected = widget.messages;
    // iOS도 포그라운드에서는 시스템 배너가 뜨지 않으므로 동일하게 앱 배너를 쓴다.
    if (injected != null ||
        (!kIsWeb && (Platform.isAndroid || Platform.isIOS))) {
      _messageSubscription = (injected ?? FirebaseMessaging.onMessage).listen(
        _onForegroundMessage,
        onError: (Object error) {
          debugPrint('[ForegroundAlarm] message listener error: $error');
        },
      );
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (!mounted || ref.read(authProvider).asData?.value == null) return;

    if (message.data['type'] == 'CHAT_MESSAGE') return;

    final title = message.notification?.title?.trim() ?? '';
    final body = message.notification?.body?.trim() ?? '';
    if (title.isEmpty && body.isEmpty) return;

    final overlay = widget.navigatorKey.currentState?.overlay;
    if (overlay == null || !overlay.mounted) {
      debugPrint('[ForegroundAlarm] Navigator Overlay is not ready');
      return;
    }

    _hideTimer?.cancel();
    _visibleAlarm = _ForegroundAlarm(
      title,
      body,
      int.tryParse(message.data['notificationId']?.toString() ?? ''),
    );

    if (_bannerEntry == null) {
      final entry = OverlayEntry(builder: _buildBannerEntry);
      _bannerEntry = entry;
      overlay.insert(entry);
    } else {
      _bannerEntry!.markNeedsBuild();
    }

    _hideTimer = Timer(_displayDuration, _dismiss);
  }

  Widget _buildBannerEntry(BuildContext context) {
    final alarm = _visibleAlarm;
    if (alarm == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.x4,
              left: AppSpacing.x12,
              right: AppSpacing.x12,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: _SwipeDismissibleAlarmBanner(
                // 같은 문구의 새 알림도 별도 배너로 취급해 드래그 상태를 초기화한다.
                key: ObjectKey(alarm),
                onDismissed: () {
                  if (identical(_visibleAlarm, alarm)) _dismiss();
                },
                onTap: () => _openAlarm(alarm),
                child: Material(
                  color: colors.surface.withValues(alpha: 0.95),
                  elevation: 1,
                  shadowColor: context.grays.black.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                  clipBehavior: Clip.antiAlias,
                  child: Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x20,
                        vertical: 18.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (alarm.title.isNotEmpty)
                                  Text(
                                    alarm.title,
                                    style: FontStyles.semi18.copyWith(
                                      color: context.grays.gray1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (alarm.body.isNotEmpty) ...[
                                  const SizedBox(height: 2.0),
                                  Text(
                                    alarm.body,
                                    style: FontStyles.med16.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 배너를 탭하면 서버의 click API로 읽음 처리와 팀 전환을 하고 대상 화면으로 이동한다.
  /// 다른 팀의 알림이면 서버가 팀을 전환하므로 팀 관련 상태를 새로고침한다.
  Future<void> _openAlarm(_ForegroundAlarm alarm) async {
    final id = alarm.notificationId;
    _dismiss();
    final navigator = widget.navigatorKey.currentState;
    if (navigator == null) return;
    if (id == null) {
      debugPrint('[ForegroundAlarm] notificationId missing in push data');
      return;
    }

    final previousTeamId = ref.read(currentTeamProvider).asData?.value?.teamId;
    final target = await ref
        .read(alarmProvider.notifier)
        .readNotification(id, switchTeam: true);
    if (target == null || !mounted || !navigator.mounted) return;

    if (previousTeamId != target.targetTeamId) {
      ref.invalidate(currentTeamProvider);
      ref.invalidate(teamDetailProvider);
      ref.read(myPageProvider.notifier).fetchMyPage();
    }
    ref.invalidate(alarmProvider);
    navigateToAlarmTarget(navigator, target, notificationTitle: alarm.title);
  }

  void _dismiss() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _visibleAlarm = null;

    final entry = _bannerEntry;
    _bannerEntry = null;
    if (entry != null) {
      entry.remove();
      entry.dispose();
    }
  }

  @override
  void dispose() {
    _dismiss();
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 계정 변경/로그아웃 시 이전 계정의 배너가 남지 않도록 정리한다.
    ref.listen(authProvider, (previous, next) {
      if (next.asData?.value == null) _dismiss();
    });

    // Navigator는 MaterialApp이 생성하고, 배너만 Navigator Overlay에 띄운다.
    return widget.child;
  }
}

class _ForegroundAlarm {
  const _ForegroundAlarm(this.title, this.body, this.notificationId);

  final String title;
  final String body;
  final int? notificationId;
}

/// 배너 디자인은 유지하고 좌/우/위 스와이프 시 이동 애니메이션만 담당한다.
class _SwipeDismissibleAlarmBanner extends StatefulWidget {
  const _SwipeDismissibleAlarmBanner({
    super.key,
    required this.child,
    required this.onDismissed,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  State<_SwipeDismissibleAlarmBanner> createState() =>
      _SwipeDismissibleAlarmBannerState();
}

enum _SwipeAxis { horizontal, upward, ignored }

class _SwipeDismissibleAlarmBannerState
    extends State<_SwipeDismissibleAlarmBanner>
    with SingleTickerProviderStateMixin {
  static const _directionDetectionDistance = 8.0;
  static const _dismissDistance = 64.0;
  static const _flingVelocity = 700.0;
  static const _minFlingDistance = 12.0;
  static const _slideDuration = Duration(milliseconds: 240);

  late final AnimationController _slideController;
  Offset _totalDrag = Offset.zero;
  Offset _dragOffset = Offset.zero;
  Offset _animationStart = Offset.zero;
  Offset _animationEnd = Offset.zero;
  _SwipeAxis? _axis;
  bool _animating = false;
  bool _dismissAfterAnimation = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    )..addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;

    if (_dismissAfterAnimation) {
      widget.onDismissed();
      return;
    }

    setState(() {
      _animating = false;
      _dragOffset = Offset.zero;
    });
  }

  void _onPanStart(DragStartDetails _) {
    if (_dismissAfterAnimation) return;
    _slideController.stop();
    _slideController.reset();
    setState(() {
      _animating = false;
      _totalDrag = Offset.zero;
      _dragOffset = Offset.zero;
      _axis = null;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_dismissAfterAnimation) return;

    _totalDrag += details.delta;
    if (_axis == null && _totalDrag.distance >= _directionDetectionDistance) {
      if (_totalDrag.dx.abs() > _totalDrag.dy.abs()) {
        _axis = _SwipeAxis.horizontal;
      } else if (_totalDrag.dy < 0) {
        _axis = _SwipeAxis.upward;
      } else {
        // 아래쪽 드래그는 닫기 동작에 포함하지 않는다.
        _axis = _SwipeAxis.ignored;
      }
    }

    switch (_axis) {
      case _SwipeAxis.horizontal:
        setState(() {
          _dragOffset = Offset(_totalDrag.dx, 0);
        });
        break;
      case _SwipeAxis.upward:
        setState(() {
          _dragOffset = Offset(
            0,
            _totalDrag.dy < 0 ? _totalDrag.dy : 0.0,
          );
        });
        break;
      case _SwipeAxis.ignored:
      case null:
        break;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dismissAfterAnimation) return;

    final velocity = details.velocity.pixelsPerSecond;
    if (_axis == _SwipeAxis.horizontal &&
        (_dragOffset.dx.abs() >= _dismissDistance ||
            (_dragOffset.dx.abs() >= _minFlingDistance &&
                velocity.dx.abs() >= _flingVelocity))) {
      // 화면 너비보다 더 이동시켜 기기 크기와 관계없이 완전히 사라지게 한다.
      final distance = MediaQuery.sizeOf(context).width + 520;
      _animateTo(Offset(_dragOffset.dx.sign * distance, 0), dismiss: true);
    } else if (_axis == _SwipeAxis.upward &&
        (-_dragOffset.dy >= _dismissDistance ||
            (-_dragOffset.dy >= _minFlingDistance &&
                velocity.dy <= -_flingVelocity))) {
      _animateTo(Offset(0, -MediaQuery.sizeOf(context).height), dismiss: true);
    } else {
      // 짧은 스와이프는 닫지 않고 원래 위치로 되돌린다.
      _animateTo(Offset.zero, dismiss: false);
    }
  }

  void _onPanCancel() {
    if (!_dismissAfterAnimation) {
      _animateTo(Offset.zero, dismiss: false);
    }
  }

  void _animateTo(Offset target, {required bool dismiss}) {
    _slideController.stop();
    setState(() {
      _animationStart = _dragOffset;
      _animationEnd = target;
      _dismissAfterAnimation = dismiss;
      _animating = true;
    });
    _slideController.forward(from: 0);
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideController,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onPanCancel: _onPanCancel,
        child: widget.child,
      ),
      builder: (context, child) {
        final offset = _animating
            ? Offset.lerp(
                _animationStart,
                _animationEnd,
                Curves.easeOutCubic.transform(_slideController.value),
              )!
            : _dragOffset;
        return Transform.translate(offset: offset, child: child);
      },
    );
  }
}
