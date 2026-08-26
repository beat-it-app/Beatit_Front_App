import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppTwoAppBarTrailing { add, search, all }

class AppTwoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTwoAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.trailing = AppTwoAppBarTrailing.add,
    this.onAddPressed,
    this.onSearchPressed,
    this.addMenuItems = const [],
    this.addMenuAlignment = AppDropdownAlignment.right,
    this.addMenuWidth = 170,
    this.addMenuItemHeight = 44,
    this.addMenuOffset = const Offset(0, 8),
    this.toolbarHeight = 84,
  });

  const AppTwoAppBar.add({
    super.key,
    required String title,
    VoidCallback? onAddPressed,
    this.addMenuItems = const [],
    this.addMenuAlignment = AppDropdownAlignment.right,
    this.addMenuWidth = 170,
    this.addMenuItemHeight = 44,
    this.addMenuOffset = const Offset(0, 8),
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
       addMenuItems = const [],
       addMenuAlignment = AppDropdownAlignment.right,
       addMenuWidth = 170,
       addMenuItemHeight = 44,
       addMenuOffset = const Offset(0, 8),
       toolbarHeight = toolbarHeight;

  const AppTwoAppBar.all({
    super.key,
    String? title,
    VoidCallback? onAddPressed,
    VoidCallback? onSearchPressed,
    this.addMenuItems = const [],
    this.addMenuAlignment = AppDropdownAlignment.right,
    this.addMenuWidth = 170,
    this.addMenuItemHeight = 44,
    this.addMenuOffset = const Offset(0, 8),
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

  /// 메뉴 항목이 없을 때 + 버튼이 직접 실행할 콜백
  final VoidCallback? onAddPressed;

  final VoidCallback? onSearchPressed;

  /// + 버튼을 눌렀을 때 표시할 메뉴
  ///
  /// 빈 리스트이면 드롭다운을 표시하지 않고 onAddPressed를 실행한다.
  final List<AppDropdownItem> addMenuItems;

  final AppDropdownAlignment addMenuAlignment;
  final double addMenuWidth;
  final double addMenuItemHeight;
  final Offset addMenuOffset;

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
          child: switch (trailing) {
            AppTwoAppBarTrailing.add => _buildAddAction(),
            AppTwoAppBarTrailing.search => _buildSearchAction(),
            AppTwoAppBarTrailing.all => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchAction(),
                const SizedBox(width: AppSpacing.x8),
                _buildAddAction(),
              ],
            ),
          },
        ),
      ],
    );
  }

  Widget _buildSearchAction() {
    return _AppBarPressIconButton(
      icon: 'assets/icons/appbar/search.svg',
      semanticLabel: '검색',
      onPressed: onSearchPressed ?? _noop,
    );
  }

  Widget _buildAddAction() {
    // 메뉴 항목이 없는 화면에서는 기존처럼 + 버튼 콜백을 직접 실행한다.
    if (addMenuItems.isEmpty) {
      return _AppBarPressIconButton(
        icon: 'assets/icons/appbar/plus.svg',
        semanticLabel: '추가',
        onPressed: onAddPressed ?? _noop,
      );
    }

    // 메뉴 항목이 존재하는 화면에서는 + 버튼이 드롭다운을 연다.
    return AppDropdownList(
      width: addMenuWidth,
      itemHeight: addMenuItemHeight,
      alignment: addMenuAlignment,
      alignmentOffset: addMenuOffset,
      anchorWidth: 60,
      items: addMenuItems,
      triggerBuilder: (context, controller) {
        return _AppBarPressIconButton(
          icon: 'assets/icons/appbar/plus.svg',
          semanticLabel: '추가 메뉴',
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
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
              child: SvgPicture.asset(
                widget.icon,
                width: widget.iconSize,
                height: widget.iconSize,
                colorFilter: ColorFilter.mode(
                  context.grays.gray5,
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
