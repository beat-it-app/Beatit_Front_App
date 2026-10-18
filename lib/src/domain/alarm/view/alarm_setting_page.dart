import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/alarm/provider/alarm_setting_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/setting_switch_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmSettingPage extends ConsumerWidget {
  const AlarmSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(alarmSettingProvider);
    bool isOn(AlarmSettingKey key) => settings[key] ?? false;
    final allEnabled = isOn(AlarmSettingKey.all);
    final activityEnabled = allEnabled && isOn(AlarmSettingKey.activity);
    final collaborationEnabled = allEnabled && isOn(AlarmSettingKey.collaboration);
    final teamEnabled = allEnabled && isOn(AlarmSettingKey.team);

    SettingSwtichSection option({
      required AlarmSettingKey key,
      required AlarmSettingType type,
      required String title,
      String? description,
      bool enabled = true,
    }) => SettingSwtichSection(
      type: type,
      title: title,
      description: description,
      value: isOn(key),
      enabled: enabled,
      onChanged: (next) => ref.read(alarmSettingProvider.notifier).setValue(key, next),
    );

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
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
                  title: '채팅방 푸시 알림'),
              const SizedBox(height: AppSpacing.x8),
              Divider(color: context.grays.gray7),
              option(key: AlarmSettingKey.team, type: AlarmSettingType.main,
                  title: '팀 관리', enabled: allEnabled),
              option(key: AlarmSettingKey.position, type: AlarmSettingType.detail,
                  title: '포지션 변경', description: '내 포지션이 변경되면 알림을 받습니다.',
                  enabled: teamEnabled),
              option(key: AlarmSettingKey.memberChanges, type: AlarmSettingType.detail,
                  title: '멤버 변동 (운영진)', description: '멤버 가입 및 탈퇴 알림을 받습니다.',
                  enabled: teamEnabled),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );
  }
}
