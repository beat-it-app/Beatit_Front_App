import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudBasicButton extends StatefulWidget {
  const CloudBasicButton({
    super.key,
    this.onPressed,
    this.semanticLabel = '파일 목록 열기',
  });

  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  State<CloudBasicButton> createState() => _CloudBasicButtonState();
}

class _CloudBasicButtonState extends State<CloudBasicButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isPressed
        ? context.grays.gray7.withValues(alpha: 0.9)
        : context.grays.white.withValues(alpha: 0.9);

    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: widget.onPressed == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.onPressed == null
              ? null
              : (_) => _setPressed(true),
          onTapUp: widget.onPressed == null
              ? null
              : (_) => _setPressed(false),
          onTapCancel: widget.onPressed == null
              ? null
              : () => _setPressed(false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            height: 60.0,
            width: 70.0,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
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
                'assets/icons/cloud/playlist.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(
                  context.grays.black,
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
