import 'package:beatit_front_app/src/domain/auth/provider/mypage_provider.dart';
import 'package:beatit_front_app/src/domain/auth/view/mypage/app_withdraw_reason_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/mypage/team_withdraw_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

class WithdrawalTypeSelectPage extends ConsumerStatefulWidget {
  const WithdrawalTypeSelectPage({super.key});

  @override
  ConsumerState<WithdrawalTypeSelectPage> createState() =>
      _WithdrawalTypeSelectPageState();
}

class _WithdrawalTypeSelectPageState
    extends ConsumerState<WithdrawalTypeSelectPage> {
  // 'team' 또는 'app'
  String? _selectedType;

  void _handleNext() {
    if (_selectedType == 'team') {
      // 💡 현재 참여 중인 팀 유무 확인
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

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const TeamWithdrawPage()));
    } else if (_selectedType == 'app') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AppWithdrawReasonPage()));
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x20),
              Text(
                '탈퇴 유형을\n선택해주세요',
                style: FontStyles.bold34.copyWith(
                  color: colors.onSurface,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.x30),

              // 1. 팀 탈퇴하기 카드
              _TypeCard(
                title: '팀 탈퇴하기',
                subtitle: '현재 로그인된 팀에서 탈퇴할 수 있어요.',
                isSelected: _selectedType == 'team',
                onTap: () => setState(() => _selectedType = 'team'),
              ),
              const SizedBox(height: AppSpacing.x12),

              // 2. 빗잇 탈퇴하기 카드
              _TypeCard(
                title: '빗잇 탈퇴하기',
                subtitle: '빗잇 계정을 삭제할 수 있어요. 계정 삭제 시,\n모든 활동 정보가 삭제 돼요.',
                isSelected: _selectedType == 'app',
                onTap: () => setState(() => _selectedType = 'app'),
              ),

              const Spacer(),

              // 다음 버튼
              AppButton(
                text: '다음',
                variant: ButtonVariant.black,
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                onPressed: _selectedType != null ? _handleNext : null,
              ),
              const SizedBox(height: AppSpacing.x16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x16),
        decoration: BoxDecoration(
          color: context.grays.gray8,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isSelected
              ? Border.all(color: context.colors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : context.grays.gray6,
                  width: 1,
                ),
                color: isSelected
                    ? context.colors.primary
                    : context.colors.surface,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.circle, size: 8, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontStyles.med18.copyWith(color: colors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
