// lib/screens/user/components/cart_sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/state/cart_state.dart';
import 'cart_item_card.dart';

/// Выдвижная корзина для десктоп-версии.
/// Позиции берутся напрямую из [cartStateProvider].
class CartSidebar extends ConsumerWidget {
  const CartSidebar({
    super.key,
    required this.user,
    this.onCheckout,
  });

  /// Текущий пользователь (передаётся в onCheckout)
  final User user;

  /// Колбэк «оформить» (вызывается для каждой позиции)
  final void Function(CartItem item, User user)? onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs    = Theme.of(context).colorScheme;
    final items = ref.watch(cartStateProvider);           // ← позиции
    final totalItems  = items.fold<int>(0, (s, e) => s + e.quantity);
    final totalPrice  = items.fold<double>(0, (s, e) => s + e.quantity * e.price);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: cs.surface,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* ───── заголовок ───── */
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text('Ваша корзина', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              /* ───── список позиций ───── */
              if (items.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => CartItemCard(
                      item: items[i],
                      showControls: true,   // можно менять qty прямо здесь
                      showCheckout: false,
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Корзина пуста')),
                ),

              /* ───── итого ───── */
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Всего блюд:',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text('$totalItems',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Сумма заказа:',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text('${totalPrice.toStringAsFixed(0)} ₽',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
                  ],
                ),
              ),

              /* ───── оформить весь заказ ───── */
              FilledButton(
                onPressed: items.isEmpty || onCheckout == null
                    ? null
                    : () {
                        for (final ci in items) onCheckout!(ci, user);
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Оформить весь заказ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













