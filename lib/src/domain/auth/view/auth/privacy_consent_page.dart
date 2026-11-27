import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

/// 회원가입 단계에서 확인하는 개인정보 수집 및 이용 안내 전체 화면.
/// 개인정보 수집·이용 안내 v1.1.0 (시행일자 2026년 11월 12일).
class PrivacyConsentPage extends StatelessWidget {
  const PrivacyConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bodyStyle = FontStyles.med12.copyWith(
      color: context.grays.gray1,
      height: 1.8,
      fontSize: 13.0,
    );
    final boldStyle = bodyStyle.copyWith(fontWeight: FontWeight.w700);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x20,
            AppSpacing.x40,
            AppSpacing.x20,
            AppSpacing.x16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '개인정보 수집 · 이용 안내',
                style: FontStyles.bold34.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.x24),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '빗잇(Beat It)은 회원가입, 팀 서비스 제공 및 원활한 서비스 운영에 필요한 최소한의 개인정보를 아래와 같이 수집·이용합니다. 아래 정보는 서비스 이용 계약의 체결 및 이행을 위해 처리합니다(「개인정보 보호법」 제15조제1항제4호).',
                          style: bodyStyle,
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        const _PrivacyTable(),
                        const SizedBox(height: AppSpacing.x16),
                        Text(
                          '※ 닉네임, 프로필 사진, 팀 공간에 공유한 콘텐츠는 같은 팀의 팀원에게 표시됩니다.',
                          style: FontStyles.med11.copyWith(
                            color: context.grays.gray1,
                            height: 1.5,
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        Text('2. 탈퇴 보류(유예) 기간 및 파기', style: boldStyle),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    '1. 회원이 탈퇴를 요청하면, 실수로 인한 계정 및 데이터 유실을 막기 위해 탈퇴 요청일로부터 ',
                              ),
                              TextSpan(
                                text: '7일 동안 개인정보를 분리 보관(탈퇴 보류 상태)',
                                style: boldStyle,
                              ),
                              const TextSpan(
                                text: '하며, 이 기간에는 탈퇴를 철회할 수 있습니다.',
                              ),
                            ],
                          ),
                          style: bodyStyle,
                        ),
                        Text(
                          '2. 7일의 보류 기간이 끝나면 개인정보와 서비스 이용 데이터는 복구할 수 없는 방법으로 즉시 파기됩니다.',
                          style: bodyStyle,
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        Text('3. 처리 위탁 및 국외 이전', style: boldStyle),
                        Text(
                          '서비스 운영을 위해 Amazon Web Services(서버·저장소·이미지 전송), Google Firebase(푸시 알림), Gmail(이메일 발송)에 개인정보 처리를 위탁하며, 이 중 일부는 국외에서 처리됩니다. 수탁자, 이전 국가, 이전 항목 등 자세한 내용은 개인정보 처리방침에서 확인할 수 있습니다.',
                          style: bodyStyle,
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        Text('4. 필수 항목 미제공 시', style: boldStyle),
                        Text(
                          '필수 항목은 서비스 제공에 꼭 필요한 정보로, 제공하지 않으면 빗잇 회원가입 및 팀 서비스 이용이 불가능합니다. 프로필 사진은 등록하지 않아도 서비스를 이용할 수 있습니다.',
                          style: bodyStyle,
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: '자세한 내용은 '),
                              TextSpan(
                                text: '개인정보 처리방침',
                                style: bodyStyle.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: '에서 확인하실 수 있습니다.'),
                            ],
                          ),
                          style: bodyStyle,
                        ),
                        const SizedBox(height: AppSpacing.x16),
                        Text(
                          '시행일자: 2026년 11월 12일 (버전 v1.1.0)',
                          style: boldStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '확인',
                variant: ButtonVariant.black,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _PrivacyItem = ({String collection, String purpose, String retention});

const _privacyItems = <_PrivacyItem>[
  (
    collection:
        '[필수] 소셜 계정 고유 식별자(ID), 이메일 주소, '
        '소셜 로그인 제공자 정보 (구글·네이버·카카오·애플)',
    purpose:
        '회원 가입 및 본인 식별, 소셜 계정 추가 연동, '
        '계정 보호, 주요 고지사항 전달',
    retention: '회원 탈퇴 요청 후 7일의 보류 기간이 지나면 즉시 파기',
  ),
  (
    collection: '[필수] 닉네임 / [선택] 프로필 사진',
    purpose: '서비스 내 프로필 구성 및 소속 팀원 간 식별',
    retention:
        '회원 탈퇴 요청 후 7일의 보류 기간이 지나면 즉시 파기 '
        '(프로필 사진은 삭제 시 즉시 파기)',
  ),
  (
    collection:
        '[서비스 이용 시 생성] 소속 팀 및 팀 내 역할, '
        '회원이 등록·업로드한 일정·이미지·텍스트',
    purpose: '팀 생성·참여, 일정 조율, 콘텐츠 공유',
    retention:
        '회원 탈퇴 요청 후 7일의 보류 기간이 지나면 즉시 파기 '
        '(팀 삭제 시 해당 팀 데이터 즉시 파기)',
  ),
  (
    collection: '[자동 수집] 푸시 알림 토큰',
    purpose: '앱 푸시 알림 발송',
    retention: '회원 탈퇴 요청 후 7일의 보류 기간이 지나면 즉시 파기',
  ),
  (
    collection:
        '[자동 수집] 서비스 이용 기록, 접속 로그(접속 IP 주소, 접속 일시), '
        '기기 정보(OS 종류·버전, 앱 버전, 기기 식별자), 앱 설정 정보',
    purpose:
        '서비스 부정 이용 방지, 오류 확인 (고객 지원) '
        '및 서비스 품질 개선',
    retention: '수집일로부터 6개월 보관 후 파기',
  ),
];

class _PrivacyTable extends StatefulWidget {
  const _PrivacyTable();

  @override
  State<_PrivacyTable> createState() => _PrivacyTableState();
}

class _PrivacyTableState extends State<_PrivacyTable> {
  static const _tableWidth = 420.0;

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = FontStyles.bold14.copyWith(
      color: context.grays.gray1,
      fontSize: 12.0,
    );
    final bodyStyle = FontStyles.bold14.copyWith(
      color: context.grays.gray4,
      height: 1.3,
      fontSize: 12.0,
    );

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: AppSpacing.x8),
        child: Container(
          width: _tableWidth,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x12,
            vertical: AppSpacing.x10,
          ),
          decoration: BoxDecoration(
            color: context.grays.gray8,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            children: [
              _PrivacyTableRow(
                values: const ['수집 항목', '수집 및 이용 목적', '보유 및 이용기간'],
                style: headerStyle,
              ),
              for (final item in _privacyItems) ...[
                const SizedBox(height: AppSpacing.x12),
                _PrivacyTableRow(
                  values: [item.collection, item.purpose, item.retention],
                  style: bodyStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyTableRow extends StatelessWidget {
  const _PrivacyTableRow({required this.values, required this.style});

  final List<String> values;
  final TextStyle style;

  static const _flex = [4, 3, 3];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < values.length; index++) ...[
          Expanded(
            flex: _flex[index],
            child: Text(values[index], style: style),
          ),
          if (index != values.length - 1) const SizedBox(width: AppSpacing.x8),
        ],
      ],
    );
  }
}
