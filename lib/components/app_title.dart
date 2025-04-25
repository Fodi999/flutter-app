import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final double fontSize;
  final bool animate;

  const AppTitle({
    super.key,
    this.fontSize = 40,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final gradient = LinearGradient(
      colors: isDark
          ? [
              const Color(0xFFB9F6CA),
              const Color(0xFF69F0AE),
              const Color(0xFF00E676),
            ]
          : [
              const Color(0xFF4CAF50),
              const Color(0xFF2E7D32),
              const Color(0xFF1B5E20),
            ],
    );

    final textStyle = theme.textTheme.displayLarge?.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
      foreground: Paint()
        ..shader = gradient.createShader(const Rect.fromLTWH(0, 0, 200, 70)),
    );

    final child = Text(
      'SushiRobot',
      textAlign: TextAlign.center,
      style: textStyle,
    );

    return animate
        ? TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, _) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: child,
              ),
            ),
          )
        : child;
  }
}

