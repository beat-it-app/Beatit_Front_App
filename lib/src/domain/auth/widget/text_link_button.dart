import 'package:flutter/material.dart';

import '../../../core/theme/app_fonts.dart';

class TextLinkButton extends StatefulWidget {
  const TextLinkButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    this.isSelected = false,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;

  final bool isSelected;

  @override
  State<TextLinkButton> createState() => _TextLinkButtonState();
}

class _TextLinkButtonState extends State<TextLinkButton> {
  bool _isPressed = false;
  bool _isFocused = false;
  bool _isHovered = false;

  bool get _isActive {
    return widget.isSelected || _isPressed || _isFocused || _isHovered;
  }

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
    return FocusableActionDetector(
      onShowFocusHighlight: (value) {
        setState(() {
          _isFocused = value;
        });
      },
      onShowHoverHighlight: (value) {
        setState(() {
          _isHovered = value;
        });
      },
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
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            style: FontStyles.reg14.copyWith(
              color: widget.color,
              decoration: TextDecoration.underline,
              decorationColor: widget.color,
              decorationThickness: 1,
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
