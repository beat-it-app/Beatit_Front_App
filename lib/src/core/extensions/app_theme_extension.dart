import 'package:flutter/material.dart';

import 'app_gray_colors.dart';

extension ThemeContextExtension on BuildContext {
  ColorScheme get colors {
    return Theme.of(this).colorScheme;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  AppGrayColors get grays {
    return Theme.of(this).extension<AppGrayColors>()!;
  }
}
