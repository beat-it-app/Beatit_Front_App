import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
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
              color: colors.onSecondary,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/cal/plus.svg',
                width: 16.0,
                color: context.grays.white,
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(
                text,
                style: FontStyles.reg18.copyWith(color: context.grays.white),
              ),
            ],
          );

    return Container(
      height: 45.0,
      width: 160.0,
      child: FilledButton(
        onPressed: _isDisabled ? null : onPressed,
        style: _sizeStyle.merge(
          FilledButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: colors.onSecondary,
          ),
        ),
        child: child,
      ),
    );
  }

  ButtonStyle get _sizeStyle {
    return ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap);
  }
}
