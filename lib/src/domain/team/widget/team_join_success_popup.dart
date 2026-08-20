import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

//Todo: 다크모드 적용
class TeamJoinSuccessPopup extends StatelessWidget {
  final String teamName;
  final VoidCallback? onConfirm;

  const TeamJoinSuccessPopup({
    super.key,
    required this.teamName,
    this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String teamName,
    VoidCallback? onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return TeamJoinSuccessPopup(teamName: teamName, onConfirm: onConfirm);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300,
          minHeight: 440,
          maxHeight: 440,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x20,
            AppSpacing.x40,
            AppSpacing.x20,
            AppSpacing.x20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/success.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSpacing.x10),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: FontStyles.bold22.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(text: "팀 '$teamName'\n"),
                    TextSpan(
                      text: '가입',
                      style: TextStyle(
                        color: context.colors.onPrimaryContainer,
                      ),
                    ),
                    const TextSpan(text: '을 축하합니다!'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x16),

              Text(
                '이제부터 빗잇에서 함께\n멋진 음악을 시작해보세요!',
                textAlign: TextAlign.center,
                style: FontStyles.semi16.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.x40),

              AppButton(
                text: '팀 페이지로 이동',
                variant: ButtonVariant.primary,
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
