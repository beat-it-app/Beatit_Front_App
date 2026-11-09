import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

/// 기존 AppButton을 그대로 사용하되, 초대장 카드 고유의 검정 배경과 별개로
/// 디자인 시스템의 원래 주황색/짙은 회색 버튼 대비를 유지한다.
class PerformanceInvitationActions extends StatelessWidget {
  const PerformanceInvitationActions({
    super.key,
    required this.onSaveInvitation,
    required this.onSaveSetlist,
    required this.onViewDetails,
    required this.hasSetlist,
  });

  final VoidCallback onSaveInvitation;
  final VoidCallback onSaveSetlist;
  final VoidCallback onViewDetails;
  final bool hasSetlist;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
        child: Column(
          children: [
            AppButton(
              text: '초대장 저장하기',
              onPressed: onSaveInvitation,
            ),
            const SizedBox(height: AppSpacing.x8),
            AppButton(
              text: '셋리스트 저장하기',
              isDisabled: !hasSetlist,
              onPressed: onSaveSetlist,
            ),
            const SizedBox(height: AppSpacing.x8),
            AppButton(
              text: '공연 상세정보 보러가기',
              variant: ButtonVariant.darkGray,
              onPressed: onViewDetails,
            ),
          ],
        ),
      ),
    );
  }
}
