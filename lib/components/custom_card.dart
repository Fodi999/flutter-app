// lib/components/custom_card.dart
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  /// Контент карточки
  final Widget child;
  /// Обработчик тапов (InkWell)
  final VoidCallback? onTap;
  /// Внешние отступы вокруг самой Card
  final EdgeInsetsGeometry margin;
  /// Скругление углов
  final BorderRadiusGeometry borderRadius;
  /// Внутренние отступы для контента внутри InkWell
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    Key? key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}



