// lib/src/core/widgets/appbars/app_top_appbar.dart

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppTopAppBarTrailing { none, more, close, alarm }

const double _appBarActionButtonWidth = 60.0;
const double _appBarActionButtonHeight = 48.0;

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
    this.onEditPressed,
    this.onSharePressed,
    this.unreadNotificationCount = 0,
    this.moreMenuItems = const [],
    this.moreMenuAlignment = AppDropdownAlignment.right,
    this.moreMenuWidth = 170.0,
    this.moreMenuItemHeight = 44.0,
    this.moreMenuOffset = const Offset(0, 56),
    this.toolbarHeight = 64.0,
    this.actionIconColor,
  });

  const AppTopAppBar.backTitle({
    super.key,
    required String title,
    VoidCallback? onBackPressed,
    double toolbarHeight = 64.0,
  }) : title = title,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.none,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = null,
       onEditPressed = null,
       onSharePressed = null,
       unreadNotificationCount = 0,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight,
       actionIconColor = null;

  const AppTopAppBar.backOnly({
    super.key,
    VoidCallback? onBackPressed,
    double toolbarHeight = 64.0,
    this.actionIconColor,
  }) : title = null,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.none,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = null,
       onEditPressed = null,
       onSharePressed = null,
       unreadNotificationCount = 0,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight;

  // 💡 [추가] 뒤로가기 버튼(왼쪽) + 닫기(X) 버튼(오른쪽)을 동시에 제공하는 생성자
  const AppTopAppBar.backClose({
    super.key,
    String? title,
    VoidCallback? onBackPressed,
    VoidCallback? onClosePressed,
    double toolbarHeight = 64.0,
    this.actionIconColor,
  }) : title = title,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.close,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = onClosePressed,
       onAlarmPressed = null,
       onEditPressed = null,
       onSharePressed = null,
       unreadNotificationCount = 0,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.moreOnly({
    super.key,
    String? title,
    VoidCallback? onMorePressed,
    VoidCallback? onBackPressed,
    this.moreMenuItems = const [],
    this.moreMenuAlignment = AppDropdownAlignment.right,
    this.moreMenuWidth = 170.0,
    this.moreMenuItemHeight = 44.0,
    this.moreMenuOffset = const Offset(0, 56),
    double toolbarHeight = 64.0,
  }) : title = title,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.more,
       onBackPressed = onBackPressed,
       onMorePressed = onMorePressed,
       onClosePressed = null,
       onEditPressed = null,
       onSharePressed = null,
       onAlarmPressed = null,
       unreadNotificationCount = 0,
       toolbarHeight = toolbarHeight,
       actionIconColor = null;

  const AppTopAppBar.backMore({
    super.key,
    String? title,
    VoidCallback? onMorePressed,
    VoidCallback? onBackPressed,
    this.moreMenuItems = const [],
    this.moreMenuAlignment = AppDropdownAlignment.right,
    this.moreMenuWidth = 170.0,
    this.moreMenuItemHeight = 44.0,
    this.moreMenuOffset = const Offset(0, 56),
    double toolbarHeight = 64.0,
    this.actionIconColor,
  }) : title = title,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.more,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = null,
       onEditPressed = null,
       onSharePressed = null,
       unreadNotificationCount = 0,
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.closeOnly({
    super.key,
    String? title,
    VoidCallback? onClosePressed,
    double toolbarHeight = 64.0,
  }) : title = title,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.close,
       onBackPressed = null,
       onMorePressed = null,
       onClosePressed = onClosePressed,
       onAlarmPressed = null,
       onEditPressed = null,
       onSharePressed = null,
       unreadNotificationCount = 0,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight,
       actionIconColor = null;

  const AppTopAppBar.alarmOnly({
    super.key,
    VoidCallback? onAlarmPressed,
    VoidCallback? onEditPressed,
    VoidCallback? onSharePressed,
    this.unreadNotificationCount = 0,
    double toolbarHeight = 64.0,
    this.actionIconColor,
  }) : title = null,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.alarm,
       onBackPressed = null,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = onAlarmPressed,
       onEditPressed = onEditPressed,
       onSharePressed = onSharePressed,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight;

  final String? title;
  final bool showBackButton;
  final AppTopAppBarTrailing trailing;

  final VoidCallback? onBackPressed;
  final VoidCallback? onMorePressed;
  final VoidCallback? onClosePressed;
  final VoidCallback? onAlarmPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSharePressed;
  final int unreadNotificationCount;

  final List<AppDropdownItem> moreMenuItems;
  final AppDropdownAlignment moreMenuAlignment;
  final double moreMenuWidth;
  final double moreMenuItemHeight;
  final Offset moreMenuOffset;

  final double toolbarHeight;
  final Color? actionIconColor;

  static void _noop() {}

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final effectiveAlarmActionColor = actionIconColor ?? Colors.white;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: title != null,
      toolbarHeight: toolbarHeight,
      leadingWidth: _appBarActionButtonWidth,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: (trailing == AppTopAppBarTrailing.alarm)
          ? Colors.transparent
          : theme.scaffoldBackgroundColor,
      surfaceTintColor: (trailing == AppTopAppBarTrailing.alarm)
          ? Colors.transparent
          : null,
      foregroundColor: colors.onSurface,
      titleTextStyle: FontStyles.semi18.copyWith(color: colors.onSurface),
      leading: showBackButton
          ? _AppBarPressIconButton(
              icon: 'assets/icons/appbar/back.svg',
              iconColor: actionIconColor,
              semanticLabel: '뒤로가기',
              onPressed: onBackPressed ?? _noop,
            )
          : null,
      title: title == null
          ? null
          : Text(
              title!,
              style: FontStyles.semi18.copyWith(color: colors.onSurface),
            ),
      actions: [
        switch (trailing) {
          AppTopAppBarTrailing.none => const SizedBox.shrink(),
          AppTopAppBarTrailing.more => _buildMoreAction(),
          AppTopAppBarTrailing.close => _AppBarPressIconButton(
            icon: 'assets/icons/appbar/delete.svg',
            semanticLabel: '닫기',
            onPressed: onClosePressed ?? _noop,
          ),
          AppTopAppBarTrailing.alarm => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEditPressed != null) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onEditPressed,
                  child: SvgPicture.asset(
                    'assets/icons/team/edit.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      effectiveAlarmActionColor,
                      BlendMode.srcATop,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
              if (onSharePressed != null) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onSharePressed,
                  child: SvgPicture.asset(
                    'assets/icons/team/share.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      effectiveAlarmActionColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onAlarmPressed ?? _noop,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/appbar/bell.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        effectiveAlarmActionColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    if (unreadNotificationCount > 0)
                      Positioned(
                        top: -4,
                        right: -5,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: unreadNotificationCount < 10
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                            borderRadius: unreadNotificationCount >= 10
                                ? BorderRadius.circular(10)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            unreadNotificationCount > 99
                                ? '99+'
                                : '$unreadNotificationCount',
                            style: FontStyles.semi10.copyWith(
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        },
      ],
    );
  }

  Widget _buildMoreAction() {
    if (moreMenuItems.isEmpty) {
      return _AppBarPressIconButton(
        icon: 'assets/icons/appbar/menu.svg',
        iconColor: actionIconColor,
        semanticLabel: '더보기',
        onPressed: onMorePressed ?? _noop,
      );
    }

    return AppDropdownList(
      items: moreMenuItems,
      width: moreMenuWidth,
      anchorWidth: _appBarActionButtonWidth,
      itemHeight: moreMenuItemHeight,
      alignment: moreMenuAlignment,
      alignmentOffset: moreMenuOffset,
      triggerBuilder: (context, controller) {
        return _AppBarPressIconButton(
          icon: 'assets/icons/appbar/menu.svg',
          iconColor: actionIconColor,
          semanticLabel: '더보기 메뉴',
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
              return;
            }

            controller.open();
          },
        );
      },
    );
  }
}

class _AppBarPressIconButton extends StatefulWidget {
  const _AppBarPressIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.iconSize = 20.0,
    this.iconColor,
    this.pressedScale = 0.86,
    this.pressInDuration = const Duration(milliseconds: 200),
    this.pressOutDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
  });

  final String icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  final double iconSize;
  final Color? iconColor;
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
          width: _appBarActionButtonWidth,
          height: _appBarActionButtonHeight,
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
                  widget.iconColor ?? context.grays.black,
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
