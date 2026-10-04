import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudPlaybackButton extends StatelessWidget {
  const CloudPlaybackButton({
    super.key,
    required this.semanticLabel,
    required this.iconPath,
    required this.onPressed,
    this.width = 80.0,
    this.height = 66.0,
  });

  final String semanticLabel;
  final String iconPath;
  final VoidCallback onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: context.grays.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: context.grays.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22.0),
              border: Border.all(
                color: context.grays.gray7.withValues(alpha: 0.9),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.grays.black.withValues(alpha: 0.01),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 27.0,
                height: 27.0,
                colorFilter: ColorFilter.mode(
                  context.grays.gray1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
