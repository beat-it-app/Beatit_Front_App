import 'package:beatit_front_app/src/domain/performance/widget/performance_xfile_image.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_host_dialog.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_location_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class PerformanceInfoSection extends StatelessWidget {
  const PerformanceInfoSection({
    super.key,
    required this.performance,
    this.isMine = false,
    this.onViewResponses,
  });

  final PerformanceDetailData performance;
  final bool isMine;
  final VoidCallback? onViewResponses;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.x20,
      AppSpacing.x24,
      AppSpacing.x20,
      AppSpacing.x40,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 공연 팀
        if (performance.teamName?.isNotEmpty ?? false)
          _InfoItem(label: '공연 팀', content: performance.teamName!),

        // 2. 공연 소개 (description)
        _InfoItem(
          label: '공연 소개',
          content: performance.introduction.trim().isEmpty
              ? '등록된 공연 소개가 없습니다.'
              : performance.introduction,
        ),

        // 3. 공연 시간
        _InfoItem(
          label: '공연 시간',
          content: _formatDateTime(performance.startsAt),
        ),

        // 4. 공연 장소 및 지도
        if (performance.location != null)
          PerformanceLocationSection(location: performance.location!),

        // 5. 티켓 정보 (무료/사전예매/현장예매)
        if (performance.ticketTypes.isNotEmpty)
          _InfoItem(label: '티켓 정보', content: _ticketDescription(performance)),

        // 6. 예매 링크
        if (performance.bookingUrl.trim().isNotEmpty)
          _InfoItem(
            label: '예매 링크',
            content: performance.bookingUrl,
            onTap: () => _launchExternalLink(context, performance.bookingUrl),
          ),

        // 7. 호스트 정보 및 문의하기
        if (performance.hostName.trim().isNotEmpty) ...[
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/performance/lines.svg',
                width: 10,
                height: 16,
                colorFilter: ColorFilter.mode(
                  context.grays.gray3,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                '호스트',
                style: FontStyles.reg14.copyWith(color: context.grays.gray3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          Row(
            children: [
              Text(
                performance.hostName,
                style: FontStyles.med16.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              // 💡 hostContactType이 null이어도 contact 내용이 있으면 기본 Phone 타입으로 다이얼로그 호출
              if (performance.hostContact.trim().isNotEmpty)
                InkWell(
                  onTap: () => showPerformanceHostDialog(
                    context: context,
                    hostName: performance.hostName,
                    contactType:
                        performance.hostContactType ??
                        PerformanceHostContactType.phone,
                    contact: performance.hostContact,
                  ),
                  child: Text(
                    '문의하기',
                    style: FontStyles.med14.copyWith(
                      color: context.brands.beatOrange2,
                      decoration: TextDecoration.underline,
                      decorationColor: context.brands.beatOrange2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x20),
        ],

        // 8. 내가 등록한 공연인 경우 응답 보기
        if (isMine) ...[
          const SizedBox(height: AppSpacing.x8),
          AppButton(
            text: '응답 보기',
            onPressed:
                onViewResponses ??
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('응답 조회 기능은 아직 연결되지 않았습니다.')),
                ),
          ),
        ],
      ],
    ),
  );
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.content, this.onTap});

  final String label;
  final String content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.x20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/performance/lines.svg',
              width: 10,
              height: 16,
              colorFilter: ColorFilter.mode(
                context.grays.gray3,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(
              label,
              style: FontStyles.reg14.copyWith(color: context.grays.gray3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x8),
        InkWell(
          onTap: onTap,
          child: Text(
            content,
            style: FontStyles.med16.copyWith(
              color: onTap == null
                  ? context.grays.gray2
                  : context.brands.beatOrange2,
              decoration: onTap == null
                  ? TextDecoration.none
                  : TextDecoration.underline,
              decorationColor: onTap == null
                  ? null
                  : context.brands.beatOrange2,
            ),
          ),
        ),
      ],
    ),
  );
}

class PerformanceDetailSection extends StatelessWidget {
  const PerformanceDetailSection({super.key, required this.performance});

  final PerformanceDetailData performance;

  @override
  Widget build(BuildContext context) {
    final hasImages =
        performance.detailImageUrls.isNotEmpty ||
        performance.detailImageFiles.isNotEmpty;
    final hasText = performance.detailDescription.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x24,
        AppSpacing.x20,
        AppSpacing.x40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 상세 이미지 목록 (네트워크 이미지)
          for (final url in performance.detailImageUrls)
            if (url.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  url,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
            ],

          // 2. 상세 이미지 파일 (로컬 파일 미리보기용)
          for (final file in performance.detailImageFiles) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: PerformanceXFileImage(
                file: file,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
          ],

          // 3. 상세 정보 설명글 (detailInfo)
          if (hasText)
            Text(
              performance.detailDescription,
              style: FontStyles.reg14.copyWith(
                color: context.colors.onSurface,
                height: 1.6,
              ),
            ),

          // 4. 정보가 전혀 없는 경우
          if (!hasImages && !hasText)
            Text(
              '등록된 상세 정보가 없습니다.',
              style: FontStyles.reg14.copyWith(color: context.grays.gray5),
            ),
        ],
      ),
    );
  }
}

String _formatDateTime(DateTime date) =>
    '${date.year}년 ${date.month}월 ${date.day}일 (${_weekdays[date.weekday - 1]}) '
    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

String _ticketDescription(PerformanceDetailData data) {
  if (data.ticketTypes.contains(PerformanceTicketType.free)) return '무료 공연';
  final parts = <String>[];
  for (final entry in [
    (PerformanceTicketType.general, '일반 예매'),
    (PerformanceTicketType.advance, '사전 예매'),
    (PerformanceTicketType.onsite, '현장 예매'),
  ]) {
    if (data.ticketTypes.contains(entry.$1)) {
      final price = data.ticketPrices[entry.$1];
      parts.add(
        price == null || price.isEmpty ? entry.$2 : '${entry.$2} ${price}원',
      );
    }
  }
  return parts.isEmpty ? '티켓 정보 없음' : parts.join(' / ');
}

Future<void> _launchExternalLink(BuildContext context, String url) async {
  final raw = url.trim();
  final uri = Uri.tryParse(
    raw.startsWith('http://') || raw.startsWith('https://')
        ? raw
        : 'https://$raw',
  );
  if (uri == null ||
      !uri.hasAuthority ||
      !(await launchUrl(uri, mode: LaunchMode.externalApplication))) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('예매 링크를 열 수 없습니다.')));
  }
}
