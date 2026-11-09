import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_ticket.dart';
import 'package:flutter/material.dart';

/// 저장할 초대장 이미지 전용 레이아웃.
/// 현재 캐러셀 위치와 무관하게 공연 정보(두 번째) 티켓만 이미지에 포함한다.
/// 화면 캡처가 아니라 별도의 고정된 디자인을 그리므로 UI 스크롤 상태에 영향받지 않는다.
class PerformanceInvitationExport extends StatelessWidget {
  const PerformanceInvitationExport({
    super.key,
    required this.performance,
  });

  final PerformanceDetailModel performance;

  static const double imageWidth = 360;
  static const double imageHeight = 800;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: ColoredBox(
        color: AppColor.black,
        child: Column(
          children: [
            const SizedBox(height: 139),
            SizedBox(
              width: 254,
              height: 416,
              child: PerformanceInvitationTicket(
                performance: performance,
                face: InvitationTicketFace.information,
              ),
            ),
            const SizedBox(height: 78),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '*',
                  style: FontStyles.semi14.copyWith(color: AppColor.beatOrange1),
                ),
                const TextSpan(text: '본 이미지는 공연 관람용 티켓이 아닙니다.'),
              ]),
              style: FontStyles.semi14.copyWith(color: AppColor.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '관람용 티켓은 공연 상세페이지에서 운영진을 통해 구매해주세요.',
              style: FontStyles.reg11.copyWith(color: AppColor.gray5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
