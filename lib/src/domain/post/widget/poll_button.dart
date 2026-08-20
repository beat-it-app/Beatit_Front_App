import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class PollButton extends StatefulWidget {
  const PollButton({super.key, required this.onPressed, this.text = '투표하기'});

  final VoidCallback onPressed;
  final String text;

  @override
  State<PollButton> createState() => _PollButtonState();
}

class _PollButtonState extends State<PollButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  Color _pressedColor(Color baseColor) {
    if (!_isPressed) {
      return baseColor;
    }

    // 누르는 동안 아주 살짝 어둡게
    return Color.lerp(baseColor, Colors.black, 0.06)!;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          _setPressed(true);
        },
        onTapUp: (_) {
          _setPressed(false);
        },
        onTapCancel: () {
          _setPressed(false);
        },
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          decoration: BoxDecoration(
            color: _pressedColor(context.brands.beatOrange6),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: FontStyles.semi14.copyWith(
                color: context.brands.beatOrange2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
