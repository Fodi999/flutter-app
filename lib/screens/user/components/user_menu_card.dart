import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'package:sushi_app/components/primary_button.dart';

class UserMenuCard extends StatelessWidget {
  const UserMenuCard({
    Key? key,
    required this.item,
    required this.onAddToCart,
  }) : super(key: key);

  final MenuItem item;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final halfHeight = constraints.maxHeight / 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Верхняя половина: картинка
              SizedBox(
                height: halfHeight,
                child: item.imageUrl.isNotEmpty
                    ? Image.network(item.imageUrl, fit: BoxFit.cover)
                    : Container(
                        color: cs.onSurface.withOpacity(0.1),
                        child: const Center(
                          child: Icon(Icons.image, size: 64),
                        ),
                      ),
              ),

              // Нижняя половина: текст + кнопка
              SizedBox(
                height: halfHeight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название и описание
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      cs.onSurfaceVariant.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),

                      // Цена и кнопка
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${item.price.toStringAsFixed(0)} ₽',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                          ),
                          const Spacer(),
                          // PrimaryButton сам по себе центрирует иконку
                          PrimaryButton(
                            text: '',
                            icon: Icons.add_shopping_cart_rounded,
                            onPressed: onAddToCart,
                            fullWidth: false,
                            color: cs.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

















