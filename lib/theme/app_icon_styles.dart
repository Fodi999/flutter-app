// lib/theme/app_icon_styles.dart

import 'package:flutter/material.dart';

/// Глобальные стили для иконок
class AppIconStyles {
  /// Обычная иконка в цвете темы
  static Icon defaultIcon(
    BuildContext context, {
    required IconData icon,
    double size = 24,
  }) {
    final theme = Theme.of(context);
    return Icon(
      icon,
      size: size,
      color: theme.iconTheme.color ?? theme.colorScheme.onPrimary,
    );
  }

  /// Круглая иконка с фоном
  static Widget circleIcon(
    BuildContext context, {
    required IconData icon,
    double size = 20,
    double radius = 24,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    // Используем alpha в диапазоне 0.0–1.0
    final Color bgColor = backgroundColor ??
        theme.colorScheme.primary.withValues(
          alpha: 0.2,
        );
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Icon(
        icon,
        size: size,
        color: theme.iconTheme.color ?? theme.colorScheme.onPrimary,
      ),
    );
  }
}

