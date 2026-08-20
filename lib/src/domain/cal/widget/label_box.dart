import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';

class LabelBox extends StatelessWidget {
  final String iconAddress;
  final String value;

  const LabelBox({super.key, required this.iconAddress, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x10,
        vertical: AppSpacing.x4,
      ),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.x4,
        children: [
          SvgPicture.asset(
            iconAddress,
            width: 16.0,
            height: 16.0,
            fit: BoxFit.contain,
            color: context.grays.black,
          ),
          Text(
            value,
            style: FontStyles.semi14.copyWith(color: context.grays.black),
          ),
        ],
      ),
    );
  }
}
