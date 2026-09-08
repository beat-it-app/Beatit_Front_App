import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';

class ResultBox extends StatelessWidget {
  final String label;
  final String value;

  const ResultBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${label}: ',
            style: FontStyles.semi16.copyWith(color: context.grays.gray1),
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            value,
            style: FontStyles.semi16.copyWith(color: context.grays.gray1),
          ),
        ],
      ),
    );
  }
}
