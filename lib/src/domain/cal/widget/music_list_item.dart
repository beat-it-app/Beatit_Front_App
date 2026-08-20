import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_fonts.dart';

class MusicListItem extends StatefulWidget {
  const MusicListItem({
    super.key,
    required this.trackText,
    required this.artistText,
    required this.onTap,
    this.isSelected = false,
  });

  final String trackText;
  final String artistText;
  final VoidCallback onTap;

  final bool isSelected;

  @override
  State<MusicListItem> createState() => _MusicListItemState();
}

class _MusicListItemState extends State<MusicListItem> {
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
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x12,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: ShapeDecoration(
              shape: OvalBorder(),
              color: context.colors.primary,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: SvgPicture.asset(
                  'assets/icons/core/play.svg',
                  colorFilter: ColorFilter.mode(
                    context.colors.surface,
                    BlendMode.srcIn,
                  ),
                  width: 11.0,
                  height: 11.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.trackText,
                style: FontStyles.med16.copyWith(color: context.grays.black),
              ),
              Text(
                widget.artistText,
                style: FontStyles.med12.copyWith(color: context.grays.gray5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
