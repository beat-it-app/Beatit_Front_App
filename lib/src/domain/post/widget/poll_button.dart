import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

class PollButton extends StatefulWidget {
  const PollButton({
    super.key,
    required this.onPressed,
    this.text = '투표하기',
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final String text;
  final bool enabled;

  @override
  State<PollButton> createState() => _PollButtonState();
}

class _PollButtonState extends State<PollButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || _isPressed == value) return;
    setState(() => _isPressed = value);
  }

  Color _pressedColor(Color baseColor) {
    if (!_isPressed || !widget.enabled) return baseColor;
    return Color.lerp(
      baseColor,
      Theme.of(context).colorScheme.shadow,
      0.06,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.enabled
        ? context.brands.beatOrange6
        : context.grays.gray7;
    final foregroundColor = widget.enabled
        ? context.brands.beatOrange2
        : context.grays.gray4;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
        onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
        onTapCancel: widget.enabled ? () => _setPressed(false) : null,
        onTap: widget.enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
            color: _pressedColor(backgroundColor),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: FontStyles.semi14.copyWith(color: foregroundColor),
            ),
          ),
        ),
      ),
    );
  }
}
