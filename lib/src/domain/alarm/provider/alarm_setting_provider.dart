import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 서버 설정 API는 제공되지 않는다. 앱 실행 중 화면 선택 상태만 유지한다.
enum AlarmSettingKey {
  all,
  activity,
  calendar,
  activityNews,
  activityComments,
  collaboration,
  notice,
  pollMeetit,
  results,
  collaborationComments,
  chatPush,
  team,
  position,
  memberChanges,
}

class AlarmSettingNotifier extends Notifier<Map<AlarmSettingKey, bool>> {
  @override
  Map<AlarmSettingKey, bool> build() => const {
    AlarmSettingKey.all: true,
    AlarmSettingKey.activity: true,
    AlarmSettingKey.calendar: false,
    AlarmSettingKey.activityNews: false,
    AlarmSettingKey.activityComments: false,
    AlarmSettingKey.collaboration: true,
    AlarmSettingKey.notice: true,
    AlarmSettingKey.pollMeetit: true,
    AlarmSettingKey.results: true,
    AlarmSettingKey.collaborationComments: true,
    AlarmSettingKey.chatPush: true,
    AlarmSettingKey.team: false,
    AlarmSettingKey.position: false,
    AlarmSettingKey.memberChanges: false,
  };

  void setValue(AlarmSettingKey key, bool value) {
    state = {...state, key: value};
  }
}

final alarmSettingProvider = NotifierProvider<
    AlarmSettingNotifier, Map<AlarmSettingKey, bool>>(
  AlarmSettingNotifier.new,
);
