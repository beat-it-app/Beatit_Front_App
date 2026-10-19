import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';

import '../../api/withdrawal_api.dart';
import '../../provider/mypage_provider.dart';

class TeamDeletePage extends ConsumerStatefulWidget {
  final String teamName;

  const TeamDeletePage({super.key, required this.teamName});

  @override
  ConsumerState<TeamDeletePage> createState() => _TeamDeletePageState();
}

class _TeamDeletePageState extends ConsumerState<TeamDeletePage> {
  bool _isLoading = true;
  bool _isConfirmed = false;

  int _fileCount = 26;
  int _sharedMusicCount = 57;
  int _scheduleCount = 21;

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
          _fileCount = (info['fileCount'] as num?)?.toInt() ?? 26;
          _sharedMusicCount = (info['sharedMusicCount'] as num?)?.toInt() ?? 57;
          _scheduleCount = (info['scheduleCount'] as num?)?.toInt() ?? 21;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDeleteTeam() async {
    final confirmed = await AppPopup.show(
      context,
      title: "정말 '${widget.teamName}'를\n삭제하시겠습니까?",
      content: '삭제 시, 해당 팀 활동 데이터를\n영구적으로 사용하실 수 없습니다.',
      warningType: WarningType.circle,
      warningColor: context.colors.primary,
      contentType: ContentType.small,
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.horizontal,
      confirmText: '확인',
      cancelText: '취소',
    );

    if (confirmed != true || !mounted) return;

    // 💡 teamId 대신 teamPublicId를 추출
    final teamPublicId =
        ref.read(myPageProvider).data?.team?.teamPublicId ?? '';

    if (teamPublicId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('팀 식별 정보를 찾을 수 없습니다.')));
      return;
    }

    try {
      // DELETE /teams/{teamPublicId} 로 호출
      await ref.read(withdrawalApiProvider).deleteTeam();

      // 마이페이지 최신 상태 갱신
      ref.read(myPageProvider.notifier).fetchMyPage();

      if (!mounted) return;

      // 마이페이지 메인으로 복귀
      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('팀이 성공적으로 삭제되었습니다.')));
    } on WithdrawalApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
                          TextSpan(text: "'${widget.teamName}'를\n"),
                          TextSpan(
                            text: '삭제',
                            style: TextStyle(color: context.colors.primary),
                          ),
                          const TextSpan(text: '하실건가요?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x10),
                    Text(
                      '해당 팀 페이지 게시글, 채팅 등 모든 활동 정보가 삭제되며, 모든 팀원의 팀 페이지 사용이 불가합니다.',
                      style: FontStyles.med16.copyWith(
                        color: context.grays.gray5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x30),

                    // 안내 1: 팀 누적 데이터
                    _InfoCard(
                      svgPath: 'assets/icons/auth/data.svg',
                      title: '팀 누적 데이터를 사용할 수 없어요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray4,
                            height: 1.45,
                          ),
                          children: [
                            const TextSpan(text: '우리 팀이 업로드한 파일 '),
                            TextSpan(
                              text: '$_fileCount개',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: ', 공유한 악보·음원 '),
                            TextSpan(
                              text: '$_sharedMusicCount개',
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

                    // 안내 2: 팀 기능 접근 불가
                    _InfoCard(
                      svgPath: 'assets/icons/auth/donot_touch.svg',
                      title: '팀 기능에 접근할 수 없어요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray4,
                            height: 1.45,
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

                    // 안내 3: 권한 중단
                    _InfoCard(
                      svgPath: 'assets/icons/auth/pencil_prohibit.svg',
                      title: '팀 관리 및 작성 권한이 중단 돼요.',
                      descriptionWidget: RichText(
                        text: TextSpan(
                          style: FontStyles.med14.copyWith(
                            color: context.grays.gray4,
                            height: 1.45,
                          ),
                          children: [
                            const TextSpan(
                              text: '합주실/연습실 후기 열람 및 작성 혜택이 중단돼요. ',
                            ),
                            const TextSpan(text: '팀 페이지 관련 모든 권한이 사라져요.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x30),

                    // 유의사항 확인 체크박스
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
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
                    const SizedBox(height: AppSpacing.x30),

                    // 삭제하기 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isConfirmed
                              ? context.grays.gray8
                              : context.grays.gray8.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isConfirmed ? _handleDeleteTeam : null,
                        child: Text(
                          '삭제하기',
                          style: FontStyles.med16.copyWith(
                            color: _isConfirmed
                                ? context.grays.gray4
                                : context.grays.gray5,
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
