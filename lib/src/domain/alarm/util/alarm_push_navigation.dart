import 'package:beatit_front_app/src/domain/alarm/provider/alarm_api_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/alarm_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/util/alarm_navigation.dart';
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_switch_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 시스템 푸시와 포그라운드 배너에 동일한 클릭/이동 경로를 적용한다.
/// 서버의 /click 응답만을 화면 이동의 기준으로 사용한다.
Future<void> openAlarmFromPush({
  required WidgetRef ref,
  required NavigatorState navigator,
  required RemoteMessage message,
}) async {
  final notificationId = int.tryParse(
    message.data['notificationId']?.toString() ?? '',
  );
  if (notificationId == null || notificationId <= 0) {
    debugPrint('[AlarmPush] Invalid notificationId in push data');
    if (navigator.mounted) {
      ScaffoldMessenger.maybeOf(navigator.context)?.showSnackBar(
        const SnackBar(content: Text('이 알림은 이동 정보를 확인할 수 없습니다.')),
      );
    }
    return;
  }

  try {
    // 목록 조회/읽음 처리 중인 경우에도 시스템 푸시 이동은 차단하지 않는다.
    // /click은 서버의 현재 팀을 변경하고 알림을 읽음 처리한다.
    // 팀 전환 여부를 판단하기 위해 /click 전의 팀을 보관한다.
    final previousTeamId =
        ref.read(currentTeamProvider).asData?.value?.teamId;
    final target = await ref.read(alarmApiProvider).clickNotification(
      notificationId,
    );
    if (!navigator.mounted) return;

    // 이전 팀을 알 수 없으면(앱 시작 중 등) 바뀐 것으로 간주한다.
    if (previousTeamId == null || previousTeamId != target.targetTeamId) {
      refreshTeamData(ref);
    } else {
      // 같은 팀이면 알림의 읽음 상태만 갱신한다.
      ref.invalidate(alarmProvider);
    }

    navigateToAlarmTarget(navigator, target);
  } catch (error) {
    debugPrint('[AlarmPush] Notification navigation failed: $error');
    if (!navigator.mounted) return;
    ScaffoldMessenger.maybeOf(navigator.context)?.showSnackBar(
      const SnackBar(content: Text('알림을 열지 못했습니다. 다시 시도해주세요.')),
    );
  }
}
