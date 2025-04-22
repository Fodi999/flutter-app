import 'package:flutter/material.dart';
import '../../../models/menu_item.dart';

class UserMenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onAddToCart;

  const UserMenuCard({
    Key? key,
    required this.item,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Icon(Icons.image, size: 60)),
                ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '${item.price.toStringAsFixed(2)} ₽',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.green,
                  tooltip: 'Добавить в корзину',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


