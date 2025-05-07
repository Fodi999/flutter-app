// lib/widgets/cart_button.dart

import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const CartButton({
    Key? key,
    required this.count,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.shopping_cart),
          ),
          if (count > 0)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
}
