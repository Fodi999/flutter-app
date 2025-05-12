import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/state/cart_state.dart';
import 'cart_item_card.dart';

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
    final dt = Theme.of(context).textTheme;

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
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Text('Ваша корзина', style: dt.titleLarge),
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
                    user: user,
                    onCheckout: onCheckout, // ✅
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('Корзина пуста', style: dt.bodyMedium),
              ),

            const Divider(height: 24),

            /// 🧾 Кол-во и сумма
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
            const SizedBox(height: 4),
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
            const SizedBox(height: 12),

            /// ✅ Оформить весь заказ
            FilledButton(
              onPressed: items.isEmpty || onCheckout == null
                  ? null
                  : () {
                      for (final ci in items) {
                        onCheckout!(ci, user);
                      }
                      ref.read(cartStateProvider.notifier).clear();
                      Navigator.of(context).pop();
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
    );
  }
}














