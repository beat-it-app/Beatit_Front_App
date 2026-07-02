import 'package:flutter/material.dart';

import '../../extensions/app_theme_extension.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onChanged,
  });

  final String text;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = _AppToggleColors.from(context, isSelected: isSelected);

    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onChanged?.call(!isSelected);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x12,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: colors.border),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            style: FontStyles.reg12.copyWith(color: colors.text),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

class _AppToggleColors {
  const _AppToggleColors({
    required this.background,
    required this.border,
    required this.text,
  });

  final Color background;
  final Color border;
  final Color text;

  factory _AppToggleColors.from(
    BuildContext context, {
    required bool isSelected,
  }) {
    if (isSelected) {
      return _AppToggleColors(
        background: context.brands.beatOrange6,
        border: context.brands.beatOrange2,
        text: context.brands.beatOrange1,
      );
    }

    return _AppToggleColors(
      background: context.grays.white,
      border: context.grays.gray4,
      text: context.grays.gray1,
    );
  }
}
