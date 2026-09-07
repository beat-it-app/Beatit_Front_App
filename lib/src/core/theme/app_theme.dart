// lib/src/core/theme/app_theme.dart
import 'package:beatit_front_app/src/core/extensions/app_brand_colors.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColor.beatOrange1,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColor.beatOrange1,
          onPrimary: AppColor.white,
          primaryContainer: AppColor.beatOrange5,
          onPrimaryContainer: AppColor.beatOrange1,
          secondary: AppColor.gray1,
          onSecondary: AppColor.white,
          surface: AppColor.white,
          onSurface: AppColor.black,
          error: AppColor.error,
          onError: AppColor.white,
          errorContainer: AppColor.errorContainer,
          onErrorContainer: AppColor.error,
          outline: AppColor.gray2,
          surfaceContainerHighest: AppColor.gray7,
          onSurfaceVariant: AppColor.gray4,
        );

    return _theme(
      colorScheme: colorScheme,
      grayColors: const AppGrayColors(
        black: AppColor.black,
        gray1: AppColor.gray1,
        gray2: AppColor.gray2,
        gray3: AppColor.gray3,
        gray4: AppColor.gray4,
        gray5: AppColor.gray5,
        gray6: AppColor.gray6,
        gray7: AppColor.gray7,
        gray8: AppColor.gray8,
        white: AppColor.white,
      ),
      brandColors: AppBrandColors.light(),
      scaffoldBackgroundColor: AppColor.white,
      cardColor: AppColor.white,
      inputFillColor: AppColor.gray8,
      dividerColor: AppColor.gray7,
      textColor: AppColor.black,
      subTextColor: AppColor.gray5,
    );
  }

  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColor.beatOrange1,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColor.beatOrange2,
          onPrimary: AppColor.black,
          primaryContainer: AppColor.beatOrange1,
          onPrimaryContainer: AppColor.white,
          secondary: AppColor.white,
          onSecondary: AppColor.black,
          surface: AppColor.black,
          onSurface: AppColor.white,
          error: AppColor.error,
          onError: AppColor.white,
          errorContainer: AppColor.errorContainer,
          onErrorContainer: AppColor.error,
          outline: AppColor.gray6,
          surfaceContainerHighest: AppColor.gray2,
          onSurfaceVariant: AppColor.gray5,
        );

    return _theme(
      colorScheme: colorScheme,
      grayColors: const AppGrayColors(
        black: AppColor.white,
        gray1: AppColor.gray8,
        gray2: AppColor.gray7,
        gray3: AppColor.gray6,
        gray4: AppColor.gray5,
        gray5: AppColor.gray4,
        gray6: AppColor.gray3,
        gray7: AppColor.gray2,
        gray8: AppColor.gray1,
        white: AppColor.black,
      ),
      brandColors: AppBrandColors.dark(),
      scaffoldBackgroundColor: AppColor.black,
      cardColor: AppColor.gray1,
      inputFillColor: AppColor.gray1,
      dividerColor: AppColor.gray2,
      textColor: AppColor.white,
      subTextColor: AppColor.gray5,
    );
  }

  static ThemeData _theme({
    required ColorScheme colorScheme,
    required AppGrayColors grayColors,
    required AppBrandColors brandColors,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
    required Color inputFillColor,
    required Color dividerColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      colorScheme: colorScheme,
      extensions: [grayColors, brandColors],
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: _textTheme(textColor: textColor, subTextColor: subTextColor),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: textColor,
        titleTextStyle: FontStyles.semi14.copyWith(color: textColor),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x16,
            vertical: AppSpacing.x12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: FontStyles.semi16.copyWith(letterSpacing: 0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x16,
            vertical: AppSpacing.x12,
          ),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: FontStyles.semi16,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
        hintStyle: FontStyles.reg18.copyWith(color: subTextColor),
        labelStyle: FontStyles.reg18.copyWith(color: textColor),
        errorStyle: FontStyles.reg12.copyWith(color: colorScheme.error),
        suffixIconColor: subTextColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.secondary, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          side: BorderSide(color: dividerColor),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldBackgroundColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: subTextColor,
        selectedLabelStyle: FontStyles.reg12,
        unselectedLabelStyle: FontStyles.reg12,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textColor,
        contentTextStyle: FontStyles.reg14.copyWith(
          color: scaffoldBackgroundColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xxl),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme({
    required Color textColor,
    required Color subTextColor,
  }) {
    return TextTheme(
      displayLarge: FontStyles.semi28.copyWith(color: textColor),
      headlineLarge: FontStyles.semi28.copyWith(color: textColor),
      headlineMedium: FontStyles.semi24.copyWith(color: textColor),
      titleLarge: FontStyles.semi20.copyWith(color: textColor),
      titleMedium: FontStyles.semi16.copyWith(color: textColor),
      bodyLarge: FontStyles.reg16.copyWith(color: textColor),
      bodyMedium: FontStyles.reg14.copyWith(color: textColor),
      bodySmall: FontStyles.reg12.copyWith(color: subTextColor),
      labelLarge: FontStyles.reg15.copyWith(color: textColor),
      labelMedium: FontStyles.semi14.copyWith(color: subTextColor),
      labelSmall: FontStyles.reg11.copyWith(color: subTextColor),
    );
  }
}
