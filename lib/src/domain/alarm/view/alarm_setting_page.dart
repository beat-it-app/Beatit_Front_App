import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/setting_switch_section.dart';
import 'package:flutter/material.dart';

// 알림 설정 API가 아직 없으므로 이 페이지 안에서만 상태를 관리한다.
// 상위 설정이 꺼져도 세부 설정의 원래 선택값은 유지한다.
enum _SettingKey {
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

class AlarmSettingPage extends StatefulWidget {
  const AlarmSettingPage({super.key});

  @override
  State<AlarmSettingPage> createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  final Map<_SettingKey, bool> _values = {
    _SettingKey.all: true,
    _SettingKey.activity: true,
    _SettingKey.calendar: false,
    _SettingKey.activityNews: false,
    _SettingKey.activityComments: false,
    _SettingKey.collaboration: true,
    _SettingKey.notice: true,
    _SettingKey.pollMeetit: true,
    _SettingKey.results: true,
    _SettingKey.collaborationComments: true,
    _SettingKey.chatPush: true,
    _SettingKey.team: false,
    _SettingKey.position: false,
    _SettingKey.memberChanges: false,
  };

  bool _value(_SettingKey key) => _values[key] ?? false;

  void _setValue(_SettingKey key, bool next) {
    setState(() => _values[key] = next);
  }

  /// 개별 스위치를 끄는 대신 입력만 막아 값을 보존한다.
  SettingSwtichSection _option({
    required _SettingKey key,
    required AlarmSettingType type,
    required String title,
    String? description,
    bool enabled = true,
  }) => SettingSwtichSection(
    type: type,
    title: title,
    description: description,
    value: _value(key),
    enabled: enabled,
    onChanged: (value) => _setValue(key, value),
  );

  @override
  Widget build(BuildContext context) {
    final allEnabled = _value(_SettingKey.all);
    final activityEnabled = allEnabled && _value(_SettingKey.activity);
    final collaborationEnabled = allEnabled && _value(_SettingKey.collaboration);
    final teamEnabled = allEnabled && _value(_SettingKey.team);

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
              _option(
                key: _SettingKey.all,
                type: AlarmSettingType.main,
                title: '전체 알림',
              ),
              Divider(color: context.grays.gray7),
              _option(
                key: _SettingKey.activity,
                type: AlarmSettingType.main,
                title: '일정 및 활동',
                enabled: allEnabled,
              ),
              Column(
                spacing: AppSpacing.x10,
                children: [
                  _option(
                    key: _SettingKey.calendar,
                    type: AlarmSettingType.detail,
                    title: '캘린더 일정',
                    description: '새 일정 등록 및 일정 하루 전(D-1) 리마인드 알림을 받습니다.',
                    enabled: activityEnabled,
                  ),
                  _option(
                    key: _SettingKey.activityNews,
                    type: AlarmSettingType.detail,
                    title: '팀 활동 및 공간 소식',
                    enabled: activityEnabled,
                  ),
                  _option(
                    key: _SettingKey.activityComments,
                    type: AlarmSettingType.detail,
                    title: '댓글 및 멘션',
                    enabled: activityEnabled,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x8),
              Divider(color: context.grays.gray7),
              _option(
                key: _SettingKey.collaboration,
                type: AlarmSettingType.main,
                title: '공지 및 협업',
                enabled: allEnabled,
              ),
              Column(
                spacing: AppSpacing.x10,
                children: [
                  _option(
                    key: _SettingKey.notice,
                    type: AlarmSettingType.detail,
                    title: '공지사항',
                    enabled: collaborationEnabled,
                  ),
                  _option(
                    key: _SettingKey.pollMeetit,
                    type: AlarmSettingType.detail,
                    title: '투표 / 밋잇',
                    enabled: collaborationEnabled,
                  ),
                  _option(
                    key: _SettingKey.results,
                    type: AlarmSettingType.detail,
                    title: '진행 결과',
                    description: '내가 등록한 투표 및 밋잇의 전원 참여 완료 알림을 받습니다.',
                    enabled: collaborationEnabled,
                  ),
                  _option(
                    key: _SettingKey.collaborationComments,
                    type: AlarmSettingType.detail,
                    title: '댓글 및 멘션',
                    enabled: collaborationEnabled,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x8),
              Divider(color: context.grays.gray7),
              const SettingSwtichSection(
                type: AlarmSettingType.main,
                title: '채팅',
              ),
              _option(
                key: _SettingKey.chatPush,
                type: AlarmSettingType.detail,
                title: '채팅방 푸시 알림',
              ),
              const SizedBox(height: AppSpacing.x8),
              Divider(color: context.grays.gray7),
              _option(
                key: _SettingKey.team,
                type: AlarmSettingType.main,
                title: '팀 관리',
                enabled: allEnabled,
              ),
              _option(
                key: _SettingKey.position,
                type: AlarmSettingType.detail,
                title: '포지션 변경',
                description: '내 포지션이 변경되면 알림을 받습니다.',
                enabled: teamEnabled,
              ),
              _option(
                key: _SettingKey.memberChanges,
                type: AlarmSettingType.detail,
                title: '멤버 변동 (운영진)',
                description: '멤버 가입 및 탈퇴 알림을 받습니다.',
                enabled: teamEnabled,
              ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );
  }
}
