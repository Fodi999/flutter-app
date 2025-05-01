// lib/theme/theme_dark.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'text_styles.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surfaceDark,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white70,
    error: AppColors.error,
    onError: Colors.black,
  ),
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    headlineLarge: AppTextStyles.headlineLarge,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelSmall: AppTextStyles.labelSmall,
  ).apply(
    bodyColor: AppColors.textPrimaryDark,
    displayColor: AppColors.textPrimaryDark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontFamily: 'YourFontFamily',
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.surfaceDark,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
      ),
    ),
  ),
  useMaterial3: true,
);










