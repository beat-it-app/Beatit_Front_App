import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

import '../../provider/mypage_provider.dart';
import 'app_withdraw_info_page.dart';

class AppWithdrawReasonPage extends ConsumerStatefulWidget {
  const AppWithdrawReasonPage({super.key});

  @override
  ConsumerState<AppWithdrawReasonPage> createState() =>
      _AppWithdrawReasonPageState();
}

class _AppWithdrawReasonPageState extends ConsumerState<AppWithdrawReasonPage> {
  bool _isNoticed = false;

  // 선택된 사유 ENUM
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

  // 탈퇴하기 버튼 활성화 조건: 유의사항 동의 + 사유 선택 (기타 선택 시 내용 작성 필수)
  bool get _canSubmit {
    if (!_isNoticed || _selectedReasonEnum == null) return false;
    if (_selectedReasonEnum == 'OTHER') {
      return _detailReasonController.text.trim().isNotEmpty;
    }
    return true;
  }

  // 💡 탈퇴하기 버튼 클릭 시 AppWithdrawInfoPage 화면으로 이동
  void _navigateToWithdrawInfo() {
    final detailReason = _selectedReasonEnum == 'OTHER'
        ? _detailReasonController.text.trim()
        : (_reasons.firstWhere(
                (r) => r['enum'] == _selectedReasonEnum,
              )['label'] ??
              '');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AppWithdrawInfoPage(
          withdrawalReason: _selectedReasonEnum!,
          detailReason: detailReason,
        ),
      ),
    );
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
                      const SizedBox(height: AppSpacing.x20),
                      Text(
                        '정말 빗잇을\n탈퇴하실건가요?',
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x10),
                      Text(
                        '계정을 삭제하면 팀 페이지 게시글, 채팅 등 모든 활동 정보가 삭제됩니다. 계정 삭제 후 7일 간 다시 가입할 수 없어요.',
                        style: FontStyles.med16.copyWith(
                          color: context.grays.gray5,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x24),

                      // 유의사항 확인 체크박스 (클릭 시 탈퇴 이유 섹션이 토글됨)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isNoticed = !_isNoticed;
                            if (!_isNoticed) {
                              _selectedReasonEnum = null;
                              _detailReasonController.clear();
                            }
                          });
                        },
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
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  _isNoticed
                                      ? context.colors.primary
                                      : context.grays.gray6,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
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

                      // 💡 [유의사항을 체크했을 때만] 아래 사유 선택 섹션 노출
                      if (_isNoticed) ...[
                        const SizedBox(height: AppSpacing.x40),
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
                        const SizedBox(height: AppSpacing.x20),

                        // 사유 라디오 버튼 목록
                        for (final reason in _reasons) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. 라디오 버튼 + 라벨 텍스트 행
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    _selectedReasonEnum = reason['enum'];
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                _selectedReasonEnum ==
                                                    reason['enum']
                                                ? context.colors.primary
                                                : context.grays.gray6,
                                            width: 1,
                                          ),
                                          color:
                                              _selectedReasonEnum ==
                                                  reason['enum']
                                              ? context.colors.primary
                                              : Colors.transparent,
                                        ),
                                        child:
                                            _selectedReasonEnum ==
                                                reason['enum']
                                            ? const Center(
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 8,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        reason['label']!,
                                        style: FontStyles.med18.copyWith(
                                          color: colors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // 2. '기타' 글자 아래로 독립 배치되는 입력창 (포커스 테두리 제거)
                              if (reason['enum'] == 'OTHER' &&
                                  _selectedReasonEnum == 'OTHER') ...[
                                const SizedBox(height: 4),
                                Container(
                                  margin: const EdgeInsets.only(left: 28),
                                  decoration: BoxDecoration(
                                    color: context.grays.gray8,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  child: TextField(
                                    controller: _detailReasonController,
                                    maxLines: 1,
                                    onChanged: (_) => setState(() {}),
                                    decoration: InputDecoration(
                                      hintText: '기타 사유를 입력해주세요',
                                      hintStyle: FontStyles.reg18.copyWith(
                                        color: context.grays.gray5,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ),
                        ],
                      ],
                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              // 하단 [탈퇴하기] & [계속 이용하기] 버튼 영역
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit
                              ? context.colors.primary
                              : context.grays.gray7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        // 💡 탈퇴 사유를 지닌 채 AppWithdrawInfoPage로 이동
                        onPressed: _canSubmit ? _navigateToWithdrawInfo : null,
                        child: Text(
                          '탈퇴하기',
                          style: FontStyles.med16.copyWith(
                            color: _canSubmit
                                ? context.colors.surface
                                : context.grays.gray4,
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          '계속 이용하기',
                          style: FontStyles.med16.copyWith(color: Colors.white),
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
