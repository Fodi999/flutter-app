// lib/screens/user/components/cart_item_card.dart

import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    Key? key,
    required this.item,
    required this.quantity,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  final MenuItem item;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dt = Theme.of(context).textTheme;
    final totalPrice = (item.price * quantity).toStringAsFixed(0);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Изображение товара
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: cs.onSurface.withOpacity(0.1),
                      child: const Icon(Icons.image, size: 32),
                    ),
            ),
            const SizedBox(width: 12),

            // Информация о товаре
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: dt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(0)} ₽ each',
                    style: dt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: $totalPrice ₽',
                    style: dt.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Управление количеством
            Row(
              children: [
                IconButton(
                  onPressed: onDecrease,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: cs.primary,
                ),
                Text(
                  '$quantity',
                  style: dt.bodyMedium,
                ),
                IconButton(
                  onPressed: onIncrease,
                  icon: const Icon(Icons.add_circle_outline),
                  color: cs.primary,
                ),
              ],
            ),

            // Кнопка удаления
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              color: cs.error,
            ),
          ],
        ),
      ),
    );
  }
}
