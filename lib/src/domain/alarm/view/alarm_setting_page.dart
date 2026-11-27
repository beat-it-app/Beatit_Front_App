import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_setting_models.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/alarm_setting_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/setting_switch_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmSettingPage extends ConsumerStatefulWidget {
  const AlarmSettingPage({super.key});

  @override
  ConsumerState<AlarmSettingPage> createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends ConsumerState<AlarmSettingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(alarmSettingProvider.notifier).fetchSettings();
    });
  }

  Future<void> _update(AlarmSettingKey key, bool next) async {
    final updated = await ref.read(alarmSettingProvider.notifier).setValue(key, next);
    if (!updated && mounted) {
      final message = ref.read(alarmSettingProvider).errorMessage;
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(alarmSettingProvider);
    final settings = state.settings;

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: settings == null
          ? Center(
              child: state.isLoading || state.errorMessage == null
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.errorMessage ?? '알림 설정을 불러오지 못했습니다.'),
                        const SizedBox(height: AppSpacing.x16),
                        TextButton(
                          onPressed: () => ref.read(alarmSettingProvider.notifier)
                              .fetchSettings(),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
            )
          : _settingsBody(context, settings, state),
    );
  }

  Widget _settingsBody(
    BuildContext context,
    AlarmSettingsData settings,
    AlarmSettingState state,
  ) {
    final allEnabled = settings.allNotification;
    final activityEnabled = allEnabled && settings.activitySection;
    final collaborationEnabled = allEnabled && settings.collaborationSection;
    final teamEnabled = allEnabled && settings.teamManageSection;

    Widget option({
      required AlarmSettingKey key,
      required AlarmSettingType type,
      required String title,
      String? description,
      bool enabled = true,
    }) => IgnorePointer(
      // 저장 중에는 터치만 차단한다. enabled를 바꾸면 모든 스위치가
      // 회색으로 변했다 돌아오는 시각적 깜빡임이 생긴다.
      ignoring: state.isSaving,
      child: SettingSwtichSection(
        type: type,
        title: title,
        description: description,
        value: state.pendingKey == key
            ? (state.pendingValue ?? key.valueOf(settings))
            : key.valueOf(settings),
        enabled: enabled,
        onChanged: (next) => _update(key, next),
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '알림 설정',
              style: FontStyles.bold34.copyWith(color: context.grays.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.x20),
            option(key: AlarmSettingKey.all, type: AlarmSettingType.main,
                title: '전체 알림'),
            Divider(color: context.grays.gray7),
            option(key: AlarmSettingKey.activity, type: AlarmSettingType.main,
                title: '일정 및 활동', enabled: allEnabled),
            Column(
              spacing: AppSpacing.x10,
              children: [
                option(key: AlarmSettingKey.calendar, type: AlarmSettingType.detail,
                    title: '캘린더 일정',
                    description: '새 일정 등록 및 일정 하루 전(D-1) 리마인드 알림을 받습니다.',
                    enabled: activityEnabled),
                option(key: AlarmSettingKey.activityNews, type: AlarmSettingType.detail,
                    title: '팀 활동 및 공간 소식', enabled: activityEnabled),
                option(key: AlarmSettingKey.activityComments, type: AlarmSettingType.detail,
                    title: '댓글 및 멘션', enabled: activityEnabled),
              ],
            ),
            const SizedBox(height: AppSpacing.x8),
            Divider(color: context.grays.gray7),
            option(key: AlarmSettingKey.collaboration, type: AlarmSettingType.main,
                title: '공지 및 협업', enabled: allEnabled),
            Column(
              spacing: AppSpacing.x10,
              children: [
                option(key: AlarmSettingKey.notice, type: AlarmSettingType.detail,
                    title: '공지사항', enabled: collaborationEnabled),
                option(key: AlarmSettingKey.pollMeetit, type: AlarmSettingType.detail,
                    title: '투표 / 밋잇', enabled: collaborationEnabled),
                option(key: AlarmSettingKey.results, type: AlarmSettingType.detail,
                    title: '진행 결과',
                    description: '내가 등록한 투표 및 밋잇의 전원 참여 완료 알림을 받습니다.',
                    enabled: collaborationEnabled),
                option(key: AlarmSettingKey.collaborationComments,
                    type: AlarmSettingType.detail,
                    title: '댓글 및 멘션', enabled: collaborationEnabled),
              ],
            ),
            const SizedBox(height: AppSpacing.x8),
            Divider(color: context.grays.gray7),
            const SettingSwtichSection(type: AlarmSettingType.main, title: '채팅'),
            option(key: AlarmSettingKey.chatPush, type: AlarmSettingType.detail,
                title: '채팅방 푸시 알림', enabled: allEnabled),
            const SizedBox(height: AppSpacing.x8),
            Divider(color: context.grays.gray7),
            option(key: AlarmSettingKey.team, type: AlarmSettingType.main,
                title: '팀 관리', enabled: allEnabled),
            option(key: AlarmSettingKey.position, type: AlarmSettingType.detail,
                title: '포지션 변경', description: '내 포지션이 변경되면 알림을 받습니다.',
                enabled: teamEnabled),
            if (settings.isManager)
              option(key: AlarmSettingKey.memberChanges,
                  type: AlarmSettingType.detail,
                  title: '멤버 변동 (운영진)',
                  description: '멤버 가입 및 탈퇴 알림을 받습니다.',
                  enabled: teamEnabled),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );
  }
}
