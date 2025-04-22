import 'package:flutter/material.dart';
import 'package:sushi_app/models/inventory_item.dart';

Future<InventoryItem?> showIngredientPicker({
  required BuildContext context,
  required List<InventoryItem> inventory,
}) {
  String filter = '';

  return showModalBottomSheet<InventoryItem>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) {
        final filtered = inventory
            .where((it) => it.name.toLowerCase().contains(filter))
            .toList();

        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Поиск ингредиента',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      setModalState(() => filter = v.toLowerCase()),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.6,
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final item = filtered[i];
                    return ListTile(
                      leading: Text(item.emoji ?? '🍽️',
                          style: const TextStyle(fontSize: 24)),
                      title: Text(item.name),
                      subtitle:
                          Text('${item.pricePerKg.toStringAsFixed(0)} ₽/кг'),
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
  );
}

