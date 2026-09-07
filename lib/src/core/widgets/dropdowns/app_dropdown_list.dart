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
    this.enabled = true,
  });

  /// 드롭다운에 표시할 텍스트
  final String label;

  /// 해당 항목을 눌렀을 때 실행할 동작
  final VoidCallback onPressed;

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

  /// 메뉴 항목
  ///
  /// 전달된 항목 개수만큼 자동으로 표시된다.
  final List<AppDropdownItem> items;

  /// 메뉴를 여는 버튼
  final AppDropdownTriggerBuilder triggerBuilder;

  /// 드롭다운 메뉴 너비
  final double width;

  /// 드롭다운을 여는 기준 버튼의 너비
  ///
  /// [alignment]가 [AppDropdownAlignment.right]일 때
  /// 메뉴의 오른쪽 끝을 버튼의 오른쪽 끝에 맞추기 위해 사용한다.
  ///
  /// 예:
  /// AppBar 버튼 너비가 60이라면 `anchorWidth: 60`
  final double? anchorWidth;

  /// 각 메뉴 항목의 높이
  final double itemHeight;

  /// 버튼을 기준으로 한 메뉴 정렬 방향
  final AppDropdownAlignment alignment;

  /// 정렬된 기본 위치로부터 추가로 이동할 거리
  ///
  /// 왼쪽 정렬:
  /// - dx가 음수이면 왼쪽 이동
  /// - dx가 양수이면 오른쪽 이동
  ///
  /// 오른쪽 정렬:
  /// - dx가 음수이면 오른쪽 정렬 지점에서 왼쪽 이동
  /// - dx가 양수이면 오른쪽 정렬 지점에서 오른쪽 이동
  ///
  /// 공통:
  /// - dy가 양수이면 아래 이동
  /// - dy가 음수이면 위 이동
  final Offset alignmentOffset;

  /// 항목을 누르고 있을 때 체크 아이콘 표시 여부
  final bool showPressedCheck;

  /// 눌림 상태에서 표시할 체크 아이콘
  final String pressedCheckAsset;

  /// 항목 사이 Divider 표시 여부
  final bool showDividers;

  /// 부모 위젯의 Clip에 메뉴가 잘리지 않도록
  /// 최상위 Overlay를 사용할지 여부
  final bool useRootOverlay;

  @override
  State<AppDropdownList> createState() => _AppDropdownListState();
}

class _AppDropdownListState extends State<AppDropdownList> {
  final MenuController _menuController = MenuController();

  /// 실제 MenuAnchor에 전달할 위치를 계산한다.
  ///
  /// Flutter의 오른쪽 정렬에서는 가로 alignmentOffset이 기대한 대로
  /// 적용되지 않을 수 있으므로, 항상 왼쪽 기준으로 배치한 후
  /// 오른쪽 정렬 좌표를 직접 계산한다.
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

      // 첫 번째와 마지막 항목의 눌림 배경이
      // 메뉴 바깥으로 튀어나오지 않도록 자른다.
      clipBehavior: Clip.antiAlias,

      // 오른쪽 정렬을 포함해 직접 계산된 offset을 사용한다.
      alignmentOffset: _resolvedAlignmentOffset,

      style: MenuStyle(
        // 오른쪽 정렬도 실제로는 왼쪽 기준에서 직접 계산한다.
        // 그래야 alignmentOffset.dx가 정상적으로 반영된다.
        alignment: Alignment.topLeft,

        // 메뉴 너비 고정
        minimumSize: WidgetStatePropertyAll(Size(widget.width, 0)),
        maximumSize: WidgetStatePropertyAll(
          Size(widget.width, double.infinity),
        ),

        backgroundColor: WidgetStatePropertyAll(
          context.grays.white.withValues(alpha: 0.95),
        ),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(
          context.grays.black.withValues(alpha: 0.2),
        ),
        elevation: const WidgetStatePropertyAll(5),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        side: const WidgetStatePropertyAll(BorderSide.none),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      menuChildren: _buildMenuChildren(),

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.item.enabled ? widget.onPressed : null,

          // 손가락으로 누르고 있는 동안에만 true가 된다.
          onHighlightChanged: _setPressed,

          // 기본 InkWell splash와 overlay를 제거하고
          // AnimatedContainer로 눌림 상태를 직접 표현한다.
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
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
                  child: _isPressed && widget.showPressedCheck
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
