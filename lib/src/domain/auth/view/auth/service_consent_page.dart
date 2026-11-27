import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

/// 회원가입 단계에서 확인하는 서비스 이용약관 전체 화면.
/// 동의 버튼은 true를, 뒤로가기는 null을 이전 화면에 반환한다.
class ServiceConsentPage extends StatelessWidget {
  const ServiceConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              RichText(
                text: TextSpan(
                  style: FontStyles.bold34.copyWith(color: colors.onSurface),
                  children: [
                    const TextSpan(text: '서비스 이용약관 '),
                    TextSpan(
                      text: '(필수)',
                      style: FontStyles.bold34.copyWith(color: colors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x24),
              const Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(child: _ServiceTermsContent()),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '동의하기',
                variant: ButtonVariant.primary,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 서비스 이용약관 v1.1.0 (시행일자 2026년 11월 12일).
/// 조항(제목, 본문, 항목 목록)을 데이터로 두고 아래 위젯이 그린다.
typedef _Article = ({String title, String? body, List<String> items});

const _articles = <_Article>[
  (
    title: '제1조 (목적)',
    body:
        '본 약관은 Beat Labs(이하 "운영자")가 제공하는 Beat It(이하 "빗잇") 모바일 애플리케이션 및 관련 제반 서비스(팀·밴드 관리, 일정 조율, 콘텐츠 공유 등, 이하 "서비스")의 이용과 관련하여, 운영자와 회원 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.',
    items: [],
  ),
  (
    title: '제2조 (약관의 효력 및 변경)',
    body: null,
    items: [
      '본 약관은 서비스 화면에 게시하거나 기타의 방법으로 회원에게 알림으로써 효력이 발생합니다.',
      '운영자는 관련 법령을 위반하지 않는 범위에서 본 약관을 변경할 수 있으며, 약관을 변경하는 경우 시행일 7일 전부터(회원에게 불리한 변경은 30일 전부터) 변경 내용과 시행일을 앱 공지사항 등을 통해 안내합니다.',
      '회원이 변경된 약관에 동의하지 않는 경우 회원 탈퇴를 할 수 있으며, 시행일 이후에도 서비스를 계속 이용하는 경우 변경된 약관에 동의한 것으로 봅니다.',
    ],
  ),
  (
    title: '제3조 (회원가입 및 계정 관리)',
    body: null,
    items: [
      '이용자는 본 약관에 동의하고 빗잇이 제공하는 소셜 로그인(구글, 네이버, 카카오, 애플) 연동 절차를 완료함으로써 회원가입을 신청합니다.',
      '만 14세 미만은 회원으로 가입할 수 없습니다.',
      '회원은 마이페이지를 통해 복수의 소셜 계정을 추가로 연동하여 사용할 수 있습니다.',
      '회원은 본인의 소셜 계정 및 로그인 접근 권한을 안전하게 관리할 책임이 있으며, 타인의 정보를 도용하거나 부정한 방법으로 가입한 경우 서비스 이용이 제한될 수 있습니다.',
    ],
  ),
  (
    title: '제4조 (개인정보 보호)',
    body:
        '운영자는 「개인정보 보호법」 등 관계 법령에 따라 회원의 개인정보를 보호하며, 개인정보의 처리에 관한 사항은 별도로 게시하는 개인정보 처리방침에 따릅니다.',
    items: [],
  ),
  (
    title: '제5조 (서비스의 제공 및 변경·중단)',
    body: null,
    items: [
      '운영자는 회원에게 팀(모임) 생성·참여, 일정 조율, 콘텐츠 공유 등의 서비스를 제공합니다.',
      '운영자는 서비스 개선을 위해 서비스의 내용을 변경할 수 있으며, 중요한 변경이 있는 경우 사전에 앱 공지사항 등을 통해 안내합니다.',
      '운영자는 설비 점검·교체, 장애, 천재지변 등 부득이한 사유가 있는 경우 서비스 제공을 일시적으로 중단할 수 있으며, 이 경우 사전에(부득이한 경우 사후에) 안내합니다.',
      '운영자가 서비스를 종료하려는 경우 종료일 30일 전까지 앱 공지사항 등을 통해 안내합니다.',
    ],
  ),
  (
    title: '제6조 (팀 운영 및 콘텐츠의 관리)',
    body: null,
    items: [
      '회원은 서비스 내에서 팀(모임)을 생성하거나 기존 팀에 참여하여 일정, 이미지, 텍스트 등의 콘텐츠를 업로드 및 공유할 수 있습니다.',
      '회원이 빗잇에 업로드한 콘텐츠의 저작권은 해당 회원에게 귀속됩니다. 단, 팀 공간 내에 공유된 콘텐츠는 원활한 팀 운영을 위해 소속 팀원들에게 함께 표시됩니다.',
      '회원은 타인의 지식재산권이나 초상권, 개인정보를 침해하는 콘텐츠를 업로드해서는 안 되며, 이로 인해 발생하는 법적 책임은 회원 본인에게 있습니다.',
      '운영자는 회원의 콘텐츠를 서비스 제공(저장, 전송, 팀 내 표시 및 화면 크기에 맞춘 변환 등)에 필요한 범위에서만 이용하며, 그 외의 목적으로 이용하려는 경우 회원의 별도 동의를 받습니다. 이 권한은 회원이 해당 콘텐츠를 삭제하거나 회원 탈퇴가 완료되면 종료됩니다.',
    ],
  ),
  (
    title: '제7조 (회원의 의무)',
    body: '회원은 다음 행위를 하여서는 안 됩니다.',
    items: [
      '타인의 정보를 도용하거나 허위 정보를 등록하는 행위',
      '다른 회원을 괴롭히거나 불쾌감을 주는 행위, 음란·폭력적인 콘텐츠를 게시하는 행위',
      '서비스를 이용하여 법령에 위반되는 행위를 하거나 이를 돕는 행위',
      '서비스의 운영을 방해하거나 시스템에 비정상적으로 접근하는 행위',
    ],
  ),
  (
    title: '제8조 (팀 삭제, 팀 탈퇴 및 회원 탈퇴)',
    body: null,
    items: [
      '팀 삭제: 팀장(관리자) 권한을 가진 회원은 팀을 삭제할 수 있으며, 삭제 시 해당 팀의 모든 데이터는 복구할 수 없게 소멸됩니다.',
      '팀 탈퇴 및 회원 탈퇴 유예 기간: 회원은 언제든지 마이페이지를 통해 팀 탈퇴 또는 회원 탈퇴를 요청할 수 있습니다. 단, 실수로 인한 데이터 유실을 방지하기 위해 탈퇴 요청 시점으로부터 7일간의 보류(유예) 기간이 적용되며, 이 기간에는 탈퇴를 철회할 수 있습니다. 7일이 경과하면 모든 데이터와 혜택이 영구적으로 소멸됩니다.',
    ],
  ),
  (
    title: '제9조 (서비스 이용의 제한)',
    body:
        '회원이 본 약관을 위반하거나 서비스의 정상적인 운영을 방해하는 경우, 운영자는 사전 통지 후(긴급한 경우 사후 통지) 해당 회원의 계정을 정지하거나 서비스 이용을 제한할 수 있습니다. 회원은 이에 대해 onbeat.it@gmail.com으로 이의를 제기할 수 있습니다.',
    items: [],
  ),
  (
    title: '제10조 (책임의 제한)',
    body: null,
    items: [
      '운영자는 천재지변, 회원의 귀책사유, 제3자(소셜 로그인 제공자, 통신사 등)의 서비스 장애 등 운영자의 고의 또는 과실 없이 발생한 손해에 대하여 책임을 지지 않습니다.',
      '운영자는 회원이 게시한 콘텐츠의 내용과 회원 간에 발생한 분쟁에 대하여 운영자의 고의 또는 과실이 없는 한 책임을 지지 않습니다.',
    ],
  ),
  (
    title: '제11조 (준거법 및 분쟁 해결)',
    body:
        '본 약관과 서비스 이용에 관한 분쟁은 대한민국 법령에 따르며, 분쟁이 발생한 경우 「민사소송법」에 따른 관할 법원에서 해결합니다.',
    items: [],
  ),
  (
    title: '제12조 (문의처)',
    body: '서비스 이용에 관한 문의는 onbeat.it@gmail.com으로 하실 수 있습니다.',
    items: [],
  ),
];

class _ServiceTermsContent extends StatelessWidget {
  const _ServiceTermsContent();

  @override
  Widget build(BuildContext context) {
    final textStyle = FontStyles.med12.copyWith(
      color: context.grays.gray1,
      height: 1.8,
      fontSize: 13.0,
    );
    final titleStyle = textStyle.copyWith(fontWeight: FontWeight.w700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final article in _articles) ...[
          Text(article.title, style: titleStyle),
          if (article.body != null) Text(article.body!, style: textStyle),
          for (var i = 0; i < article.items.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSpacing.x20,
                  child: Text('${i + 1}.', style: textStyle),
                ),
                Expanded(child: Text(article.items[i], style: textStyle)),
              ],
            ),
          const SizedBox(height: AppSpacing.x16),
        ],
        Text('시행일자: 2026년 11월 12일 (버전 v1.1.0)', style: textStyle),
      ],
    );
  }
}
