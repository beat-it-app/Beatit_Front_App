import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';

/// 앱 알림함에는 채팅 알림을 표시하지 않는다.
/// 서버의 CHAT 제외 조회와 별개로, 구버전/예외 응답에서도 동일한 정책을 유지한다.
bool isVisibleInAlarmList(AlarmNotification notification) {
  final category = notification.category.trim().toUpperCase();
  final type = notification.type.trim().toUpperCase();
  final path = notification.directTo?.trim().toLowerCase() ?? '';
  return category != 'CHAT' &&
      type != 'CHAT_MESSAGE' &&
      !path.startsWith('/chats/');
}
