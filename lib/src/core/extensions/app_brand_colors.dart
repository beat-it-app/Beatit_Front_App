import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

@immutable
class AppBrandColors extends ThemeExtension<AppBrandColors> {
  const AppBrandColors({
    required this.beatOrange1,
    required this.beatOrange2,
    required this.beatOrange3,
    required this.beatOrange4,
    required this.beatOrange5,
    required this.beatOrange6,
    required this.beatGreen,
    required this.error,
    required this.errorContainer,
  });

  final Color beatOrange1;
  final Color beatOrange2;
  final Color beatOrange3;
  final Color beatOrange4;
  final Color beatOrange5;
  final Color beatOrange6;

  final Color beatGreen;

  final Color error;
  final Color errorContainer;

  factory AppBrandColors.light() {
    return const AppBrandColors(
      beatOrange1: AppColor.beatOrange1,
      beatOrange2: AppColor.beatOrange2,
      beatOrange3: AppColor.beatOrange3,
      beatOrange4: AppColor.beatOrange4,
      beatOrange5: AppColor.beatOrange5,
      beatOrange6: AppColor.beatOrange6,
      beatGreen: AppColor.beatGreen,
      error: AppColor.error,
      errorContainer: AppColor.errorContainer,
    );
  }

  factory AppBrandColors.dark() {
    return const AppBrandColors(
      //TODO: 다크모드 색상 나오면 변경해야 함.
      beatOrange1: AppColor.beatOrange3,
      beatOrange2: AppColor.beatOrange3,
      beatOrange3: AppColor.beatOrange4,
      beatOrange4: AppColor.beatOrange4,
      beatOrange5: AppColor.beatOrange2,
      beatOrange6: AppColor.beatOrange1,
      beatGreen: AppColor.beatGreen,
      error: AppColor.error,
      errorContainer: AppColor.errorContainer,
    );
  }

  @override
  AppBrandColors copyWith({
    Color? beatOrange1,
    Color? beatOrange2,
    Color? beatOrange3,
    Color? beatOrange4,
    Color? beatOrange5,
    Color? beatOrange6,
    Color? beatGreen,
    Color? error,
    Color? errorContainer,
  }) {
    return AppBrandColors(
      beatOrange1: beatOrange1 ?? this.beatOrange1,
      beatOrange2: beatOrange2 ?? this.beatOrange2,
      beatOrange3: beatOrange3 ?? this.beatOrange3,
      beatOrange4: beatOrange4 ?? this.beatOrange4,
      beatOrange5: beatOrange5 ?? this.beatOrange5,
      beatOrange6: beatOrange6 ?? this.beatOrange6,
      beatGreen: beatGreen ?? this.beatGreen,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
    );
  }

  @override
  AppBrandColors lerp(ThemeExtension<AppBrandColors>? other, double t) {
    if (other is! AppBrandColors) {
      return this;
    }

    return AppBrandColors(
      beatOrange1: Color.lerp(beatOrange1, other.beatOrange1, t)!,
      beatOrange2: Color.lerp(beatOrange2, other.beatOrange2, t)!,
      beatOrange3: Color.lerp(beatOrange3, other.beatOrange3, t)!,
      beatOrange4: Color.lerp(beatOrange4, other.beatOrange4, t)!,
      beatOrange5: Color.lerp(beatOrange5, other.beatOrange5, t)!,
      beatOrange6: Color.lerp(beatOrange6, other.beatOrange6, t)!,
      beatGreen: Color.lerp(beatGreen, other.beatGreen, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
    );
  }
}
