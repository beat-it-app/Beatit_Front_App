import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

Future<bool?> showCloudLinkConfirmPopup(
  BuildContext context, {
  required String url,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => CloudLinkConfirmPopup(url: url),
  );
}

class CloudLinkConfirmPopup extends StatelessWidget {
  const CloudLinkConfirmPopup({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: context.grays.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x24,
            AppSpacing.x16,
            AppSpacing.x16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                child: Text(
                  '선택하신 링크로\n이동하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: FontStyles.bold22.copyWith(color: context.grays.black),
                ),
              ),
              Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: FontStyles.reg14.copyWith(color: context.grays.gray5),
              ),
              const SizedBox(height: AppSpacing.x30),
              AppButton(
                text: '예',
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              const SizedBox(height: AppSpacing.x8),
              AppButton(
                text: '아니요',
                variant: ButtonVariant.white,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
