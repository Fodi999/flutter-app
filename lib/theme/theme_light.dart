// lib/theme/theme_light.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'text_styles.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surfaceLight,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: AppColors.textPrimaryLight,
    error: AppColors.error,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    headlineLarge: AppTextStyles.headlineLarge,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelSmall: AppTextStyles.labelSmall,
  ).apply(
    bodyColor: AppColors.textPrimaryLight,
    displayColor: AppColors.textPrimaryLight,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.primary),
    titleTextStyle: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.surfaceLight,
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
);









