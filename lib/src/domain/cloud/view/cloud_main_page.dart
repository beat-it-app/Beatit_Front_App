import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/auth/widget/result_box.dart';

class CloudMainPage extends StatefulWidget {
  const CloudMainPage({super.key});

  @override
  State<CloudMainPage> createState() => _CloudMainPageState();
}

class _CloudMainPageState extends State<CloudMainPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '아이디 찾기',
                style: FontStyles.bold28.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                '가입한 이메일을 통해 인증 후 아이디를 확인해주세요.',
                style: FontStyles.reg12.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.x50),
              _RequiredLabel(
                text: '이메일',
                color: colors.onSurface,
                requiredColor: colors.primary,
              ),
              const SizedBox(height: AppSpacing.x8),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: []),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({
    required this.text,
    required this.color,
    required this.requiredColor,
  });

  final String text;
  final Color color;
  final Color requiredColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
          children: [
            TextSpan(text: text),
            if (requiredColor != null)
              TextSpan(
                text: ' *',
                style: TextStyle(color: requiredColor),
              ),
          ],
        ),
      ),
    );
  }
}
