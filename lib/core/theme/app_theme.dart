import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,
      onError: Colors.white,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.textLight,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.textLight,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: AppColors.textLight,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.textLight,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textLight,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textLight,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textLight),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.textLight,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textLight),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textLight),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textSubtle),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textLight),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSubtle,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textSubtle,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonMedium,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.grey300, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.grey300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.error, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSubtle.withAlpha((255 * 0.7).round()),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSubtle,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    ),

    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSubtle,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textLight,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: AppColors.textDark,
      onSurface: AppColors.textDark,
      onError: Colors.white,
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.textDark,
      ),
      displayMedium: AppTextStyles.displayMedium.copyWith(
        color: AppColors.textDark,
      ),
      displaySmall: AppTextStyles.displaySmall.copyWith(
        color: AppColors.textDark,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.textDark,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textDark,
      ),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.textDark,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textDark),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.textDark,
      ),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textDark),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSubtleDark,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textDark),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSubtleDark,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.textSubtleDark,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(120, 48),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey800.withAlpha((255 * 0.8).round()),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.grey600, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.grey600, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.error, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSubtleDark,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSubtleDark,
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    ),

    cardTheme: const CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 2,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSubtleDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textDark,
      ),
    ),
  );
}
