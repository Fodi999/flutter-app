import 'package:flutter/material.dart';
import 'package:sushi_app/theme/app_sizes.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    this.fontSize = 40,
    this.animate = true,
  });

  final double fontSize;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final gradient = LinearGradient(
      colors: isDark
          ? const [Color(0xFFB9F6CA), Color(0xFF69F0AE), Color(0xFF00E676)]
          : const [Color(0xFF4CAF50), Color(0xFF2E7D32), Color(0xFF1B5E20)],
    );

    final textStyle = theme.textTheme.displayLarge?.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      foreground: Paint()
        ..shader = gradient.createShader(
          const Rect.fromLTWH(0, 0, 400, 70),
        ),
    );

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.network(
            'https://i.postimg.cc/W1KV4b43/logo1.webp',
            width: AppSizes.spacingXL * 2, // 32 * 4 = 128
            height: AppSizes.spacingXL * 2,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: AppSizes.spacingL),
      Text(
  'SHOKU — mądre odżywianie, proste wybory',
  textAlign: TextAlign.center,
  style: textStyle?.copyWith(fontSize: fontSize),
)
      ],
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







