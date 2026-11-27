import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 백그라운드/종료 상태에서 누른 시스템 푸시를 로그인 화면과 분리해 보관한다.
/// 인증 및 메인 셸 진입이 완료된 뒤에만 대상 화면으로 이동한다.
class PendingAlarmPushNotifier extends Notifier<RemoteMessage?> {
  @override
  RemoteMessage? build() => null;

  void queue(RemoteMessage message) => state = message;

  RemoteMessage? take() {
    final pending = state;
    state = null;
    return pending;
  }

  void clear() => state = null;
}

final pendingAlarmPushProvider =
    NotifierProvider<PendingAlarmPushNotifier, RemoteMessage?>(
      PendingAlarmPushNotifier.new,
    );
