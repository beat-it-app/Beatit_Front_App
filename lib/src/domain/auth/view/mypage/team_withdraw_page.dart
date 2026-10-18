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

import '../../api/withdrawal_api.dart';
import '../../provider/mypage_provider.dart';

class TeamWithdrawPage extends ConsumerStatefulWidget {
  const TeamWithdrawPage({super.key});

  @override
  ConsumerState<TeamWithdrawPage> createState() => _TeamWithdrawPageState();
}

class _TeamWithdrawPageState extends ConsumerState<TeamWithdrawPage> {
  bool _isLoading = true;
  bool _isConfirmed = false;

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
          .getTeamWithdrawalInfo();
      if (mounted) {
        setState(() {
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

  Future<void> _handleWithdraw() async {
    final teamName = ref.read(myPageProvider).data?.team?.name ?? '현재 팀';

    // 💡 AppPopup으로 탈퇴 확인 팝업 호출
    final confirmed = await AppPopup.show(
      context,
      title: "'$teamName' 팀을\n탈퇴하시겠습니까?",
      content: '탈퇴 요청 후 7일의 유예기간 뒤\n완전히 탈퇴 처리됩니다.',
      warningType: WarningType.none,
      contentType: ContentType.small,
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.horizontal,
      confirmText: '확인',
      cancelText: '취소',
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(withdrawalApiProvider).withdrawTeam();

      // 마이페이지 갱신
      ref.read(myPageProvider.notifier).fetchMyPage();

      if (!mounted) return;

      // 💡 AppPopup으로 완료 안내 팝업
      await AppPopup.show(
        context,
        title: '팀 탈퇴 요청 완료',
        content: '팀 탈퇴 요청이 정상 접수되었습니다.\n7일의 유예기간 후 완전히 탈퇴됩니다.',
        warningType: WarningType.none,
        contentType: ContentType.small,
        buttonNum: ButtonNum.one,
        confirmText: '확인',
      );

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
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
    final team = ref.watch(myPageProvider).data?.team;
    final teamName = team?.name ?? '팀';

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
                    const SizedBox(height: AppSpacing.x16),
                    RichText(
                      text: TextSpan(
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          height: 1.25,
                        ),
                        children: [
                          TextSpan(text: "'$teamName'를\n"),
                          TextSpan(
                            text: '탈퇴',
                            style: TextStyle(color: context.colors.primary),
                          ),
                          const TextSpan(text: '하실건가요?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x12),
                    Text(
                      '밴드를 탈퇴하면 해당 팀 페이지 게시글, 채팅 등 모든 활동 정보가 삭제되며, 사용 불가합니다.',
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.gray4,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x24),

                    // 안내 카드 1: 팀 누적 데이터
                    _InfoCard(
                      icon: Icons.bar_chart_rounded,
                      title: '팀 누적 데이터를 사용할 수 없어요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray3,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: '내가 업로드한 파일 '),
                            TextSpan(
                              text: '$_fileCount개',
                              style: TextStyle(
                                color: context.colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ', 공유한 악보·음원 '),
                            TextSpan(
                              text: '$_sharedMusicCount개',
                              style: TextStyle(
                                color: context.colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ', 함께한 일정 '),
                            TextSpan(
                              text: '$_scheduleCount회',
                              style: TextStyle(
                                color: context.colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' 모두 조회할 수 없어요.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x12),

                    // 안내 카드 2: 기능 접근
                    _InfoCard(
                      icon: Icons.pan_tool_outlined,
                      title: '팀 기능에 접근할 수 없어요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray3,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: '팀 일정 및 캘린더 접근, 팀 클라우드 파일 다운로드가 ',
                            ),
                            TextSpan(
                              text: '불가능',
                              style: TextStyle(
                                color: context.colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: '해요.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x12),

                    // 안내 카드 3: 작성 권한
                    _InfoCard(
                      icon: Icons.edit_outlined,
                      title: '팀 작성 권한이 중단 돼요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray3,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: '합주실/연습실 후기 열람 및 작성 혜택이 중단돼요. ',
                            ),
                            TextSpan(
                              text: '작성한 게시글과 파일은 자동 삭제 되지 않으며 탈퇴 후 수정이 불가능해요.',
                              style: TextStyle(
                                color: context.colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x30),

                    // 유의사항 확인 체크박스
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
                            Icon(
                              Icons.check,
                              size: 20,
                              color: _isConfirmed
                                  ? context.colors.primary
                                  : context.grays.gray6,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '유의사항을 모두 확인했습니다.',
                              style: FontStyles.bold14.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x24),

                    // 탈퇴하기 버튼
                    AppButton(
                      text: '탈퇴하기',
                      variant: ButtonVariant.black,
                      width: ButtonWidth.expand,
                      height: ButtonHeight.normal,
                      onPressed: _isConfirmed ? _handleWithdraw : null,
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
  final IconData icon;
  final String title;
  final Widget descriptionWidget;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.descriptionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: context.grays.gray2),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontStyles.bold20.copyWith(
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
