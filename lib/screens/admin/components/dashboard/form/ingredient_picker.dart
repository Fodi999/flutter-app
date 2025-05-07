import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sushi_app/models/inventory_item.dart';

/// Кастомный ScrollBehavior, чтобы поддерживать прокрутку мышью
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

/// Отображает модальное окно выбора ингредиента с горизонтальной прокруткой вкладок категорий
Future<InventoryItem?> showIngredientPicker({
  required BuildContext context,
  required List<InventoryItem> inventory,
}) {
  String filter = '';
  String selectedCategory = 'Все';

  // Эмодзи для категорий
  const categoryEmojis = {
    'сыры': '🧀',
    'рыба': '🐟',
    'соусы': '🥣',
    'овощи': '🥑',
    'рис': '🍚',
    'суши': '🍣',
    'зелень': '🥬',
  };

  // Фиксированный набор вкладок категорий
  const categories = [
    'Все',
    'сыры',
    'рыба',
    'соусы',
    'овощи',
    'рис',
    'суши',
    'зелень',
  ];

  return showModalBottomSheet<InventoryItem>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (_, scrollController) => StatefulBuilder(
        builder: (ctx, setModalState) {
          // Фильтрация инвентаря по тексту и по выбранной категории
          final filtered = inventory.where((it) {
            final matchesFilter =
                it.name.toLowerCase().contains(filter.trim());
            final matchesCategory =
                selectedCategory == 'Все' ||
                it.category.toLowerCase() == selectedCategory.toLowerCase();
            return matchesFilter && matchesCategory;
          }).toList();

          return Padding(
            padding: EdgeInsets.only(
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Вкладки категорий с горизонтальной прокруткой
                SizedBox(
                  height: 48,
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final cat = categories[i];
                        final selected = cat == selectedCategory;
                        final emoji = categoryEmojis[cat];
                        return ChoiceChip(
                          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                          label: Text(
                            emoji != null ? '$emoji  $cat' : cat,
                            style: const TextStyle(fontSize: 14),
                            softWrap: false,
                            overflow: TextOverflow.visible,
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setModalState(() => selectedCategory = cat);
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Поле поиска
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Поиск ингредиента',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setModalState(() => filter = v.toLowerCase()),
                ),
                const SizedBox(height: 12),

                // Список результатов ингредиентов
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      final pricePerGram = item.pricePerKg / 1000;
                      final emoji =
                          categoryEmojis[item.category] ?? item.emoji ?? '🍽️';
                      return ListTile(
                        leading: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                          '${item.pricePerKg.toStringAsFixed(0)} ₽/кг '
                          '(${pricePerGram.toStringAsFixed(2)} ₽/г)',
                        ),
                        onTap: () => Navigator.pop(ctx, item),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}





