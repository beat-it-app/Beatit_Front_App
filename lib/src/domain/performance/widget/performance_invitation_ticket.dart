import 'dart:math' as math;

import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/utils/app_date_time_formatter.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum InvitationTicketFace { cover, information, introduction }

/// 동적 공연 데이터를 표시하는 티켓. SVG 그래픽과 전환 애니메이션을 분리한다.
class PerformanceInvitationTicket extends StatelessWidget {
  const PerformanceInvitationTicket({
    super.key,
    required this.performance,
    required this.face,
  });

  final PerformanceDetailModel performance;
  final InvitationTicketFace face;

  String get _performanceTeam {
    final custom = performance.invitationCard?.performanceTeam.trim() ?? '';
    return custom.isNotEmpty ? custom : performance.teamName;
  }

  String get _invitationText {
    final custom = performance.invitationCard?.description.trim() ?? '';
    return custom.isNotEmpty ? custom : performance.description;
  }

  @override
  Widget build(BuildContext context) {
    final orange = AppColor.beatOrange1;
    final darkGray = AppColor.gray1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final footerHeight = math.min(60.0, constraints.maxHeight * 0.20);
        return Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x50000000),
                blurRadius: 4,
                offset: Offset(5, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipPath(
                  clipper: const _TicketTopClipper(),
                  child: ColoredBox(
                    color: face == InvitationTicketFace.introduction
                        ? darkGray
                        : orange,
                    child: switch (face) {
                      InvitationTicketFace.cover => const _CoverFace(),
                      InvitationTicketFace.information => _InformationFace(
                        performance: performance,
                        teamName: _performanceTeam,
                      ),
                      InvitationTicketFace.introduction => _IntroductionFace(
                        description: _invitationText,
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 3),
              ClipPath(
                clipper: const _TicketStubClipper(),
                child: Container(
                  width: double.infinity,
                  height: footerHeight,
                  color: face == InvitationTicketFace.introduction
                      ? darkGray
                      : orange,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: AppSpacing.x12),
                  child: Text(
                    'INVITATION CARD',
                    style: FontStyles.med12.copyWith(color: AppColor.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CoverFace extends StatelessWidget {
  const _CoverFace();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.x24),
        const _LiveStageCaption(),
        Expanded(
          child: ClipRect(
            child: SizedBox.expand(
              child: SvgPicture.asset(
                'assets/icons/performance/ticket_logo.svg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InformationFace extends StatelessWidget {
  const _InformationFace({required this.performance, required this.teamName});

  final PerformanceDetailModel performance;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 325;
        final detailsHeight = math.min(
          constraints.maxHeight * 0.30,
          math.max(110.0, constraints.maxHeight * 0.345),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x16,
                  AppSpacing.x20,
                  AppSpacing.x16,
                  AppSpacing.x8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: _LiveStageCaption()),
                    const SizedBox(height: AppSpacing.x12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.x8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            performance.title,
                            maxLines: compact ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                (compact
                                        ? FontStyles.bold22
                                        : FontStyles.bold28)
                                    .copyWith(
                                      color: AppColor.black,
                                      height: 1.18,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/icons/performance/black_arrow.svg',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: detailsHeight,
              child: ColoredBox(
                color: AppColor.gray8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x24,
                    vertical: AppSpacing.x16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _InformationLine(
                        label: '팀',
                        value: teamName,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      _InformationLine(
                        label: '날짜',
                        value: AppDateTimeFormatter.formatKstDateTime(
                          performance.performanceDateTime,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      _InformationLine(
                        label: '장소',
                        value: performance.placeName.isNotEmpty
                            ? performance.placeName
                            : performance.location?.locationName ?? '미정',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InformationLine extends StatelessWidget {
  const _InformationLine({
    required this.label,
    required this.value,
    required this.maxLines,
  });

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            maxLines: 1,
            style: FontStyles.med14.copyWith(color: AppColor.gray3),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            softWrap: maxLines > 1,
            style: FontStyles.semi14.copyWith(color: AppColor.black),
          ),
        ),
      ],
    );
  }
}

class _IntroductionFace extends StatelessWidget {
  const _IntroductionFace({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x24,
        AppSpacing.x20,
        AppSpacing.x16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: _LiveStageCaption()),
          const SizedBox(height: AppSpacing.x28),
          Text(
            '공연 소개',
            style: FontStyles.med14.copyWith(color: AppColor.gray4),
          ),
          const SizedBox(height: AppSpacing.x12),
          Expanded(
            child: SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: Text(
                description.isEmpty ? '등록된 공연 소개가 없습니다.' : description,
                style: FontStyles.semi14.copyWith(
                  color: AppColor.white,
                  height: 1.55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveStageCaption extends StatelessWidget {
  const _LiveStageCaption();

  @override
  Widget build(BuildContext context) {
    return Text(
      'LIVE STAGE',
      style: FontStyles.med12.copyWith(color: AppColor.white),
    );
  }
}

class _TicketTopClipper extends CustomClipper<Path> {
  const _TicketTopClipper();

  @override
  Path getClip(Size size) {
    final base = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.xl),
        ),
      );
    final notch = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(size.width / 2, -7), radius: 22),
      );
    return Path.combine(PathOperation.difference, base, notch);
  }

  @override
  bool shouldReclip(covariant _TicketTopClipper oldClipper) => false;
}

class _TicketStubClipper extends CustomClipper<Path> {
  const _TicketStubClipper();

  @override
  Path getClip(Size size) {
    final base = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.xl),
        ),
      );
    final holes = Path();
    for (double x = 0; x <= size.width + 10; x += 32) {
      holes.addOval(
        Rect.fromCircle(center: Offset(x, size.height + 3), radius: 8),
      );
    }
    return Path.combine(PathOperation.difference, base, holes);
  }

  @override
  bool shouldReclip(covariant _TicketStubClipper oldClipper) => false;
}
