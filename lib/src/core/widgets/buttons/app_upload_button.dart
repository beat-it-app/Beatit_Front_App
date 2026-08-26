import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../extensions/app_theme_extension.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class AppUploadButton extends StatefulWidget {
  const AppUploadButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 120,
    this.iconSize = 24,
    this.iconCircleSize = 30,
    this.isDisabled = false,
    this.icon,
    this.iconAssetPath = 'assets/icons/plus/plus.svg',
    this.backgroundColor,
    this.pressedBackgroundColor,
    this.borderColor,
    this.textColor,
    this.iconCircleBackgroundColor,
    this.iconColor,
  });

  final VoidCallback? onPressed;
  final String text;

  final double height;
  final double iconSize;
  final double iconCircleSize;

  final bool isDisabled;

  final Widget? icon;
  final String? iconAssetPath;

  final Color? backgroundColor;

  /// 눌렀을 때 박스 안쪽 배경색.
  /// 값을 안 넣으면 기본 배경 위에 onSurface를 살짝 입혀서 자동 처리함.
  final Color? pressedBackgroundColor;

  final Color? borderColor;
  final Color? textColor;

  final Color? iconCircleBackgroundColor;
  final Color? iconColor;

  @override
  State<AppUploadButton> createState() => _AppUploadButtonState();
}

class _AppUploadButtonState extends State<AppUploadButton> {
  bool _isPressed = false;

  bool get _isDisabled {
    return widget.isDisabled || widget.onPressed == null;
  }

  void _setPressed(bool value) {
    if (_isPressed == value || _isDisabled) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final grays = context.grays;
    final colors = context.colors;

    final baseBackgroundColor = _isDisabled
        ? colors.surfaceContainerHighest
        : widget.backgroundColor ?? grays.white;

    final effectiveBackgroundColor = _isPressed
        ? widget.pressedBackgroundColor ??
              Color.alphaBlend(
                colors.onSurface.withOpacity(0.06),
                baseBackgroundColor,
              )
        : baseBackgroundColor;

    final effectiveBorderColor = _isDisabled
        ? grays.gray6
        : widget.borderColor ?? grays.gray7;

    final effectiveTextColor = _isDisabled
        ? colors.onSurfaceVariant
        : widget.textColor ?? grays.gray1;

    final effectiveIconCircleBackgroundColor = _isDisabled
        ? grays.gray6
        : widget.iconCircleBackgroundColor ?? grays.gray1;

    final effectiveIconColor = _isDisabled
        ? grays.gray4
        : widget.iconColor ?? grays.white;

    return Semantics(
      button: true,
      enabled: !_isDisabled,
      label: widget.text,
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
        onTap: _isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: effectiveBorderColor, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _UploadIconCircle(
                icon: widget.icon,
                iconAssetPath: widget.iconAssetPath,
                circleSize: widget.iconCircleSize,
                iconSize: widget.iconSize,
                circleColor: effectiveIconCircleBackgroundColor,
                iconColor: effectiveIconColor,
              ),
              const SizedBox(height: AppSpacing.x12),
              Text(
                widget.text,
                style: FontStyles.med14.copyWith(color: effectiveTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadIconCircle extends StatelessWidget {
  const _UploadIconCircle({
    required this.icon,
    required this.iconAssetPath,
    required this.circleSize,
    required this.iconSize,
    required this.circleColor,
    required this.iconColor,
  });

  final Widget? icon;
  final String? iconAssetPath;
  final double circleSize;
  final double iconSize;
  final Color circleColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    final iconWidget =
        icon ??
        SvgPicture.asset(
          iconAssetPath ?? 'assets/icons/plus/plus.svg',
          width: iconSize,
          height: iconSize,
        );

    return ColorFiltered(
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: FittedBox(fit: BoxFit.contain, child: iconWidget),
      ),
    );
  }
}
