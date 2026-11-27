import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// AppPopup의 기본 제목/확인 버튼을 유지하고, 일반 예매 안내 내용만 구성한다.
class PerformanceTicketInformationPopup {
  const PerformanceTicketInformationPopup._();

  static Future<bool?> show(BuildContext context) => AppPopup.show(
    context,
    title: '일반 예매 안내',
    contentWidget: const _TicketInformationContent(),
    confirmText: '확인',
  );
}

class _TicketInformationContent extends StatelessWidget {
  const _TicketInformationContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: AppSpacing.x16),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x20,
        ),
        decoration: BoxDecoration(
          color: context.grays.gray8,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/performance/ticket.svg',
              colorFilter: ColorFilter.mode(
                context.grays.gray5,
                BlendMode.srcIn,
              ),
              width: 40,
              height: 40,
            ),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '사전 예매',
                      style: FontStyles.semi16.copyWith(
                        color: context.brands.beatOrange1,
                      ),
                    ),
                    const TextSpan(text: '와 '),
                    TextSpan(
                      text: '현장 예매',
                      style: FontStyles.semi16.copyWith(
                        color: context.brands.beatOrange1,
                      ),
                    ),
                    const TextSpan(text: '가\n'),
                    TextSpan(
                      text: '동일한 가격',
                      style: FontStyles.semi16.copyWith(
                        color: context.brands.beatOrange1,
                      ),
                    ),
                    const TextSpan(text: '의 공연인 경우'),
                  ],
                ),
                style: FontStyles.semi16.copyWith(color: context.grays.gray1),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.x20),
      const _TicketBullet(
        '사전 예매가와 현장 예매가가 동일한 경우, 따로 예매 금액을 설정하지 않고 일반 예매로 같은 티겟 가격 설정이 가능합니다.',
      ),
      const _TicketBullet('일반 예매 선택 시 아래와 같이 표시되니, 참고 후 이용해주세요.'),
      const _TicketBullet('ex) 일반 예매 0000원 (현장/사전예매 구분없는 공연)'),
      const _TicketBullet('등록된 공연은 <나의 공연 보기>에서 수정이 가능합니다.'),
    ],
  );
}

class _TicketBullet extends StatelessWidget {
  const _TicketBullet(this.content);

  final String content;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.x8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•  ',
          style: FontStyles.med12.copyWith(color: context.grays.gray4),
        ),
        Expanded(
          child: Text(
            content,
            style: FontStyles.med12.copyWith(color: context.grays.gray4),
          ),
        ),
      ],
    ),
  );
}
