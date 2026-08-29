import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

enum ButtonVariant { primary, black, white, gray, outlined, outlinedGray }

enum ButtonWidth {
  small, // width 97
  medium, // width 125
  expand, // width double.infinity
}

enum ButtonHeight {
  small, // height 45
  normal, // height 50
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.height = ButtonHeight.normal,
    this.width = ButtonWidth.expand,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonHeight height;
  final ButtonWidth width;
  final bool isLoading;
  final bool isDisabled;

  bool get _isDisabled => isDisabled || onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final child = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _loadingColor(colors),
            ),
          )
        : Text(text);

    final button = switch (variant) {
      ButtonVariant.primary => FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle,
        child: child,
      ),
      ButtonVariant.black => FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle.merge(
          FilledButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: colors.onSecondary,
          ),
        ),
        child: child,
      ),
      ButtonVariant.white => FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle.merge(
          FilledButton.styleFrom(
            backgroundColor: colors.surface,
            foregroundColor: context.grays.gray4,
          ),
        ),
        child: child,
      ),
      ButtonVariant.gray => FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle.merge(
          FilledButton.styleFrom(
            backgroundColor: context.grays.gray8,
            foregroundColor: context.grays.gray4,
          ),
        ),
        child: child,
      ),
      ButtonVariant.outlined => OutlinedButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle,
        child: child,
      ),
      ButtonVariant.outlinedGray => OutlinedButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle.merge(
          OutlinedButton.styleFrom(
            backgroundColor: colors.surface,
            foregroundColor: colors.onSurface,
            side: BorderSide(color: context.grays.gray7, width: 1),
          ),
        ),
        child: child,
      ),
    };

    return SizedBox(width: width.value, height: height.value, child: button);
  }

  ButtonStyle get _sizeStyle {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, height.value)),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(height.value)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Color _loadingColor(ColorScheme colors) {
    return switch (variant) {
      ButtonVariant.primary => colors.onPrimary,
      ButtonVariant.black => colors.onSecondary,
      ButtonVariant.white => colors.onSurface,
      ButtonVariant.gray => colors.onSurface,
      ButtonVariant.outlined => colors.primary,
      ButtonVariant.outlinedGray => colors.primary,
    };
  }
}

extension on ButtonWidth {
  double get value {
    return switch (this) {
      ButtonWidth.small => 97,
      ButtonWidth.medium => 125,
      ButtonWidth.expand => double.infinity,
    };
  }
}

extension on ButtonHeight {
  double get value {
    return switch (this) {
      ButtonHeight.small => 45,
      ButtonHeight.normal => 50,
    };
  }
}
