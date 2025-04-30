import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';

class MenuCard extends StatelessWidget {
  /// 1️⃣ Сначала — конструктор, используя super-parameter для key
  const MenuCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onPublish,
  });

  /// 2️⃣ Затем — поля
  final MenuItem item;
  final VoidCallback onDelete;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(8),
      child: Card(
        elevation: 3,
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
                const Icon(Icons.image, size: 100, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '${item.price.toStringAsFixed(2)} ₽',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      item.published ? Icons.visibility : Icons.visibility_off,
                      color: item.published ? Colors.green : Colors.grey,
                    ),
                    onPressed: onPublish,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




