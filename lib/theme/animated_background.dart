// lib/theme/animated_background.dart

import 'package:flutter/material.dart';

/// Анимированный фон с плавным переходом цвета.
class AnimatedBackground extends StatelessWidget {
  /// Конструктор — первым членом класса.
  const AnimatedBackground({
    super.key,
    required this.beginColor,
    required this.endColor,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
  });

  // Параметры
  final Color beginColor;
  final Color endColor;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: beginColor, end: endColor),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, animatedColor, child) {
        final color = animatedColor ?? beginColor;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                endColor, // Переход именно в endColor
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

