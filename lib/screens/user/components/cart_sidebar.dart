import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/state/cart_state.dart';
import 'cart_item_card.dart';

class CartSidebar extends ConsumerWidget {
  const CartSidebar({
    super.key,
    required this.user,
    this.onCheckout,
  });

  final User user;
  final void Function(CartItem item, User user)? onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final dt = Theme.of(context).textTheme;

    final items = ref.watch(cartStateProvider);
    final totalItems = items.fold<int>(0, (s, e) => s + e.quantity);
    final totalPrice = items.fold<double>(0, (s, e) => s + e.quantity * e.price);

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
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text('Ваша корзина', style: dt.titleLarge),
              const SizedBox(height: 12),

              if (items.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => CartItemCard(
                      item: items[i],
                      showControls: true,
                      showCheckout: false,
                      user: user,
                      onCheckout: onCheckout,
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('Корзина пуста')),
                ),

              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Всего блюд:',
                      style: dt.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('$totalItems',
                      style: dt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      )),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Сумма заказа:',
                      style: dt.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('${totalPrice.toStringAsFixed(0)} ₽',
                      style: dt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      )),
                ],
              ),
              const SizedBox(height: 16),

              FilledButton.icon(
                icon: const Icon(Icons.shopping_bag),
                onPressed: (items.isEmpty || onCheckout == null)
                    ? null
                    : () async {
                        for (final ci in items) {
                          onCheckout!(ci, user);
                        }

                        await Future.delayed(const Duration(milliseconds: 300));

                        ref.read(cartStateProvider.notifier).clear();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                label: const Text('Оформить весь заказ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
















