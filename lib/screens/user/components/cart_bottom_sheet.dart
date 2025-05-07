// lib/screens/user/components/cart_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/state/cart_state.dart';
import 'cart_item_card.dart';

/// Bottom Sheet для мобильной версии
class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({
    Key? key,
    required this.user,
    this.onCheckout,
  }) : super(key: key);

  final User user;
  final void Function(CartItem item, User user)? onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final items = ref.watch(cartStateProvider);
    final totalItems = items.fold<int>(0, (s, e) => s + e.quantity);
    final totalPrice = items.fold<double>(0, (s, e) => s + e.quantity * e.price);

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop()),
            ),
            Text('Ваша корзина',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (items.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => CartItemCard(
                    item: items[i],
                    showControls: true,
                    showCheckout: false,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('Корзина пуста',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            const SizedBox(height: 12),
            Row(
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
                        ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
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
                        ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary)),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: items.isEmpty || onCheckout == null
                  ? null
                  : () {
                      for (final ci in items) {
                        onCheckout!(ci, user);
                      }
                    },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Оформить весь заказ'),
            ),
          ],
        ),
      ),
    );
  }
}












