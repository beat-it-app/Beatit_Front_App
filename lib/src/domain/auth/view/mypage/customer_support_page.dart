import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({super.key});

  static const String _supportEmail = 'onbeat.it@gmail.com';
  static const String _channelUrl = 'http://pf.kakao.com/_GvLxeX';

  // 1:1 문의 카카오톡 채널 열기
  Future<void> _handleChannelTap(BuildContext context) async {
    final uri = Uri.parse(_channelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('1:1 문의 채널을 열 수 없습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 이메일 복사 및 토스트 띄우기
  Future<void> _handleEmailCopy(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _supportEmail));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('문의 이메일이 클립보드에 복사되었습니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
                '고객 지원',
                style: FontStyles.bold34.copyWith(
                  color: colors.onSurface,
                  letterSpacing: -0.68,
                ),
              ),
              const SizedBox(height: AppSpacing.x24),

              // 1. 운영 시간 안내 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.x20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.grays.gray7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문의 시 가입하신 계정 이메일과 휴대폰 기종/OS 버전을 함께 적어주시면 더욱 정확한 확인이 가능합니다.',
                      style: FontStyles.reg14.copyWith(
                        color: colors.onSurface,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x16),
                    Divider(color: context.grays.gray7, height: 1),
                    const SizedBox(height: AppSpacing.x16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '운영 시간',
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray4,
                          ),
                        ),
                        Text(
                          '평일 10:00 - 18:00',
                          style: FontStyles.reg14.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '휴무',
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray4,
                          ),
                        ),
                        Text(
                          '주말 · 공휴일',
                          style: FontStyles.reg14.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              // 2. 1:1 문의 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.x20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.grays.gray7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '1:1 문의',
                          style: FontStyles.bold17.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Beat It 카카오톡 채널로 이동합니다.',
                            style: FontStyles.reg12.copyWith(
                              color: context.grays.gray4,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        onPressed: () => _handleChannelTap(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '채널 바로가기',
                              style: FontStyles.semi14.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            SvgPicture.asset(
                              'assets/icons/auth/link-outside.svg',
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              // 3. 이메일 문의 카드 (흰색 배경 + 테두리 이메일 영역 & 복사 버튼 연결)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.x20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.grays.gray7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이메일 문의',
                      style: FontStyles.bold17.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x16),
                    Row(
                      children: [
                        // 이메일 텍스트 박스 (흰색 배경 + 테두리, 왼쪽 라운딩)
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.x16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(AppRadius.sm),
                              ),
                              border: Border.all(
                                color: context.grays.gray7,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _supportEmail,
                              style: FontStyles.med17.copyWith(
                                color: context.grays.gray1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        // 복사 버튼 (이메일 영역과 동일한 높이 48, 4꼭짓점 전체 라운딩)
                        SizedBox(
                          height: 48,
                          width: 80,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.grays.gray1,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => _handleEmailCopy(context),
                            child: Text(
                              '복사',
                              style: FontStyles.semi14.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
