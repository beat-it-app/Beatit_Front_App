import 'dart:async';
import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Android 포그라운드 FCM 알림을 실제 Navigator Overlay 위에 표시한다.
/// 백그라운드/종료 상태의 기존 시스템 푸시 알림에는 관여하지 않는다.
class ForegroundAlarmBannerHost extends ConsumerStatefulWidget {
  const ForegroundAlarmBannerHost({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  ConsumerState<ForegroundAlarmBannerHost> createState() =>
      _ForegroundAlarmBannerHostState();
}

class _ForegroundAlarmBannerHostState
    extends ConsumerState<ForegroundAlarmBannerHost> {
  static const _displayDuration = Duration(seconds: 1000);

  StreamSubscription<RemoteMessage>? _messageSubscription;
  Timer? _hideTimer;
  OverlayEntry? _bannerEntry;
  _ForegroundAlarm? _visibleAlarm;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isAndroid) {
      _messageSubscription = FirebaseMessaging.onMessage.listen(
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
    _visibleAlarm = _ForegroundAlarm(title, body);

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
              child: Material(
                color: colors.surface.withValues(alpha: 0.95),
                elevation: 1,
                shadowColor: context.grays.black.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                clipBehavior: Clip.antiAlias,
                child: Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
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
                                  maxLines: 2,
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
    );
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
  const _ForegroundAlarm(this.title, this.body);

  final String title;
  final String body;
}
