import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_basic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudFileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CloudFileAppbar({
    super.key,
    required this.titleText,
    this.onLeadingPressed,
    this.onTitlePressed,
    this.onBackPressed,
  });

  final String titleText;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTitlePressed;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(84.0);

  @override
  Widget build(BuildContext context) {
    void _navigateBack() {
      Navigator.of(context).pop();
    }

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: context.grays.white,
      surfaceTintColor: context.grays.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: AppSpacing.x10,
                child: _BackIconButton(
                  icon: 'assets/icons/appbar/back.svg',
                  semanticLabel: '뒤로가기',
                  onPressed: _navigateBack,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110.0),
                child: _CloudFileTitleButton(
                  titleText: titleText,
                  onPressed: onTitlePressed,
                ),
              ),
              Positioned(
                right: AppSpacing.x20,
                child: CloudBasicButton(onPressed: onLeadingPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloudFileTitleButton extends StatelessWidget {
  const _CloudFileTitleButton({
    required this.titleText,
    required this.onPressed,
  });

  final String titleText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      label: onPressed == null ? null : '파일 목록 열기',
      child: MouseRegion(
        cursor: onPressed == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.semi18.copyWith(color: context.grays.black),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/cloud/toggle_down.svg',
                    width: 24.0,
                    height: 24.0,
                    colorFilter: ColorFilter.mode(
                      context.grays.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackIconButton extends StatefulWidget {
  const _BackIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.iconSize = 24.0,
    this.pressedScale = 0.86,
    this.pressInDuration = const Duration(milliseconds: 200),
    this.pressOutDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  final double iconSize;
  final double pressedScale;
  final Duration pressInDuration;
  final Duration pressOutDuration;
  final Curve curve;

  @override
  State<_BackIconButton> createState() => _BackIconButtonState();
}

class _BackIconButtonState extends State<_BackIconButton> {
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
    return Semantics(
      button: true,
      label: widget.semanticLabel,
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
        child: SizedBox(
          width: 60.0,
          height: 60.0,
          child: Center(
            child: AnimatedScale(
              scale: _isPressed ? widget.pressedScale : 1.0,
              duration: _isPressed
                  ? widget.pressInDuration
                  : widget.pressOutDuration,
              curve: widget.curve,
              child: SvgPicture.asset(
                widget.icon,
                width: widget.iconSize,
                height: widget.iconSize,
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
