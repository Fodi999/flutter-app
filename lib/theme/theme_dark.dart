// theme_dark.dart
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'text_styles.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surfaceDark.withOpacity(0.8),
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    labelSmall: AppTextStyles.labelSmall,
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: AppColors.glassDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
    ),
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const ColorScheme.dark().onPrimary, // ✅ автоматически подстраивается
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark.withOpacity(0.5),
    hintStyle: TextStyle(
      color: Colors.grey[400],
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





