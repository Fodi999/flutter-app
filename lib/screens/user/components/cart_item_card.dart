// lib/screens/user/components/cart_item_card.dart
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

  /// Позиция корзины
  final CartItem item;

  /// Показывать ли + / – / удалить
  final bool showControls;

  /// Показывать ли кнопку «Оформить»
  final bool showCheckout;

  /// Текущий пользователь (нужен для onCheckout)
  final User? user;

  /// Колбэк «Оформить позицию» (если нужен)
  final void Function(CartItem item, User user)? onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dt = Theme.of(context).textTheme;
    final totalPrice = (item.price * item.quantity).toStringAsFixed(0);

    /* удобные ссылки на провайдер */
    final cart = ref.read(cartStateProvider.notifier);

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
                /* ───── картинка ───── */
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

                /* ───── название и цены ───── */
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
                      Text(
                        '${item.price.toStringAsFixed(0)} ₽ / шт.',
                        style:
                            dt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Итого: $totalPrice ₽',
                        style: dt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /* ───── управление количеством ───── */
                if (showControls)
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => cart.inc(item),
                        icon: const Icon(Icons.add_circle),
                        color: cs.primary,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        '${item.quantity}',
                        style: dt.labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => cart.dec(item),
                        icon: const Icon(Icons.remove_circle),
                        color: cs.primary,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),

                /* ───── удалить ───── */
                if (showControls)
                  IconButton(
                    onPressed: () => cart.remove(item),
                    icon: const Icon(Icons.close_rounded),
                    color: cs.error,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
        ),

        /* ───── оформить позицию ───── */
        if (showCheckout && onCheckout != null && user != null)
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








