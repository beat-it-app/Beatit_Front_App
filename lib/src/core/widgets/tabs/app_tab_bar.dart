import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  }) : assert(labels.length >= 2),
       assert(selectedIndex >= 0 && selectedIndex < labels.length);

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _tabGap = 6.0;
  static const _indicatorThickness = 2.0;
  static const _trackThickness = 0.7;
  static const _motionDuration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth =
            (constraints.maxWidth - _tabGap * (labels.length - 1)) /
            labels.length;
        final indicatorInset = tabWidth > AppSpacing.x20 * 2
            ? AppSpacing.x20
            : 0.0;
        final indicatorWidth = tabWidth - indicatorInset * 2;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                for (var index = 0; index < labels.length; index++) ...[
                  if (index > 0) const SizedBox(width: _tabGap),
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: index == selectedIndex,
                      label: labels[index],
                      child: InkWell(
                        onTap: () => onChanged(index),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.x4,
                            bottom: AppSpacing.x4,
                          ),
                          child: SizedBox(
                            height: 40,
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: _motionDuration,
                                curve: Curves.easeInOutCubic,
                                style: FontStyles.semi14.copyWith(
                                  color: index == selectedIndex
                                      ? context.grays.black
                                      : context.grays.gray5,
                                ),
                                child: Text(labels[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(
              height: _indicatorThickness,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: _trackThickness,
                    child: ColoredBox(color: context.grays.gray5),
                  ),
                  AnimatedPositioned(
                    duration: _motionDuration,
                    curve: Curves.easeInOutCubic,
                    left: selectedIndex * (tabWidth + _tabGap) + indicatorInset,
                    bottom: 0,
                    height: _indicatorThickness,
                    width: indicatorWidth,
                    child: ColoredBox(color: context.grays.black),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
