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
    this.moreMenuItems = const [],
    this.moreMenuAlignment = AppDropdownAlignment.right,
    this.moreMenuWidth = 170.0,
    this.moreMenuItemHeight = 44.0,
    this.moreMenuOffset = const Offset(0, 56),
    this.toolbarHeight = 64.0,
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
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.backOnly({
    super.key,
    VoidCallback? onBackPressed,
    double toolbarHeight = 64.0,
  }) : title = null,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.none,
       onBackPressed = onBackPressed,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = null,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.backMore({
    super.key,
    String? title,
    VoidCallback? onMorePressed,
    this.moreMenuItems = const [],
    this.moreMenuAlignment = AppDropdownAlignment.right,
    this.moreMenuWidth = 170.0,
    this.moreMenuItemHeight = 44.0,
    this.moreMenuOffset = const Offset(0, 56),
    double toolbarHeight = 64.0,
  }) : title = title,
       showBackButton = true,
       trailing = AppTopAppBarTrailing.more,
       onBackPressed = null,
       onMorePressed = onMorePressed,
       onClosePressed = null,
       onAlarmPressed = null,
       toolbarHeight = toolbarHeight;

  const AppTopAppBar.closeOnly({
    super.key,
    VoidCallback? onClosePressed,
    double toolbarHeight = 64.0,
  }) : title = null,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.close,
       onBackPressed = null,
       onMorePressed = null,
       onClosePressed = onClosePressed,
       onAlarmPressed = null,
       moreMenuItems = const [],
       moreMenuAlignment = AppDropdownAlignment.right,
       moreMenuWidth = 170.0,
       moreMenuItemHeight = 44.0,
       moreMenuOffset = const Offset(0, 56),
       toolbarHeight = toolbarHeight;

  /// 우측 trailing 영역에 알림 버튼 하나만 표시한다.
  const AppTopAppBar.alarmOnly({
    super.key,
    VoidCallback? onAlarmPressed,
    double toolbarHeight = 64.0,
  }) : title = null,
       showBackButton = false,
       trailing = AppTopAppBarTrailing.alarm,
       onBackPressed = null,
       onMorePressed = null,
       onClosePressed = null,
       onAlarmPressed = onAlarmPressed,
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

  /// [moreMenuItems]가 비어 있을 때 더보기 버튼이 직접 실행할 콜백
  final VoidCallback? onMorePressed;

  final VoidCallback? onClosePressed;
  final VoidCallback? onAlarmPressed;

  /// 더보기 버튼을 눌렀을 때 표시할 드롭다운 항목
  ///
  /// 비어 있으면 드롭다운을 표시하지 않고 [onMorePressed]를 실행한다.
  final List<AppDropdownItem> moreMenuItems;

  /// 드롭다운의 왼쪽 또는 오른쪽 정렬
  final AppDropdownAlignment moreMenuAlignment;

  /// 드롭다운 너비
  final double moreMenuWidth;

  /// 드롭다운 항목 하나의 높이
  final double moreMenuItemHeight;

  /// 정렬된 위치를 기준으로 한 추가 이동값
  ///
  /// 예:
  /// `Offset(-16, 56)`
  /// - 오른쪽 정렬 위치에서 왼쪽으로 16px
  /// - 버튼 상단 기준 아래로 56px
  final Offset moreMenuOffset;

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
      leadingWidth: _appBarActionButtonWidth,
      elevation: 0,
      scrolledUnderElevation: 0,

      // 💡 [수정] AppTopAppBar.alarmOnly 대신 trailing 변수를 검사합니다.
      backgroundColor: (trailing == AppTopAppBarTrailing.alarm)
          ? Colors.transparent
          : theme.scaffoldBackgroundColor,

      // 💡 Material3 스크롤 시 틴트 색상 오버레이 방지 (필수)
      surfaceTintColor: (trailing == AppTopAppBarTrailing.alarm)
          ? Colors.transparent
          : null,

      foregroundColor: colors.onSurface,
      titleTextStyle: FontStyles.semi18.copyWith(color: colors.onSurface),
      leading: showBackButton
          ? _AppBarPressIconButton(
              icon: 'assets/icons/appbar/back.svg',
              semanticLabel: '뒤로가기',
              onPressed: onBackPressed ?? _noop,
            )
          : null,
      title: title == null ? null : Text(title!),
      actions: [
        switch (trailing) {
          AppTopAppBarTrailing.none => const SizedBox.shrink(),
          AppTopAppBarTrailing.more => _buildMoreAction(),
          AppTopAppBarTrailing.close => _AppBarPressIconButton(
            icon: 'assets/icons/appbar/delete.svg',
            semanticLabel: '닫기',
            onPressed: onClosePressed ?? _noop,
          ),
          AppTopAppBarTrailing.alarm => _AppBarPressIconButton(
            icon: 'assets/icons/appbar/bell.svg',
            semanticLabel: '알림',
            iconColor: Colors.white,
            onPressed: onAlarmPressed ?? _noop,
          ),
        },
      ],
    );
  }

  Widget _buildMoreAction() {
    // 메뉴 항목이 없는 화면에서는 기존처럼 콜백만 실행한다.
    if (moreMenuItems.isEmpty) {
      return _AppBarPressIconButton(
        icon: 'assets/icons/appbar/menu.svg',
        semanticLabel: '더보기',
        onPressed: onMorePressed ?? _noop,
      );
    }

    // 메뉴 항목이 있으면 더보기 버튼이 드롭다운을 연다.
    return AppDropdownList(
      items: moreMenuItems,
      width: moreMenuWidth,

      // 더보기 버튼의 실제 너비와 동일해야 한다.
      anchorWidth: _appBarActionButtonWidth,

      itemHeight: moreMenuItemHeight,
      alignment: moreMenuAlignment,
      alignmentOffset: moreMenuOffset,
      triggerBuilder: (context, controller) {
        return _AppBarPressIconButton(
          icon: 'assets/icons/appbar/menu.svg',
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
