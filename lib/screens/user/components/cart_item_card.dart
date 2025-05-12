import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/state/cart_state.dart';

class CartItemCard extends ConsumerWidget {
  const CartItemCard({
    super.key,
    required this.item,
    this.showControls = true,
    this.showCheckout = false,
    this.user,
    this.onCheckout,
  });

  final CartItem item;
  final bool showControls;
  final bool showCheckout;
  final User? user;
  final void Function(CartItem item, User user)? onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dt = Theme.of(context).textTheme;
    final cart = ref.read(cartStateProvider.notifier);
    final total = (item.price * item.quantity).toStringAsFixed(0);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: cs.surface,
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🖼 Изображение
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: cs.surfaceVariant,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                /// 🧾 Основная информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: dt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),

                      if (item.options.isNotEmpty)
                        ...item.options.entries.map((entry) => Text(
                              '${entry.key}: ${entry.value}',
                              style: dt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            )),

                      const SizedBox(height: 4),
                      Text(
                        '${item.price.toStringAsFixed(0)} ₽ / шт.',
                        style: dt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Итого: $total ₽',
                        style: dt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ➕➖ Управление количеством
                if (showControls)
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: cs.primary,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () => cart.inc(item),
                      ),
                      Text(
                        '${item.quantity}',
                        style: dt.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        color: cs.primary,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () => cart.dec(item),
                      ),
                    ],
                  ),

                /// ❌ Удаление
                if (showControls)
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: cs.error,
                    padding: EdgeInsets.zero,
                    onPressed: () => cart.remove(item),
                  ),
              ],
            ),
          ),
        ),

        /// 🧾 Кнопка "Оформить" под карточкой
        if (showCheckout && user != null && onCheckout != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: FilledButton.icon(
              onPressed: () => onCheckout!(item, user!),
              icon: const Icon(Icons.check_circle),
              label: const Text('Оформить заказ'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
      ],
    );
  }
}










