import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class CloudSelectionCheckbox extends StatelessWidget {
  const CloudSelectionCheckbox({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: 16.0,
        height: 16.0,
        child: Checkbox(
          value: isSelected,
          onChanged: (_) {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          side: BorderSide(color: context.grays.gray6, width: 1.0),
          fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return context.grays.gray2;
            }

            return context.grays.white;
          }),
          checkColor: context.grays.white,
          overlayColor: WidgetStatePropertyAll(
            context.grays.white.withValues(alpha: 0.0),
          ),
        ),
      ),
    );
  }
}
