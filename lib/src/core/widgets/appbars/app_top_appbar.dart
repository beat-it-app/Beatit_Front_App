import 'package:flutter/material.dart';

import '../../theme/app_fonts.dart';

enum AppTopAppBarTrailing { none, more, close, alarm }

class AppTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.trailing = AppTopAppBarTrailing.none,
    this.onBackPressed,
    this.onMorePressed,
    this.onClosePressed,
    this.onAlarmPressed,
    this.toolbarHeight = 64,
  });

  const AppTopAppBar.backTitle({
    super.key,
    required String title,
    VoidCallback? onBackPressed,
    double toolbarHeight = 64,
  }) : title = title,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.none,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = null,
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.backOnly({
    super.key,
    VoidCallback? onBackPressed,
    double toolbarHeight = 64,
  }) : title = null,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.none,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = null,
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.backMore({
    super.key,
    String? title,
    VoidCallback? onBackPressed,
    VoidCallback? onMorePressed,
    double toolbarHeight = 64,
  }) : title = title,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.more,
       onBackPressed = onBackPressed,
       onMorePressed = onMorePressed,
       onClosePressed = null,
       onAlarmPressed = null,
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.closeOnly({
    super.key,
    VoidCallback? onClosePressed,
    double toolbarHeight = 64,
  }) : title = null,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.close,
       onBackPressed = null,
       onMorePressed = null,
       onClosePressed = onClosePressed,
       onAlarmPressed = null,
       toolbarHeight = toolbarHeight;

  /// 우측 trailing 영역에 벨 버튼 하나만 있는 앱바
  const AppTopAppBar.alarmOnly({
    super.key,
    VoidCallback? onAlarmPressed,
    double toolbarHeight = 64,
  }) : title = null,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.alarm,
       onBackPressed = null,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = onAlarmPressed,
       toolbarHeight = toolbarHeight;

  final String? title;
  final bool showBackButton;
  final AppTopAppBarTrailing trailing;

  final VoidCallback? onBackPressed;
  final VoidCallback? onMorePressed;
  final VoidCallback? onClosePressed;
  final VoidCallback? onAlarmPressed;

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
      leading: showBackButton
          ? _AppBarPressIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              semanticLabel: '뒤로가기',
              onPressed: onBackPressed ?? _noop,
            )
          : null,
      title: title == null ? null : Text(title!),
      actions: [
        switch (trailing) {
          AppTopAppBarTrailing.none => const SizedBox.shrink(),
          AppTopAppBarTrailing.more => _AppBarPressIconButton(
            icon: Icons.more_vert_rounded,
            semanticLabel: '더보기',
            onPressed: onMorePressed ?? _noop,
          ),
          AppTopAppBarTrailing.close => _AppBarPressIconButton(
            icon: Icons.close_rounded,
            semanticLabel: '닫기',
            onPressed: onClosePressed ?? _noop,
          ),
          AppTopAppBarTrailing.alarm => _AppBarPressIconButton(
            icon: Icons.notifications_none_rounded,
            semanticLabel: '알림',
            onPressed: onAlarmPressed ?? _noop,
          ),
        },
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

  final IconData icon;
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
        child: SizedBox(
          width: 60,
          height: 48,
          child: Center(
            child: AnimatedScale(
              scale: _isPressed ? widget.pressedScale : 1.0,
              duration: _isPressed
                  ? widget.pressInDuration
                  : widget.pressOutDuration,
              curve: widget.curve,
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
