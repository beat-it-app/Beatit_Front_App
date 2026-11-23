import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beatit_front_app/src/domain/alarm/util/alarm_push_group.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Android 알림창에서 채팅/게시물/일정/팀 활동을 실제 notification group으로 묶는다.
/// 포그라운드 메시지만 직접 표시한다. 백그라운드의 notification payload는
/// FCM SDK가 시스템에 표시하므로 여기에서 재표시하면 중복 알림이 된다.
class AndroidGroupedAlarmNotifications {
  AndroidGroupedAlarmNotifications._();

  static final instance = AndroidGroupedAlarmNotifications._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<RemoteMessage> _taps =
      StreamController<RemoteMessage>.broadcast();

  Future<void>? _initializing;
  RemoteMessage? _pendingTap;
  int _fallbackId = 1000000000;

  Stream<RemoteMessage> get onTap => _taps.stream;

  RemoteMessage? takePendingTap() {
    final message = _pendingTap;
    _pendingTap = null;
    return message;
  }

  Future<void> initialize() {
    if (kIsWeb || !Platform.isAndroid) return Future<void>.value();
    return _initializing ??= _initializeOnce();
  }

  Future<void> _initializeOnce() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        for (final group in AlarmPushGroup.values) {
          await android.createNotificationChannel(
            AndroidNotificationChannel(
              group.channelId,
              group.label,
              description: 'Beatit ${group.label} 알림',
              importance: Importance.defaultImportance,
            ),
          );
        }
      }

      // 포그라운드 로컬 알림으로 종료된 앱을 실행한 경우도 기존 푸시 이동으로 연결한다.
      final launch = await _plugin.getNotificationAppLaunchDetails();
      final response = launch?.notificationResponse;
      if (launch?.didNotificationLaunchApp == true && response != null) {
        _onNotificationTap(response);
      }
    } catch (error) {
      _initializing = null;
      debugPrint('[AlarmGroup] initialization failed: $error');
      rethrow;
    }
  }

  /// 앱이 켜져 있을 때 FCM notification을 OS 알림창에도 표시한다.
  /// 채팅은 앱 내부 배너에서는 숨겨도 디바이스 알림 목록에는 정상 표시한다.
  Future<void> showForeground(RemoteMessage message) async {
    if (kIsWeb || !Platform.isAndroid) return;
    final title = message.notification?.title?.trim() ?? '';
    final body = message.notification?.body?.trim() ?? '';
    if (title.isEmpty && body.isEmpty) return;

    try {
      await initialize();
      final group = AlarmPushGroup.fromData(message.data);
      final id = _notificationId(message);
      final payload = jsonEncode({
        'data': message.data,
        'title': title,
        'body': body,
        if (message.messageId != null) 'messageId': message.messageId,
      });

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            group.channelId,
            group.label,
            channelDescription: 'Beatit ${group.label} 알림',
            groupKey: group.groupKey,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            groupAlertBehavior: GroupAlertBehavior.children,
          ),
        ),
        payload: payload,
      );
      await _updateSummary(group, latestPayload: payload);
    } catch (error) {
      // 로컬 알림에 문제가 생겨도 기존 인앱 알림 및 인증 플로우는 유지한다.
      debugPrint('[AlarmGroup] foreground notification failed: $error');
    }
  }

  int _notificationId(RemoteMessage message) {
    final serverId = int.tryParse(
      message.data['notificationId']?.toString() ?? '',
    );
    if (serverId != null && serverId > 0 && serverId < 1000000000) {
      return serverId;
    }
    // notificationId가 없는 예외 메시지만 프로세스 내 고유 ID를 사용한다.
    _fallbackId = _fallbackId >= 2000000000 ? 1000000000 : _fallbackId + 1;
    return _fallbackId;
  }

  /// Android 7 이전 기기에서도 묶여 보이도록 summary를 명시한다.
  Future<void> _updateSummary(
    AlarmPushGroup group, {
    required String latestPayload,
  }) async {
    final active = await _plugin.getActiveNotifications();
    final children = active.where((notification) =>
        notification.groupKey == group.groupKey &&
        notification.id != group.summaryId).toList();

    if (children.length < 2) {
      await _plugin.cancel(id: group.summaryId);
      return;
    }

    final lines = children
        .take(5)
        .map((notification) =>
            '${notification.title ?? group.label}: ${notification.body ?? ''}')
        .toList();
    await _plugin.show(
      id: group.summaryId,
      title: '${group.label} 알림',
      body: '${children.length}개의 알림',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          group.channelId,
          group.label,
          groupKey: group.groupKey,
          setAsGroupSummary: true,
          groupAlertBehavior: GroupAlertBehavior.children,
          importance: Importance.defaultImportance,
          priority: Priority.low,
          silent: true,
          onlyAlertOnce: true,
          styleInformation: InboxStyleInformation(
            lines,
            contentTitle: '${children.length}개의 알림',
            summaryText: group.label,
          ),
        ),
      ),
      // 그룹 제목을 탭해도 이동 정보가 없는 화면으로 가지 않도록
      // 최근 알림의 payload를 연결한다.
      payload: latestPayload,
    );
  }

  /// 앱 복귀 후 사용자가 알림을 직접 지운 경우의 summary 개수를 정리한다.
  Future<void> refreshSummaries() async {
    if (kIsWeb || !Platform.isAndroid || _initializing == null) return;
    try {
      final active = await _plugin.getActiveNotifications();
      for (final group in AlarmPushGroup.values) {
        final count = active.where((n) =>
            n.groupKey == group.groupKey && n.id != group.summaryId).length;
        if (count < 2) await _plugin.cancel(id: group.summaryId);
      }
    } catch (error) {
      debugPrint('[AlarmGroup] summary refresh skipped: $error');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    final raw = response.payload;
    if (raw == null || raw.isEmpty) return;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return;
      final data = json['data'];
      if (data is! Map<String, dynamic>) return;
      final message = RemoteMessage(
        data: data,
        messageId: json['messageId']?.toString(),
        notification: RemoteNotification(
          title: json['title']?.toString(),
          body: json['body']?.toString(),
        ),
      );
      if (_taps.hasListener) {
        _taps.add(message);
      } else {
        _pendingTap = message;
      }
    } catch (error) {
      debugPrint('[AlarmGroup] invalid tap payload: $error');
    }
  }
}
