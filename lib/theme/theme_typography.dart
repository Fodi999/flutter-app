import 'package:flutter/material.dart';

class AnimatedTypography extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool animate;
  final Duration duration;

  const AnimatedTypography({
    super.key,
    required this.text,
    required this.style,
    this.animate = true,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: duration,
      curve: Curves.easeInOut,
      style: animate
          ? style.copyWith(
              fontSize: style.fontSize! + 2,
              letterSpacing: 1.5,
            )
          : style,
      child: Text(text),
    );
  }
}
