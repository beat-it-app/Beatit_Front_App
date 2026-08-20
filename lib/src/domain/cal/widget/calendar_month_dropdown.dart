import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef CalendarMonthDropdownTriggerBuilder =
    Widget Function(BuildContext context, MenuController controller);

class CalendarMonthDropdown extends StatefulWidget {
  const CalendarMonthDropdown({
    super.key,
    required this.selectedMonth,
    required this.firstMonth,
    required this.lastMonth,
    required this.onMonthSelected,
    required this.triggerBuilder,
    this.width = 170,
    this.itemExtent = 44,
    this.alignmentOffset = const Offset(0, 52),
  });

  /// 현재 선택된 월
  final DateTime selectedMonth;

  /// 선택 가능한 첫 번째 월
  final DateTime firstMonth;

  /// 선택 가능한 마지막 월
  final DateTime lastMonth;

  /// 드래그 또는 항목 선택으로 월이 변경되었을 때 호출
  final ValueChanged<DateTime> onMonthSelected;

  /// 드롭다운을 여는 월 헤더
  final CalendarMonthDropdownTriggerBuilder triggerBuilder;

  final double width;
  final double itemExtent;
  final Offset alignmentOffset;

  @override
  State<CalendarMonthDropdown> createState() => _CalendarMonthDropdownState();
}

class _CalendarMonthDropdownState extends State<CalendarMonthDropdown> {
  final MenuController _menuController = MenuController();

  late FixedExtentScrollController _scrollController;
  late int _selectedIndex;

  int get _monthCount {
    return (widget.lastMonth.year - widget.firstMonth.year) * 12 +
        widget.lastMonth.month -
        widget.firstMonth.month +
        1;
  }

  @override
  void initState() {
    super.initState();

    _selectedIndex = _indexForMonth(widget.selectedMonth);
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedIndex,
    );
  }

  @override
  void didUpdateWidget(covariant CalendarMonthDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    final rangeChanged =
        !_isSameMonth(oldWidget.firstMonth, widget.firstMonth) ||
        !_isSameMonth(oldWidget.lastMonth, widget.lastMonth);

    if (rangeChanged) {
      _scrollController.dispose();

      _selectedIndex = _indexForMonth(widget.selectedMonth);
      _scrollController = FixedExtentScrollController(
        initialItem: _selectedIndex,
      );
      return;
    }

    final newIndex = _indexForMonth(widget.selectedMonth);

    if (newIndex == _selectedIndex) {
      return;
    }

    _selectedIndex = newIndex;

    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) {
          return;
        }

        _scrollController.animateToItem(
          newIndex,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      });
      return;
    }

    _scrollController.dispose();
    _scrollController = FixedExtentScrollController(initialItem: newIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isSameMonth(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month;
  }

  int _indexForMonth(DateTime month) {
    final index =
        (month.year - widget.firstMonth.year) * 12 +
        month.month -
        widget.firstMonth.month;

    if (index < 0) {
      return 0;
    }

    if (index >= _monthCount) {
      return _monthCount - 1;
    }

    return index;
  }

  DateTime _monthForIndex(int index) {
    return DateTime(widget.firstMonth.year, widget.firstMonth.month + index);
  }

  String _formatMonth(DateTime month) {
    final monthText = month.month.toString().padLeft(2, '0');
    return '${month.year}. $monthText';
  }

  void _handleMonthChanged(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    widget.onMonthSelected(_monthForIndex(index));
  }

  void _handleMonthPressed(int index) {
    _scrollController.animateToItem(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleMenuOpened() {
    final currentIndex = _indexForMonth(widget.selectedMonth);

    if (_selectedIndex != currentIndex) {
      setState(() {
        _selectedIndex = currentIndex;
      });
    }

    // 메뉴 오버레이와 ListWheelScrollView가 생성된 다음 위치 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      _scrollController.jumpToItem(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final menuHeight = widget.itemExtent * 3;

    return MenuAnchor(
      controller: _menuController,
      useRootOverlay: true,
      onOpen: _handleMenuOpened,
      clipBehavior: Clip.antiAlias,
      alignmentOffset: widget.alignmentOffset,
      style: MenuStyle(
        alignment: Alignment.topLeft,
        minimumSize: WidgetStatePropertyAll(Size(widget.width, menuHeight)),
        maximumSize: WidgetStatePropertyAll(Size(widget.width, menuHeight)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        elevation: const WidgetStatePropertyAll(5),
        backgroundColor: WidgetStatePropertyAll(
          context.grays.white.withValues(alpha: 0.95),
        ),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(
          colorScheme.shadow.withValues(alpha: 0.20),
        ),
        side: const WidgetStatePropertyAll(BorderSide.none),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      menuChildren: [
        SizedBox(
          width: widget.width,
          height: menuHeight,
          child: Stack(
            children: [
              // 항상 가운데 행이 선택 영역이 됨
              Positioned(
                top: widget.itemExtent,
                left: 0,
                right: 0,
                height: widget.itemExtent,
                child: IgnorePointer(
                  child: ColoredBox(
                    color: context.grays.gray7.withValues(alpha: 0.95),
                  ),
                ),
              ),

              ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: widget.itemExtent,
                physics: const FixedExtentScrollPhysics(),
                diameterRatio: 1000,
                perspective: 0.0001,
                squeeze: 1,
                onSelectedItemChanged: _handleMonthChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _monthCount,
                  builder: (context, index) {
                    final month = _monthForIndex(index);
                    final isSelected = index == _selectedIndex;

                    return Semantics(
                      button: true,
                      selected: isSelected,
                      label: '${month.year}년 ${month.month}월',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _handleMonthPressed(index),
                        child: SizedBox(
                          width: widget.width,
                          height: widget.itemExtent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.x12,
                            ),
                            child: Row(
                              children: [
                                if (isSelected) ...[
                                  Center(
                                    child: Padding(
                                      key: const ValueKey('pressed-check'),
                                      padding: const EdgeInsets.only(
                                        right: AppSpacing.x4,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/check/check.svg',
                                        colorFilter: ColorFilter.mode(
                                          context.grays.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.x10),
                                ],
                                Text(
                                  _formatMonth(month),
                                  style: FontStyles.med16.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: widget.itemExtent,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: context.grays.gray7,
                  ),
                ),
              ),
              Positioned(
                top: widget.itemExtent * 2,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: context.grays.gray7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      builder: (context, controller, child) {
        return widget.triggerBuilder(context, controller);
      },
    );
  }
}
