import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier()
    : super(ThemeMode.light); // 기본값: 라이트 모드 (또는 ThemeMode.system)

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});
