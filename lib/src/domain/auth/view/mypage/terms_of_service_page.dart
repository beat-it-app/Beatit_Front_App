import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

import 'open_source_license_page.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x16),
              Text(
                '서비스 약관',
                style: FontStyles.bold34.copyWith(
                  color: colors.onSurface,
                  letterSpacing: -0.68,
                ),
              ),
              const SizedBox(height: AppSpacing.x24),

              // 1. 서비스 이용약관 동의 아코디언
              const _TermsExpansionTile(
                title: '[필수] 서비스 이용약관 동의',
                initiallyExpanded: true,
                child: _ServiceTermsContent(),
              ),

              const SizedBox(height: AppSpacing.x16),

              // 2. 개인정보 수집 및 이용 동의 아코디언
              const _TermsExpansionTile(
                title: '[필수] 개인정보 수집 및 이용 동의',
                initiallyExpanded: false,
                child: _PrivacyTermsContent(),
              ),

              const SizedBox(height: AppSpacing.x24),

              // 3. 오픈소스 라이선스 (플러터 기본 제공 LicensePage 호출)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OpenSourceLicensePage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x16,
                    vertical: AppSpacing.x16,
                  ),
                  decoration: BoxDecoration(
                    color: context.grays.gray8,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '오픈소스 라이선스',
                        style: FontStyles.semi16.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/auth/back.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          context.grays.gray4,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x30),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsExpansionTile extends StatelessWidget {
  const _TermsExpansionTile({
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: context.grays.gray8,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          backgroundColor: context.grays.gray8,
          collapsedBackgroundColor: context.grays.gray8,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x16,
            vertical: 4,
          ),
          title: Text(
            title,
            style: FontStyles.bold20.copyWith(color: colors.onSurface),
          ),
          iconColor: colors.onSurface,
          collapsedIconColor: colors.onSurface,
          children: [
            Container(
              width: double.infinity,
              color: colors.surface,
              padding: const EdgeInsets.all(AppSpacing.x16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTermsContent extends StatelessWidget {
  const _ServiceTermsContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bodyStyle = FontStyles.reg14.copyWith(
      color: colors.onSurface,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• 제1조 (목적)\n'
          '  본 약관은 Beat It(이하 "빗잇")이 제공하는 모바일 애플리케이션 및 관련 제반 서비스(팀·밴드 관리, 일정 조율, 콘텐츠 공유 등)의 이용과 관련하여, 빗잇과 회원 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.\n\n'
          '• 제2조 (회원가입 및 계정 관리)\n'
          '  a. 이용자는 본 약관에 동의하고 빗잇이 제공하는 소셜 로그인(카카오, 구글, 애플 등) 연동 절차를 완료함으로써 회원가입을 신청합니다.\n'
          '  b. 회원은 마이페이지를 통해 복수의 소셜 계정을 추가로 연동하여 사용할 수 있습니다.\n'
          '  c. 회원은 본인의 소셜 계정 및 로그인 접근 권한을 안전하게 관리할 책임이 있으며, 타인의 정보를 도용하거나 부정한 방법으로 가입한 경우 서비스 이용이 제한될 수 있습니다.\n\n'
          '• 제3조 (팀 운영 및 콘텐츠의 관리)\n'
          '  a. 회원은 서비스 내에서 팀(모임)을 생성하거나 기존 팀에 참여하여 일정, 이미지, 텍스트 등의 콘텐츠를 업로드 및 공유할 수 있습니다.\n'
          '  b. 회원이 빗잇에 업로드한 콘텐츠의 저작권은 해당 회원에게 귀속됩니다. 단, 팀 공간 내에 공유된 데이터는 원활한 팀 운영을 위해 소속 팀원들에게 함께 노출됩니다.\n'
          '  c. 회원은 타인의 지식재산권이나 초상권을 침해하는 콘텐츠를 업로드해서는 안 되며, 이로 인해 발생하는 법적 책임은 회원 본인에게 있습니다.\n'
          '  d. 빗잇은 서비스의 안정적인 운영, 기능 개선 및 홍보에 필요한 범위 내에서 회원의 콘텐츠를 서비스 내에 복제, 수정, 전시할 수 있습니다.\n\n'
          '• 제4조 (팀 삭제, 팀 탈퇴 및 회원 탈퇴)\n'
          '  a. 팀 삭제: 팀장(관리자) 권한을 가진 회원은 팀을 삭제할 수 있으며, 삭제 시 해당 팀의 모든 데이터는 복구할 수 없게 소멸됩니다.\n'
          '  b. 팀 탈퇴 및 회원 탈퇴 유예 기간: 회원은 언제든지 마이페이지를 통해 팀 탈퇴 또는 회원 탈퇴를 요청할 수 있습니다. 단, 실수로 인한 데이터 유실을 방지하기 위해 탈퇴 요청 시점으로부터 7일간의 보류(유예) 기간이 적용되며, 7일이 경과하면 모든 데이터와 혜택이 영구적으로 소멸됩니다.\n\n'
          '• 제5조 (서비스 이용의 제한 및 종료)\n'
          '  회원이 본 약관을 위반하거나 서비스의 정상적인 운영을 방해하는 경우, 빗잇은 사전 통지 후(긴급한 경우 사후 통지) 해당 회원의 계정을 정지하거나 서비스 이용을 제한할 수 있습니다.\n\n'
          '• 시행일자: 2026년 11월 4일 (버전 v1.0.0)',
          style: bodyStyle,
        ),
      ],
    );
  }
}

class _PrivacyTermsContent extends StatelessWidget {
  const _PrivacyTermsContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bodyStyle = FontStyles.reg14.copyWith(
      color: colors.onSurface,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빗잇(Beat It)은 회원가입, 팀 관리 및 원활한 서비스 제공을 위해 아래와 같이 최소한의 개인정보를 수집·이용합니다.\n\n'
          '1. 수집하는 개인정보 항목 및 보유 기간\n'
          '• [필수] 소셜 계정 고유식별자(ID), 이메일 주소, 소셜 로그인 제공자 정보\n'
          '  - 목적: 회원 가입 및 본인 식별, 소셜 계정 추가 연동, 계정 보호, 중요 고지사항 전달\n'
          '  - 보유 기간: 회원 탈퇴 요청 후 7일 보류 기간 경과 시 즉시 파기\n\n'
          '• [필수] 이름(닉네임) / [선택] 프로필 사진\n'
          '  - 목적: 서비스 내 프로필 구성 및 소속 팀원 간 식별\n'
          '  - 보유 기간: 회원 탈퇴 요청 후 7일 보류 기간 경과 시 즉시 파기 (단, 프로필 사진 삭제 시 즉시 파기)\n\n'
          '• [자동 수집] 서비스 이용 기록, 접속 로그, 기기 정보(OS 버전 등), 앱 설정 정보\n'
          '  - 목적: 서비스 부정 이용 방지, 오류 확인(고객 지원) 및 서비스 품질 개선\n'
          '  - 보유 기간: 수집일로부터 6개월 보관 후 파기\n\n'
          '2. 개인정보의 파기 절차 및 유예 정책 안내\n'
          '  a. 회원이 회원 탈퇴를 신청한 경우, 오조작으로 인한 계정 및 데이터 유실을 방지하기 위해 탈퇴 요청일로부터 7일간 개인정보를 분리 보관(탈퇴 보류 상태)합니다.\n'
          '  b. 7일의 보류 기간이 종료되면 수집된 개인정보 및 서비스 이용 데이터는 복구할 수 없는 방법으로 즉시 영구 파기됩니다.\n\n'
          '3. 동의 거부 권리 및 불이익\n'
          '  이용자는 개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있습니다. 단, 필수 항목에 대한 동의를 거부할 경우 빗잇 회원가입 및 팀 서비스 이용이 불가능합니다.\n\n'
          '• 시행일자: 2026년 11월 4일 (버전 v1.0.0)',
          style: bodyStyle,
        ),
      ],
    );
  }
}
