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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(labels.length, (index) {
        final isSelected = selectedIndex == index;

        return Expanded(
          child: Semantics(
            button: true,
            selected: isSelected,
            label: labels[index],
            child: InkWell(
              onTap: () => onChanged(index),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.x8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 44,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          style: FontStyles.semi14.copyWith(
                            color: isSelected
                                ? colors.onSurface
                                : colors.onSurfaceVariant,
                          ),
                          child: Text(labels[index]),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      height: 2,
                      color: isSelected
                          ? colors.onSurface
                          : context.grays.gray7,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
