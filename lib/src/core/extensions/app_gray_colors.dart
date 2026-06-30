import 'package:flutter/material.dart';

@immutable
class AppGrayColors extends ThemeExtension<AppGrayColors> {
  const AppGrayColors({
    required this.black,
    required this.gray1,
    required this.gray2,
    required this.gray3,
    required this.gray4,
    required this.gray5,
    required this.gray6,
    required this.gray7,
    required this.gray8,
    required this.white,
  });

  final Color black;
  final Color gray1;
  final Color gray2;
  final Color gray3;
  final Color gray4;
  final Color gray5;
  final Color gray6;
  final Color gray7;
  final Color gray8;
  final Color white;

  @override
  AppGrayColors copyWith({
    Color? black,
    Color? gray1,
    Color? gray2,
    Color? gray3,
    Color? gray4,
    Color? gray5,
    Color? gray6,
    Color? gray7,
    Color? gray8,
    Color? white,
  }) {
    return AppGrayColors(
      black: black ?? this.black,
      gray1: gray1 ?? this.gray1,
      gray2: gray2 ?? this.gray2,
      gray3: gray3 ?? this.gray3,
      gray4: gray4 ?? this.gray4,
      gray5: gray5 ?? this.gray5,
      gray6: gray6 ?? this.gray6,
      gray7: gray7 ?? this.gray7,
      gray8: gray8 ?? this.gray8,
      white: white ?? this.white,
    );
  }

  @override
  AppGrayColors lerp(ThemeExtension<AppGrayColors>? other, double t) {
    if (other is! AppGrayColors) {
      return this;
    }

    return AppGrayColors(
      black: Color.lerp(black, other.black, t)!,
      gray1: Color.lerp(gray1, other.gray1, t)!,
      gray2: Color.lerp(gray2, other.gray2, t)!,
      gray3: Color.lerp(gray3, other.gray3, t)!,
      gray4: Color.lerp(gray4, other.gray4, t)!,
      gray5: Color.lerp(gray5, other.gray5, t)!,
      gray6: Color.lerp(gray6, other.gray6, t)!,
      gray7: Color.lerp(gray7, other.gray7, t)!,
      gray8: Color.lerp(gray8, other.gray8, t)!,
      white: Color.lerp(white, other.white, t)!,
    );
  }
}
