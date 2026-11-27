import 'package:beatit_front_app/src/domain/alarm/model/alarm_setting_models.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/alarm_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API에서 지원하는 필드만 사용한다. 프론트에서 별도로 연쇄 변경하지 않는다.
enum AlarmSettingKey {
  all('allNotification'),
  activity('activitySection'),
  calendar('calendarSchedule'),
  activityNews('teamActivitySpace'),
  activityComments('activityCommentMention'),
  collaboration('collaborationSection'),
  notice('notice'),
  pollMeetit('pollAndMeetit'),
  results('progressResult'),
  collaborationComments('collaborationCommentMention'),
  chatPush('chatMessage'),
  team('teamManageSection'),
  position('positionChange'),
  memberChanges('memberChange');

  const AlarmSettingKey(this.apiField);
  final String apiField;

  bool valueOf(AlarmSettingsData settings) => switch (this) {
    AlarmSettingKey.all => settings.allNotification,
    AlarmSettingKey.activity => settings.activitySection,
    AlarmSettingKey.calendar => settings.calendarSchedule,
    AlarmSettingKey.activityNews => settings.teamActivitySpace,
    AlarmSettingKey.activityComments => settings.activityCommentMention,
    AlarmSettingKey.collaboration => settings.collaborationSection,
    AlarmSettingKey.notice => settings.notice,
    AlarmSettingKey.pollMeetit => settings.pollAndMeetit,
    AlarmSettingKey.results => settings.progressResult,
    AlarmSettingKey.collaborationComments => settings.collaborationCommentMention,
    AlarmSettingKey.chatPush => settings.chatMessage,
    AlarmSettingKey.team => settings.teamManageSection,
    AlarmSettingKey.position => settings.positionChange,
    AlarmSettingKey.memberChanges => settings.memberChange ?? false,
  };
}

class AlarmSettingState {
  const AlarmSettingState({
    this.isLoading = false,
    this.isSaving = false,
    this.settings,
    this.errorMessage,
    this.pendingKey,
    this.pendingValue,
  });

  final bool isLoading;
  final bool isSaving;
  final AlarmSettingsData? settings;
  final String? errorMessage;

  /// 서버 저장 중 사용자에게 즉시 보여줄, 방금 누른 스위치의 값.
  /// 다른 설정 값은 서버 응답이 도착할 때까지 그대로 유지한다.
  final AlarmSettingKey? pendingKey;
  final bool? pendingValue;

  AlarmSettingState copyWith({
    bool? isLoading,
    bool? isSaving,
    AlarmSettingsData? settings,
    String? errorMessage,
    bool clearError = false,
    AlarmSettingKey? pendingKey,
    bool? pendingValue,
  }) => AlarmSettingState(
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    settings: settings ?? this.settings,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    pendingKey: pendingKey ?? this.pendingKey,
    pendingValue: pendingValue ?? this.pendingValue,
  );
}

class AlarmSettingNotifier extends Notifier<AlarmSettingState> {
  @override
  AlarmSettingState build() => const AlarmSettingState();

  Future<void> fetchSettings() async {
    if (state.isLoading || state.isSaving) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ref.read(alarmApiProvider).getSettings();
      if (!ref.mounted) return;
      state = AlarmSettingState(settings: response);
    } catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<bool> setValue(AlarmSettingKey key, bool next) async {
    final current = state.settings;
    if (current == null || state.isLoading || state.isSaving) return false;
    if (key == AlarmSettingKey.memberChanges && !current.isManager) {
      return false;
    }
    if (key.valueOf(current) == next) return true;

    // 시각적 비활성화 없이, 눌린 스위치의 값만 먼저 보여준다.
    // 다른 스위치의 터치는 화면에서만 잠시 차단한다.
    state = state.copyWith(
      isSaving: true,
      clearError: true,
      pendingKey: key,
      pendingValue: next,
    );
    try {
      final response = await ref.read(alarmApiProvider).updateSetting(
        key.apiField,
        next,
      );
      if (!ref.mounted) return false;
      // updateAll/update*Section의 하위 설정 변경을 서버 응답 그대로 반영한다.
      state = AlarmSettingState(settings: response);
      return true;
    } catch (error) {
      if (!ref.mounted) return false;
      // 실패하면 서버에 마지막으로 확인된 설정을 그대로 복구한다.
      state = AlarmSettingState(
        settings: current,
        errorMessage: error.toString(),
      );
      return false;
    }
  }
}

final alarmSettingProvider = NotifierProvider.autoDispose<
    AlarmSettingNotifier, AlarmSettingState>(
  AlarmSettingNotifier.new,
);
