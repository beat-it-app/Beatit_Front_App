import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

enum SocialLoginProvider { naver, google, kakao }

class SocialLoginButton extends StatefulWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.height = 60,
  });

  const SocialLoginButton.naver({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
  }) : this(
         key: key,
         provider: SocialLoginProvider.naver,
         onPressed: onPressed,
         height: height,
       );

  const SocialLoginButton.google({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
  }) : this(
         key: key,
         provider: SocialLoginProvider.google,
         onPressed: onPressed,
         height: height,
       );

  const SocialLoginButton.kakao({
    Key? key,
    required VoidCallback onPressed,
    double height = 60,
  }) : this(
         key: key,
         provider: SocialLoginProvider.kakao,
         onPressed: onPressed,
         height: height,
       );

  final SocialLoginProvider provider;
  final VoidCallback onPressed;
  final double height;

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

    // 누르는 동안 아주 살짝 어둡게
    return Color.lerp(baseColor, Colors.black, 0.15)!;
  }

  @override
  Widget build(BuildContext context) {
    final style = _SocialLoginButtonStyle.from(widget.provider);

    return Semantics(
      button: true,
      label: style.text,
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
          height: widget.height,
          decoration: BoxDecoration(
            color: _pressedColor(style.backgroundColor),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: style.borderColor == null
                ? null
                : Border.all(color: style.borderColor!, width: 1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: AppSpacing.x20,
                child: SvgPicture.asset(
                  style.iconPath,
                  width: style.iconSize,
                  height: style.iconSize,
                  fit: BoxFit.contain,
                ),
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

class _SocialLoginButtonStyle {
  const _SocialLoginButtonStyle({
    required this.text,
    required this.iconPath,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.iconSize = 24,
  });

  final String text;
  final String iconPath;
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
    };
  }
}
