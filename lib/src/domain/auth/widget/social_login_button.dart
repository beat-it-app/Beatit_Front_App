import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

enum SocialLoginProvider { naver, google, kakao, apple }

enum SocialLoginButtonVariant { full, circle }

class SocialLoginButton extends StatefulWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.height = 60,
    this.variant = SocialLoginButtonVariant.full,
  });

  const SocialLoginButton.naver({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
    SocialLoginButtonVariant variant = SocialLoginButtonVariant.full,
  }) : this(
         key: key,
         provider: SocialLoginProvider.naver,
         onPressed: onPressed,
         height: height,
         variant: variant,
       );

  const SocialLoginButton.google({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
    SocialLoginButtonVariant variant = SocialLoginButtonVariant.full,
  }) : this(
         key: key,
         provider: SocialLoginProvider.google,
         onPressed: onPressed,
         height: height,
         variant: variant,
       );

  const SocialLoginButton.kakao({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
    SocialLoginButtonVariant variant = SocialLoginButtonVariant.full,
  }) : this(
         key: key,
         provider: SocialLoginProvider.kakao,
         onPressed: onPressed,
         height: height,
         variant: variant,
       );

  const SocialLoginButton.apple({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
    SocialLoginButtonVariant variant = SocialLoginButtonVariant.full,
  }) : this(
         key: key,
         provider: SocialLoginProvider.apple,
         onPressed: onPressed,
         height: height,
         variant: variant,
       );

  final SocialLoginProvider provider;
  final VoidCallback onPressed;
  final double height;
  final SocialLoginButtonVariant variant;

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
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

    return Color.lerp(baseColor, AppColor.black, 0.15)!;
  }

  @override
  Widget build(BuildContext context) {
    final style = _SocialLoginButtonStyle.from(widget.provider);
    final isCircle = widget.variant == SocialLoginButtonVariant.circle;

    return Semantics(
      button: true,
      label: style.text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          width: isCircle ? widget.height : double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: _pressedColor(style.backgroundColor),
            borderRadius: BorderRadius.circular(
              isCircle ? AppRadius.pill : AppRadius.sm,
            ),
            border: style.borderColor == null
                ? null
                : Border.all(color: style.borderColor!, width: 1),
          ),
          child: isCircle
              ? Center(child: _SocialLoginIcon(style: style))
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: AppSpacing.x20,
                      child: _SocialLoginIcon(style: style),
                    ),
                    Text(
                      style.text,
                      style: FontStyles.semi16.copyWith(color: style.textColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SocialLoginIcon extends StatelessWidget {
  const _SocialLoginIcon({required this.style});

  final _SocialLoginButtonStyle style;

  @override
  Widget build(BuildContext context) {
    if (style.iconData != null) {
      return Icon(
        style.iconData,
        size: style.iconSize,
        color: style.iconColor,
      );
    }

    return SvgPicture.asset(
      style.iconPath!,
      width: style.iconSize,
      height: style.iconSize,
      fit: BoxFit.contain,
    );
  }
}

class _SocialLoginButtonStyle {
  const _SocialLoginButtonStyle({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.iconPath,
    this.iconData,
    this.iconColor,
    this.borderColor,
    this.iconSize = 24,
  }) : assert(iconPath != null || iconData != null);

  final String text;
  final String? iconPath;
  final IconData? iconData;
  final Color? iconColor;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double iconSize;

  factory _SocialLoginButtonStyle.from(SocialLoginProvider provider) {
    return switch (provider) {
      SocialLoginProvider.naver => const _SocialLoginButtonStyle(
        text: 'Naver로 계속하기',
        iconPath: 'assets/icons/auth/naver_logo.svg',
        backgroundColor: Color(0xFF00C53A),
        textColor: AppColor.white,
        iconSize: 28,
      ),
      SocialLoginProvider.google => const _SocialLoginButtonStyle(
        text: 'Google로 계속하기',
        iconPath: 'assets/icons/auth/google_logo.svg',
        backgroundColor: AppColor.white,
        textColor: AppColor.black,
        borderColor: Color(0xFFE5E5E5),
        iconSize: 24,
      ),
      SocialLoginProvider.kakao => const _SocialLoginButtonStyle(
        text: 'Kakao로 로그인하기',
        iconPath: 'assets/icons/auth/kakao_logo.svg',
        backgroundColor: Color(0xFFFDDC3F),
        textColor: AppColor.black,
        iconSize: 30,
      ),
      SocialLoginProvider.apple => const _SocialLoginButtonStyle(
        text: 'Apple로 로그인하기',
        iconData: Icons.apple,
        iconColor: AppColor.black,
        backgroundColor: AppColor.white,
        textColor: AppColor.black,
        borderColor: Color(0xFFE5E5E5),
        iconSize: 28,
      ),
    };
  }
}
