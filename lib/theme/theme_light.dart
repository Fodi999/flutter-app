// theme_light.dart
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'text_styles.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  primary: AppColors.primary,
  secondary: AppColors.secondary,
  surface: AppColors.surfaceLight.withOpacity(0.9),
  brightness: Brightness.light,
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: colorScheme,
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelSmall: AppTextStyles.labelSmall,
  ).apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: AppColors.glassLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
    ),
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: colorScheme.onPrimary, // ✅ исправлено
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight.withOpacity(0.3),
    hintStyle: TextStyle(
      color: Colors.grey[600],
      fontFamily: AppTextStyles.bodyMedium.fontFamily,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeThroughPageTransitionsBuilder(),
      TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
      TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
    },
  ),
  useMaterial3: true,
);




