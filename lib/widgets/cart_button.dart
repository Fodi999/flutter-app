import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sushi_app/utils/log_helper.dart';
import 'package:sushi_app/state/cart_state.dart';

class CartButton extends HookConsumerWidget {
  final VoidCallback onPressed;

  const CartButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartStateProvider).totalQty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          tooltip: 'Открыть корзину',
          onPressed: () {
            logInfo('Клик по иконке корзины (товаров: $count)', tag: 'CartButton');
            onPressed();
          },
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}



