import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectFloatButton extends StatelessWidget {
  const SelectFloatButton({
    super.key,
    required this.isVisible,
    required this.onDeletePressed,
    required this.onMovePressed,
    required this.onDownloadPressed,
    required this.onConfirmPressed,
    this.isEnabled = true,
  });

  final bool isVisible;

  /// 선택된 항목이 하나라도 있을 때만 true로 전달한다.
  final bool isEnabled;

  final VoidCallback onDeletePressed;
  final VoidCallback onMovePressed;
  final VoidCallback onDownloadPressed;
  final VoidCallback onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 220);

    return ExcludeSemantics(
      excluding: !isVisible,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedSlide(
          offset: isVisible ? Offset.zero : const Offset(0, 0.15),
          duration: animationDuration,
          curve: isVisible ? Curves.easeOutCubic : Curves.easeInCubic,
          child: AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: animationDuration,
            curve: isVisible ? Curves.easeOutCubic : Curves.easeInCubic,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width - (AppSpacing.x16 * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CloudSelectionFloatingBar(
                      isEnabled: isEnabled,
                      onDeletePressed: onDeletePressed,
                      onMovePressed: onMovePressed,
                      onDownloadPressed: onDownloadPressed,
                    ),
                    _CloudConfirmFloatingButton(onPressed: onConfirmPressed),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CloudSelectionFloatingBar extends StatelessWidget {
  const CloudSelectionFloatingBar({
    super.key,
    required this.isEnabled,
    required this.onDeletePressed,
    required this.onMovePressed,
    required this.onDownloadPressed,
  });

  final bool isEnabled;
  final VoidCallback onDeletePressed;
  final VoidCallback onMovePressed;
  final VoidCallback onDownloadPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190.0,
      height: 66.0,
      decoration: BoxDecoration(
        color: context.grays.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: context.grays.gray7.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: context.grays.black.withValues(alpha: 0.01),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CloudFloatingIconButton(
              semanticLabel: '선택한 항목 삭제',
              iconPath: 'assets/icons/cloud/del.svg',
              isEnabled: isEnabled,
              onPressed: onDeletePressed,
            ),
            const SizedBox(width: AppSpacing.x8),
            _CloudFloatingIconButton(
              semanticLabel: '선택한 항목 이동',
              iconPath: 'assets/icons/cloud/move.svg',
              isEnabled: isEnabled,
              onPressed: onMovePressed,
            ),
            const SizedBox(width: AppSpacing.x8),
            _CloudFloatingIconButton(
              semanticLabel: '선택한 항목 다운로드',
              iconPath: 'assets/icons/cloud/download.svg',
              isEnabled: isEnabled,
              onPressed: onDownloadPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudFloatingIconButton extends StatefulWidget {
  const _CloudFloatingIconButton({
    required this.semanticLabel,
    required this.iconPath,
    required this.isEnabled,
    required this.onPressed,
  });

  final String semanticLabel;
  final String iconPath;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  State<_CloudFloatingIconButton> createState() =>
      _CloudFloatingIconButtonState();
}

class _CloudFloatingIconButtonState extends State<_CloudFloatingIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _setHovered(bool value) {
    if (_isHovered == value) {
      return;
    }

    setState(() {
      _isHovered = value;
    });
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
    final isActive = widget.isEnabled && (_isHovered || _isPressed);
    final backgroundColor = !widget.isEnabled
        ? context.grays.gray7.withValues(alpha: 0.4)
        : isActive
        ? context.grays.gray7.withValues(alpha: 0.9)
        : context.grays.white.withValues(alpha: 0.0);
    final iconColor = widget.isEnabled
        ? context.grays.gray1
        : context.grays.gray4;

    return Semantics(
      button: true,
      enabled: widget.isEnabled,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: widget.isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: widget.isEnabled ? (_) => _setHovered(true) : null,
        onExit: widget.isEnabled ? (_) => _setHovered(false) : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.isEnabled ? (_) => _setPressed(true) : null,
          onTapUp: widget.isEnabled ? (_) => _setPressed(false) : null,
          onTapCancel: widget.isEnabled ? () => _setPressed(false) : null,
          onTap: widget.isEnabled ? widget.onPressed : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: SvgPicture.asset(
                widget.iconPath,
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloudConfirmFloatingButton extends StatefulWidget {
  const _CloudConfirmFloatingButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_CloudConfirmFloatingButton> createState() =>
      _CloudConfirmFloatingButtonState();
}

class _CloudConfirmFloatingButtonState
    extends State<_CloudConfirmFloatingButton> {
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
    final defaultColor = context.brands.beatOrange1.withValues(alpha: 0.9);

    final pressedColor = Color.alphaBlend(
      context.grays.black.withValues(alpha: 0.12),
      defaultColor,
    );

    return Semantics(
      button: true,
      label: '선택 완료',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            width: 76.0,
            height: 58.0,
            decoration: BoxDecoration(
              color: _isPressed ? pressedColor : defaultColor,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                  color: context.grays.black.withValues(alpha: 0.1),
                  blurRadius: 16.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/check/check.svg',
                width: 24.0,
                height: 24.0,
                colorFilter: ColorFilter.mode(
                  context.grays.white,
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
