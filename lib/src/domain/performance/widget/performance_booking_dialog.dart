import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

/// performance_host_dialog의 간격·제목·회색 정보 박스·버튼 배치를 따른다.
Future<void> showPerformanceBookingDialog({
  required BuildContext context,
  required String teamName,
  required String bookingUrl,
}) => showDialog<void>(
  context: context,
  builder: (dialogContext) {
    Future<void> act() async {
      final raw = bookingUrl.trim();
      final uri = Uri.tryParse(
        raw.startsWith('http://') || raw.startsWith('https://')
            ? raw
            : 'https://$raw',
      );
      if (uri == null ||
          !uri.hasAuthority ||
          !(await launchUrl(uri, mode: LaunchMode.externalApplication))) {
        if (!dialogContext.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('링크를 열 수 없습니다.')));
      }
    }

    return Dialog(
      backgroundColor: context.grays.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x20,
            vertical: 33,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '공연 예매 바로가기',
                style: FontStyles.bold22.copyWith(color: context.grays.black),
              ),
              const SizedBox(height: AppSpacing.x20),
              Text(
                '아래 링크를 클릭해서\n공연을 예매하세요.',
                textAlign: TextAlign.center,
                style: FontStyles.semi16.copyWith(color: context.grays.gray4),
              ),
              const SizedBox(height: AppSpacing.x20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.x16),
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[$teamName] 공연 예매',
                      style: FontStyles.semi16.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/performance/link.svg',
                          colorFilter: ColorFilter.mode(
                            context.grays.gray1,
                            BlendMode.srcIn,
                          ),
                          width: 16.0,
                          height: 16.0,
                        ),
                        const SizedBox(width: AppSpacing.x8),
                        Expanded(
                          child: Text(
                            bookingUrl,
                            style: FontStyles.reg16.copyWith(
                              color: context.brands.beatOrange2,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x12),
              _DialogActionButton(
                text: '링크로 이동',
                iconLink: 'assets/icons/performance/link.svg',
                onPressed: act,
                primary: true,
              ),
              const SizedBox(height: AppSpacing.x8),
              _DialogActionButton(
                text: '닫기',
                onPressed: () => Navigator.of(dialogContext).pop(),
                primary: false,
              ),
            ],
          ),
        ),
      ),
    );
  },
);

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.text,
    required this.onPressed,
    required this.primary,
    this.iconLink,
  });

  final String text;
  final VoidCallback onPressed;
  final bool primary;
  final String? iconLink;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    width: double.infinity,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: primary ? context.grays.gray1 : context.grays.gray8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconLink != null) ...[
            SvgPicture.asset(
              iconLink!,
              colorFilter: ColorFilter.mode(
                context.grays.white,
                BlendMode.srcIn,
              ),
              width: 20.0,
              height: 20.0,
            ),
            const SizedBox(width: AppSpacing.x8),
          ],
          Text(
            text,
            style: FontStyles.semi16.copyWith(
              color: primary ? context.grays.white : context.grays.gray4,
            ),
          ),
        ],
      ),
    ),
  );
}
