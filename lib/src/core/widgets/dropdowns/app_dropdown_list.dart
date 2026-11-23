import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppDropdownAlignment { left, right }

typedef AppDropdownTriggerBuilder =
    Widget Function(BuildContext context, MenuController controller);

@immutable
class AppDropdownItem {
  const AppDropdownItem({
    required this.label,
    required this.onPressed,
    this.svgLink,
    this.isSelected = false,
    this.enabled = true,
  });

  /// 드롭다운에 표시할 텍스트
  final String label;

  /// 해당 항목을 눌렀을 때 실행할 동작
  final VoidCallback onPressed;

  final String? svgLink;

  /// 현재 드롭다운에서 선택된 항목인지 여부
  final bool isSelected;

  /// 항목 활성화 여부
  final bool enabled;
}

class AppDropdownList extends StatefulWidget {
  const AppDropdownList({
    super.key,
    required this.items,
    required this.triggerBuilder,
    this.width = 170.0,
    this.anchorWidth,
    this.itemHeight = 44.0,
    this.alignment = AppDropdownAlignment.left,
    this.alignmentOffset = const Offset(0, 20),
    this.showPressedCheck = true,
    this.pressedCheckAsset = 'assets/icons/check/check.svg',
    this.showDividers = true,
    this.useRootOverlay = true,
  }) : assert(
         alignment != AppDropdownAlignment.right || anchorWidth != null,
         'AppDropdownAlignment.right를 사용할 때는 '
         '드롭다운을 여는 버튼의 anchorWidth가 필요합니다.',
       );

  final List<AppDropdownItem> items;
  final AppDropdownTriggerBuilder triggerBuilder;
  final double width;
  final double? anchorWidth;
  final double itemHeight;
  final AppDropdownAlignment alignment;
  final Offset alignmentOffset;
  final bool showPressedCheck;
  final String pressedCheckAsset;
  final bool showDividers;
  final bool useRootOverlay;

  @override
  State<AppDropdownList> createState() => _AppDropdownListState();
}

class _AppDropdownListState extends State<AppDropdownList> {
  final MenuController _menuController = MenuController();

  Offset get _resolvedAlignmentOffset {
    switch (widget.alignment) {
      case AppDropdownAlignment.left:
        return widget.alignmentOffset;

      case AppDropdownAlignment.right:
        final anchorWidth = widget.anchorWidth;

        if (anchorWidth == null) {
          throw StateError(
            'AppDropdownAlignment.right를 사용할 때는 '
            'anchorWidth를 반드시 지정해야 합니다.',
          );
        }

        return Offset(
          anchorWidth - widget.width + widget.alignmentOffset.dx,
          widget.alignmentOffset.dy,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      useRootOverlay: widget.useRootOverlay,
      // 💡 사방 그림자가 잘리지 않도록 Clip.none 설정
      clipBehavior: Clip.none,
      alignmentOffset: _resolvedAlignmentOffset,
      style: const MenuStyle(
        alignment: Alignment.topLeft,
        // 💡 기본 아래쪽 쏠림 그림자와 배경을 투명하게 제거하고 아래 Container에서 직접 스타일링
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        side: WidgetStatePropertyAll(BorderSide.none),
      ),
      menuChildren: [
        Container(
          width: widget.width,
          decoration: BoxDecoration(
            // 1. fill color white (투명도 90%)
            color: Colors.white.withValues(alpha: 0.90),
            borderRadius: BorderRadius.circular(AppRadius.md),
            // 2. 사방으로 고르게 퍼지는 그림자 (Offset.zero)
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 1,
                offset: Offset.zero,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildMenuChildren(),
            ),
          ),
        ),
      ],
      builder: (context, controller, child) {
        return widget.triggerBuilder(context, controller);
      },
    );
  }

  List<Widget> _buildMenuChildren() {
    final children = <Widget>[];

    for (var index = 0; index < widget.items.length; index++) {
      final item = widget.items[index];
      final isLastItem = index == widget.items.length - 1;

      children.add(
        _AppDropdownMenuItem(
          item: item,
          width: widget.width,
          height: widget.itemHeight,
          showPressedCheck: widget.showPressedCheck,
          pressedCheckAsset: widget.pressedCheckAsset,
          onPressed: () {
            _menuController.close();
            item.onPressed();
          },
        ),
      );

      if (widget.showDividers && !isLastItem) {
        children.add(
          SizedBox(
            width: widget.width,
            child: Divider(height: 1, thickness: 1, color: context.grays.gray7),
          ),
        );
      }
    }

    return children;
  }
}

class _AppDropdownMenuItem extends StatefulWidget {
  const _AppDropdownMenuItem({
    required this.item,
    required this.width,
    required this.height,
    required this.showPressedCheck,
    required this.pressedCheckAsset,
    required this.onPressed,
  });

  final AppDropdownItem item;
  final double width;
  final double height;
  final bool showPressedCheck;
  final String pressedCheckAsset;
  final VoidCallback onPressed;

  @override
  State<_AppDropdownMenuItem> createState() => _AppDropdownMenuItemState();
}

class _AppDropdownMenuItemState extends State<_AppDropdownMenuItem> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!widget.item.enabled || _isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.item.enabled
        ? context.grays.black
        : context.grays.gray5;

    return Semantics(
      button: true,
      enabled: widget.item.enabled,
      label: widget.item.label,
      selected: widget.item.isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.item.enabled ? widget.onPressed : null,
          onHighlightChanged: _setPressed,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            width: widget.width,
            height: widget.height,
            // 3. 앞쪽(left) 여백을 좁게 조정 (12px)
            padding: const EdgeInsets.only(
              left: AppSpacing.x12,
              right: AppSpacing.x16,
            ),
            color: _isPressed
                ? context.grays.gray7.withValues(alpha: 0.80)
                : Colors.transparent,
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 120),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      axisAlignment: -1,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child:
                      widget.item.isSelected ||
                          (_isPressed && widget.showPressedCheck)
                      ? Center(
                          child: Padding(
                            key: const ValueKey('pressed-check'),
                            padding: const EdgeInsets.only(
                              right: AppSpacing.x4,
                            ),
                            child: SvgPicture.asset(
                              widget.pressedCheckAsset,
                              colorFilter: ColorFilter.mode(
                                context.grays.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty-check')),
                ),
                // svgLink가 있을 때만 아이콘과 간격(8px) 표시
                if (widget.item.svgLink != null) ...[
                  Center(
                    child: SvgPicture.asset(
                      widget.item.svgLink!,
                      colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                      width: 23,
                      height: 23,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                ],
                Expanded(
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.med16.copyWith(color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
