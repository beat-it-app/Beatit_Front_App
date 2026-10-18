// lib/src/domain/mypage/view/withdrawal/app_withdraw_reason_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';

import '../../api/withdrawal_api.dart';
import '../../provider/mypage_provider.dart';

class AppWithdrawReasonPage extends ConsumerStatefulWidget {
  const AppWithdrawReasonPage({super.key});

  @override
  ConsumerState<AppWithdrawReasonPage> createState() =>
      _AppWithdrawReasonPageState();
}

class _AppWithdrawReasonPageState extends ConsumerState<AppWithdrawReasonPage> {
  bool _isNoticed = false;
  String? _selectedReasonEnum;
  final TextEditingController _detailReasonController = TextEditingController();

  final List<Map<String, String>> _reasons = [
    {'enum': 'LOW_USAGE_FREQUENCY', 'label': '자주 이용하지 않아요'},
    {'enum': 'INSUFFICIENT_FEATURES', 'label': '이용할 만한 기능이 부족해요'},
    {'enum': 'ALTERNATIVE_SERVICE', 'label': '다른 유사 서비스를 이용하고 있어요'},
    {'enum': 'SERVICE_UNSATISFACTION', 'label': '서비스가 불만족스러워요'},
    {'enum': 'OTHER', 'label': '기타'},
  ];

  @override
  void dispose() {
    _detailReasonController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (!_isNoticed || _selectedReasonEnum == null) return false;
    if (_selectedReasonEnum == 'OTHER') {
      return _detailReasonController.text.trim().isNotEmpty;
    }
    return true;
  }

  // 💡 탈퇴하기 버튼 클릭 시: AppPopup으로 비밀번호 입력창 띄우기
  Future<void> _handleWithdrawSubmit() async {
    final passwordController = TextEditingController();

    final confirmed = await AppPopup.show(
      context,
      title: '비밀번호 확인',
      warningType: WarningType.none,
      contentType: ContentType.large,
      buttonNum: ButtonNum.two,
      confirmText: '탈퇴 확정',
      cancelText: '취소',
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '본인 확인을 위해 현재 비밀번호를 입력해주세요.',
            style: FontStyles.reg14.copyWith(color: context.grays.gray4),
          ),
          const SizedBox(height: AppSpacing.x16),
          TextField(
            controller: passwordController,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '비밀번호',
              hintStyle: FontStyles.reg14.copyWith(color: context.grays.gray5),
              filled: true,
              fillColor: context.grays.gray8,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x8),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final password = passwordController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호를 입력해주세요.')));
      return;
    }

    try {
      final detailReason = _selectedReasonEnum == 'OTHER'
          ? _detailReasonController.text.trim()
          : (_reasons.firstWhere(
                  (r) => r['enum'] == _selectedReasonEnum,
                )['label'] ??
                '');

      await ref
          .read(withdrawalApiProvider)
          .withdrawAuth(
            withdrawalReason: _selectedReasonEnum!,
            detailReason: detailReason,
            password: password,
          );

      if (!mounted) return;

      // 💡 완료 안내 팝업
      await AppPopup.show(
        context,
        title: '회원 탈퇴 요청 완료',
        content: '탈퇴 요청이 정상 접수되었습니다.\n7일 후 계정 및 데이터가 완전히 삭제됩니다.',
        warningType: WarningType.none,
        contentType: ContentType.small,
        buttonNum: ButtonNum.one,
        confirmText: '확인',
      );

      // 토큰 삭제 및 로그인/스플래시 화면으로 리셋
      if (mounted) {
        ref.read(authProvider.notifier).logout();
      }
    } on WithdrawalApiException catch (e) {
      if (!mounted) return;
      // 비밀번호 불일치 (LOGIN-002) 안내 팝업
      if (e.code == 'LOGIN-002') {
        await AppPopup.show(
          context,
          title: '비밀번호 불일치',
          content: '입력하신 비밀번호가 일치하지 않습니다.\n다시 확인해주세요.',
          warningType: WarningType.circle,
          contentType: ContentType.small,
          buttonNum: ButtonNum.one,
          confirmText: '확인',
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
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
    final userName = ref.watch(myPageProvider).data?.userName ?? '회원';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.x16),
                      Text(
                        '정말 빗잇을\n탈퇴하실건가요?',
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x12),
                      Text(
                        '계정을 삭제하면 팀 페이지 게시글, 채팅 등 모든 활동 정보가 삭제됩니다. 계정 삭제 후 7일 간 다시 가입할 수 없어요.',
                        style: FontStyles.reg14.copyWith(
                          color: context.grays.gray4,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x24),

                      // 유의사항 체크박스
                      GestureDetector(
                        onTap: () => setState(() => _isNoticed = !_isNoticed),
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
                                color: _isNoticed
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
                      const SizedBox(height: AppSpacing.x30),

                      // 탈퇴 사유 섹션
                      RichText(
                        text: TextSpan(
                          style: FontStyles.bold20.copyWith(
                            color: colors.onSurface,
                          ),
                          children: [
                            TextSpan(text: '${userName}님의 '),
                            TextSpan(
                              text: '탈퇴 이유',
                              style: TextStyle(color: context.colors.primary),
                            ),
                            const TextSpan(text: '가 궁금해요.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x16),

                      // 사유 목록 라디오 버튼
                      for (final reason in _reasons) ...[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _selectedReasonEnum = reason['enum'];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          _selectedReasonEnum == reason['enum']
                                          ? context.colors.primary
                                          : context.grays.gray6,
                                      width: 2,
                                    ),
                                    color: _selectedReasonEnum == reason['enum']
                                        ? context.colors.primary
                                        : Colors.transparent,
                                  ),
                                  child: _selectedReasonEnum == reason['enum']
                                      ? const Center(
                                          child: Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  reason['label']!,
                                  style: FontStyles.med16.copyWith(
                                    color: colors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // '기타' 선택 시 상세 사유 입력창
                        if (reason['enum'] == 'OTHER' &&
                            _selectedReasonEnum == 'OTHER') ...[
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: context.grays.gray8,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: TextField(
                              controller: _detailReasonController,
                              maxLines: 3,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: '기타 사유를 입력해주세요',
                                hintStyle: FontStyles.reg14.copyWith(
                                  color: context.grays.gray5,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ],
                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              // 하단 버튼 2개: [탈퇴하기] & [계속 이용하기]
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit
                              ? context.grays.gray8
                              : context.grays.gray8.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _canSubmit ? _handleWithdrawSubmit : null,
                        child: Text(
                          '탈퇴하기',
                          style: FontStyles.bold20.copyWith(
                            color: _canSubmit
                                ? context.grays.gray3
                                : context.grays.gray5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          '계속 이용하기',
                          style: FontStyles.bold20.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
            ],
          ),
        ),
      ),
    );
  }
}
