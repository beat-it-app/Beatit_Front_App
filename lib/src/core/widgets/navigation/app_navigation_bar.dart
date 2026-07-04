import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class AppNavigationItem {
  const AppNavigationItem({
    required this.iconPath,
    required this.label,
    this.selectedIconPath,
  });

  final String iconPath;
  final String label;
  final String? selectedIconPath;
}

const List<AppNavigationItem> defaultAppNavigationItems = [
  AppNavigationItem(iconPath: 'assets/icons/navigation/home.svg', label: '홈'),
  AppNavigationItem(
    iconPath: 'assets/icons/navigation/notice.svg',
    label: '문서',
  ),
  AppNavigationItem(
    iconPath: 'assets/icons/navigation/calendar.svg',
    label: '일정',
  ),
  AppNavigationItem(iconPath: 'assets/icons/navigation/chat.svg', label: '채팅'),
  AppNavigationItem(
    iconPath: 'assets/icons/navigation/mypage.svg',
    label: '마이페이지',
  ),
];

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultAppNavigationItems,
    this.height = 58,
    this.iconSize = 24,

    this.pressedScale = 0.90,
    this.pressInDuration = const Duration(milliseconds: 200),
    this.pressOutDuration = const Duration(milliseconds: 400),
    this.pressCurve = Curves.easeOutCubic,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppNavigationItem> items;

  final double height;
  final double iconSize;

  final double pressedScale;
  final Duration pressInDuration;
  final Duration pressOutDuration;
  final Curve pressCurve;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final safeCurrentIndex = _safeCurrentIndex;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.gray1,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x12,
              vertical: AppSpacing.x16,
            ),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = safeCurrentIndex == index;

                return Expanded(
                  child: _NavigationIconButton(
                    item: item,
                    isSelected: isSelected,
                    iconSize: iconSize,
                    activeColor: colors.primary,
                    inactiveColor: AppColor.white,
                    pressedScale: pressedScale,
                    pressInDuration: pressInDuration,
                    pressOutDuration: pressOutDuration,
                    pressCurve: pressCurve,
                    onTap: () => onTap(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  int get _safeCurrentIndex {
    if (items.isEmpty) {
      return 0;
    }

    if (currentIndex < 0) {
      return 0;
    }

    if (currentIndex >= items.length) {
      return items.length - 1;
    }

    return currentIndex;
  }
}

class _NavigationIconButton extends StatefulWidget {
  const _NavigationIconButton({
    required this.item,
    required this.isSelected,
    required this.iconSize,
    required this.activeColor,
    required this.inactiveColor,
    required this.pressedScale,
    required this.pressInDuration,
    required this.pressOutDuration,
    required this.pressCurve,
    required this.onTap,
  });

  final AppNavigationItem item;
  final bool isSelected;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;
  final double pressedScale;
  final Duration pressInDuration;
  final Duration pressOutDuration;
  final Curve pressCurve;
  final VoidCallback onTap;

  @override
  State<_NavigationIconButton> createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<_NavigationIconButton> {
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
    final iconPath = widget.isSelected && widget.item.selectedIconPath != null
        ? widget.item.selectedIconPath!
        : widget.item.iconPath;

    final iconColor = widget.isSelected
        ? widget.activeColor
        : widget.inactiveColor;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.item.label,
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
        onTap: widget.onTap,

        child: Center(
          child: AnimatedScale(
            scale: _isPressed ? widget.pressedScale : 1.0,
            duration: _isPressed
                ? widget.pressInDuration
                : widget.pressOutDuration,
            curve: widget.pressCurve,
            child: SvgPicture.asset(
              iconPath,
              width: widget.iconSize,
              height: widget.iconSize,
              semanticsLabel: widget.item.label,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
