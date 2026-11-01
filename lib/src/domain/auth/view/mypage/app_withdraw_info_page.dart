import 'package:beatit_front_app/src/domain/alarm/view/alarm_setting_page.dart';
import 'package:beatit_front_app/src/domain/auth/provider/mypage_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';

import '../../api/withdrawal_api.dart';
import 'team_withdraw_page.dart';

class AppWithdrawInfoPage extends ConsumerStatefulWidget {
  final String withdrawalReason;
  final String detailReason;

  const AppWithdrawInfoPage({
    super.key,
    required this.withdrawalReason,
    required this.detailReason,
  });

  @override
  ConsumerState<AppWithdrawInfoPage> createState() =>
      _AppWithdrawInfoPageState();
}

class _AppWithdrawInfoPageState extends ConsumerState<AppWithdrawInfoPage> {
  bool _isLoading = true;
  bool _isConfirmed = false;

  int _teamCount = 0;
  int _fileCount = 0;
  int _sharedMusicCount = 0;
  int _scheduleCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  Future<void> _fetchInfo() async {
    try {
      final info = await ref
          .read(withdrawalApiProvider)
          .getAuthWithdrawalInfo();
      if (mounted) {
        setState(() {
          _teamCount = (info['teamCount'] as num?)?.toInt() ?? 0;
          _fileCount = (info['fileCount'] as num?)?.toInt() ?? 0;
          _sharedMusicCount = (info['sharedMusicCount'] as num?)?.toInt() ?? 0;
          _scheduleCount = (info['scheduleCount'] as num?)?.toInt() ?? 0;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleFinalWithdraw() async {
    // 1. 유의사항 미동의 시 팝업 노출
    if (!_isConfirmed) {
      await AppPopup.show(
        context,
        title: '유의 사항을 확인해 주세요.',
        content: '탈퇴 희망 시, 유의 사항 확인에\n동의해 주세요.',
        warningType: WarningType.circle,
        warningColor: context.grays.gray7,
        contentType: ContentType.small,
        buttonNum: ButtonNum.one,
        confirmText: '확인',
      );
      return;
    }

    // 2. 최종 탈퇴 확정 팝업
    final confirmed = await AppPopup.show(
      context,
      title: '정말 탈퇴하시겠습니까?',
      content: '탈퇴 시 계정 복구가 불가능하며\n모든 데이터 접근이 제한됩니다.',
      warningType: WarningType.triangle,
      contentType: ContentType.small,
      buttonNum: ButtonNum.two,
      confirmText: '탈퇴 확정',
      cancelText: '취소',
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(withdrawalApiProvider)
          .withdrawAuth(
            withdrawalReason: widget.withdrawalReason,
            detailReason: widget.detailReason,
          );

      if (!mounted) return;

      // 💡 로그아웃 처리 후 로그인 화면(SigninPage)으로 스택 비우며 이동
      await ref.read(authProvider.notifier).logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SigninPage()),
        (route) => false,
      );
    } on WithdrawalApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.x20),
                    RichText(
                      text: TextSpan(
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          height: 1.25,
                        ),
                        children: [
                          const TextSpan(text: '빗잇 서비스를 정말\n'),
                          TextSpan(
                            text: '탈퇴',
                            style: TextStyle(color: context.colors.primary),
                          ),
                          const TextSpan(text: '하실건가요?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x10),
                    Text(
                      '탈퇴 시, 안내 사항을 모두 확인하였으며, 데이터 복구 불가 및 팀 내 활동 기록 처리에 동의합니다.',
                      style: FontStyles.semi16.copyWith(
                        color: context.grays.gray5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x24),

                    // 안내 1
                    _InfoCard(
                      svgPath: 'assets/icons/auth/data.svg',
                      title: '팀 누적 데이터를 사용할 수 없어요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray3,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: '참여중인 팀 '),
                            TextSpan(
                              text: '$_teamCount개',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: ', 내가 업로드한 파일 '),
                            TextSpan(
                              text: '$_fileCount개',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: ', 공유한 악보·음원 '),
                            TextSpan(
                              text: '$_sharedMusicCount회',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: ', 함께한 일정 '),
                            TextSpan(
                              text: '$_scheduleCount회',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: ' 모두 조회할 수 없어요.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x12),

                    // 안내 2
                    _InfoCard(
                      svgPath: 'assets/icons/auth/donot_touch.svg',
                      title: '팀 기능에 접근할 수 없어요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray3,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: '팀 일정 및 캘린더 접근, 팀 클라우드 파일 다운로드가 ',
                            ),
                            TextSpan(
                              text: '불가능',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: '해요.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x12),

                    // 안내 3
                    _InfoCard(
                      svgPath: 'assets/icons/auth/pencil_prohibit.svg',
                      title: '팀 작성 권한이 중단 돼요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray3,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: '합주실/연습실 후기 열람 및 작성 혜택이 중단돼요. ',
                            ),
                            TextSpan(
                              text: '작성한 게시글과 파일은 자동 삭제 되지 않으며 탈퇴 후 수정이 불가능해요.',
                              style: TextStyle(color: context.colors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x40),

                    // 이렇게도 가능해요 섹션
                    Text(
                      '이렇게도 가능해요!',
                      style: FontStyles.bold34.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '탈퇴 전에 먼저 확인해 보세요.',
                      style: FontStyles.med16.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x20),

                    // 대안 1: 푸시 알림 설정
                    _AlternativeActionCard(
                      svgPath: 'assets/icons/auth/alarm.svg',
                      title: '알림이 부담스러우신가요?',
                      subtitle: '푸시 알림 설정으로 세부 알림을 조절할 수 있어요.',
                      buttonText: '푸시 알림 설정',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AlarmSettingPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.x12),

                    // 대안 2: 팀 탈퇴 바로가기
                    _AlternativeActionCard(
                      svgPath: 'assets/icons/auth/alarm.svg',
                      title: '활동하지 않는 팀이 있나요?',
                      subtitle: '서비스 탈퇴 대신 해당 팀에서만 나갈 수 있어요.',
                      buttonText: '팀 탈퇴 바로가기',
                      onTap: () {
                        final currentTeam = ref.read(myPageProvider).data?.team;
                        if (currentTeam == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('현재 참여 중인 팀이 없습니다.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TeamWithdrawPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.x24),

                    // 유의사항 확인 체크
                    GestureDetector(
                      onTap: () => setState(() => _isConfirmed = !_isConfirmed),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: context.grays.gray8,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/check/check.svg',
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                _isConfirmed
                                    ? context.colors.primary
                                    : context.grays.gray6,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '유의사항을 모두 확인했습니다.',
                              style: FontStyles.semi16.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x20),

                    // 계속 이용할게요 버튼
                    AppButton(
                      text: '계속 이용할게요',
                      variant: ButtonVariant.black,
                      width: ButtonWidth.expand,
                      height: ButtonHeight.normal,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: AppSpacing.x16),

                    // 그래도 탈퇴하기 링크 버튼
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _handleFinalWithdraw,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '그래도 탈퇴하기',
                            style: FontStyles.med14.copyWith(
                              color: context.grays.gray3,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x24),
                  ],
                ),
              ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String svgPath;
  final String title;
  final Widget descriptionWidget;

  const _InfoCard({
    required this.svgPath,
    required this.title,
    required this.descriptionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x20),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(svgPath, width: 36, height: 36),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontStyles.bold18.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                descriptionWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlternativeActionCard extends StatelessWidget {
  final String svgPath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;

  const _AlternativeActionCard({
    required this.svgPath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.grays.gray7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(svgPath, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: FontStyles.bold18.copyWith(color: colors.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              subtitle,
              style: FontStyles.med14.copyWith(color: context.grays.gray4),
            ),
          ),
          const SizedBox(height: AppSpacing.x20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(42),
              side: BorderSide(color: context.grays.gray7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: onTap,
            child: Text(
              buttonText,
              style: FontStyles.semi14.copyWith(color: context.grays.gray1),
            ),
          ),
        ],
      ),
    );
  }
}
