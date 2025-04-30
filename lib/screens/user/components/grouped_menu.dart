// lib/screens/user/components/grouped_menu.dart

import 'package:flutter/material.dart';
import 'package:sushi_app/models/menu_item.dart';
import 'user_menu_card.dart';

class GroupedMenu extends StatelessWidget {
  /// Список элементов меню
  final List<MenuItem> items;
  /// Коллбэк на добавление в корзину
  final void Function(MenuItem) onAddToCart;

  const GroupedMenu({
    Key? key,
    required this.items,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Группируем по категориям
    final grouped = <String, List<MenuItem>>{};
    for (var item in items) {
      final cat = (item.categoryName?.isEmpty ?? true)
          ? 'Без категории'
          : item.categoryName!;
      grouped.putIfAbsent(cat, () => []).add(item);
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              entry.key,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: entry.value.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, i) {
                final item = entry.value[i];
                return UserMenuCard(
                  item: item,
                  onAddToCart: () => onAddToCart(item),
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}



