// lib/theme/theme_typography.dart

import 'package:flutter/material.dart';

/// Анимированная типографика для заголовков и текстов
class AnimatedTypography extends StatelessWidget {
  // 1. Конструктор — сразу после заголовка класса
  const AnimatedTypography({
    super.key,
    required this.text,
    required this.style,
    this.animate = true,
    this.duration = const Duration(milliseconds: 300),
    this.textAlign = TextAlign.center,
  });

  // 2. Поля
  final String text;
  final TextStyle style;
  final bool animate;
  final Duration duration;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      style: animate
          ? style.copyWith(
              fontSize: (style.fontSize ?? 16) + 2,
              letterSpacing: 1.2,
            )
          : style,
      duration: duration,
      curve: Curves.easeInOut,
      child: Text(text, textAlign: textAlign),
    );
  }
}



