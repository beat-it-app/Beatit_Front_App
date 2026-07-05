import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_fonts.dart';

enum AppTwoAppBarTrailing { add, search, all }

class AppTwoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTwoAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.trailing = AppTwoAppBarTrailing.add,
    this.onAddPressed,
    this.onSearchPressed,
    this.toolbarHeight = 84,
  });

  const AppTwoAppBar.add({
    super.key,
    required String title,
    VoidCallback? onAddPressed,
    double toolbarHeight = 84,
  }) : title = title,
       showBackButton = true,
       trailing = AppTwoAppBarTrailing.add,
       onAddPressed = onAddPressed,
       onSearchPressed = null,
       toolbarHeight = toolbarHeight;

  const AppTwoAppBar.search({
    super.key,
    VoidCallback? onSearchPressed,
    double toolbarHeight = 84,
  }) : title = null,
       showBackButton = true,
       trailing = AppTwoAppBarTrailing.search,
       onAddPressed = null,
       onSearchPressed = onSearchPressed,
       toolbarHeight = toolbarHeight;

  const AppTwoAppBar.all({
    super.key,
    String? title,
    VoidCallback? onAddPressed,
    VoidCallback? onSearchPressed,
    double toolbarHeight = 84,
  }) : title = title,
       showBackButton = true,
       trailing = AppTwoAppBarTrailing.all,
       onAddPressed = onAddPressed,
       onSearchPressed = onSearchPressed,
       toolbarHeight = toolbarHeight;

  final String? title;
  final bool showBackButton;
  final AppTwoAppBarTrailing trailing;

  final VoidCallback? onAddPressed;
  final VoidCallback? onSearchPressed;

  final double toolbarHeight;

  static void _noop() {}

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: title != null,
      toolbarHeight: toolbarHeight,
      leadingWidth: 60,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: colors.onSurface,
      titleTextStyle: FontStyles.semi18.copyWith(color: colors.onSurface),
      title: title == null ? null : Text(title!),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.x16),
          child: Row(
            children: [
              switch (trailing) {
                AppTwoAppBarTrailing.add => _AppBarPressIconButton(
                  icon: 'assets/icons/appbar/plus.svg',
                  semanticLabel: '추가',
                  onPressed: onAddPressed ?? _noop,
                ),
                AppTwoAppBarTrailing.search => _AppBarPressIconButton(
                  icon: 'assets/icons/appbar/search.svg',
                  semanticLabel: '검색',
                  onPressed: onSearchPressed ?? _noop,
                ),
                AppTwoAppBarTrailing.all => Row(
                  children: [
                    _AppBarPressIconButton(
                      icon: 'assets/icons/appbar/search.svg',
                      semanticLabel: '검색',
                      onPressed: onSearchPressed ?? _noop,
                    ),
                    const SizedBox(width: AppSpacing.x8),
                    _AppBarPressIconButton(
                      icon: 'assets/icons/appbar/plus.svg',
                      semanticLabel: '추가',
                      onPressed: onAddPressed ?? _noop,
                    ),
                  ],
                ),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class _AppBarPressIconButton extends StatefulWidget {
  const _AppBarPressIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.iconSize = 20,
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
  State<_AppBarPressIconButton> createState() => _AppBarPressIconButtonState();
}

class _AppBarPressIconButtonState extends State<_AppBarPressIconButton> {
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
    final colors = Theme.of(context).colorScheme;

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
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: context.grays.gray8,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Center(
            child: AnimatedScale(
              scale: _isPressed ? widget.pressedScale : 1.0,
              duration: _isPressed
                  ? widget.pressInDuration
                  : widget.pressOutDuration,
              curve: widget.curve,
              child: SvgPicture.asset(widget.icon, color: context.grays.gray5),
            ),
          ),
        ),
      ),
    );
  }
}
