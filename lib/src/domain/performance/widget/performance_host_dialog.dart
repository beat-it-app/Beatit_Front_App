import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// team_invite_dialog의 간격·제목·회색 정보 박스·버튼 배치를 따른다.
Future<void> showPerformanceHostDialog({
  required BuildContext context,
  required String hostName,
  required PerformanceHostContactType contactType,
  required String contact,
}) => showDialog<void>(
  context: context,
  builder: (dialogContext) {
    final isLink = contactType == PerformanceHostContactType.link;

    Future<void> act() async {
      if (isLink) {
        final raw = contact.trim();
        final uri = Uri.tryParse(
          raw.startsWith('http://') || raw.startsWith('https://')
              ? raw
              : 'https://$raw',
        );
        if (uri == null || !uri.hasAuthority ||
            !(await launchUrl(uri, mode: LaunchMode.externalApplication))) {
          if (!dialogContext.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('링크를 열 수 없습니다.')),
          );
        }
      } else {
        await Clipboard.setData(ClipboardData(text: contact));
        if (!dialogContext.mounted) return;
        Navigator.of(dialogContext).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('연락처가 복사되었습니다.')),
        );
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
            vertical: 44,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('공연 호스트 정보',
                  style: FontStyles.bold22.copyWith(color: context.grays.black)),
              const SizedBox(height: AppSpacing.x20),
              Text(
                isLink
                    ? '아래 링크를 클릭해서 호스트에게 공연을 문의하세요.'
                    : '아래 내용을 복사해서 호스트에게 공연을 문의하세요.',
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
                    Text('[$hostName] 문의하기',
                        style: FontStyles.semi16.copyWith(
                          color: context.grays.black,
                        )),
                    const SizedBox(height: AppSpacing.x8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(isLink ? Icons.link : Icons.call,
                            size: 20, color: context.grays.gray2),
                        const SizedBox(width: AppSpacing.x8),
                        Expanded(
                          child: Text(contact,
                            style: FontStyles.reg16.copyWith(
                              color: isLink
                                  ? context.brands.beatOrange2
                                  : context.grays.black,
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
                text: isLink ? '링크로 이동' : '연락처 복사',
                icon: isLink ? Icons.link : Icons.copy_rounded,
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
    this.icon,
  });

  final String text;
  final VoidCallback onPressed;
  final bool primary;
  final IconData? icon;

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
          if (icon != null) ...[
            Icon(icon, size: 20,
              color: primary ? context.grays.white : context.grays.gray4),
            const SizedBox(width: AppSpacing.x8),
          ],
          Text(text,
            style: FontStyles.semi16.copyWith(
              color: primary ? context.grays.white : context.grays.gray4,
            ),
          ),
        ],
      ),
    ),
  );
}
