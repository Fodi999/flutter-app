import 'package:flutter/material.dart';
import 'package:sushi_app/models/inventory_item.dart';
import 'package:sushi_app/components/app_dialog.dart';

class InventoryItemDialog extends StatefulWidget {
  final InventoryItem? item;
  final void Function(InventoryItem newItem) onSubmit;

  const InventoryItemDialog({
    super.key,
    this.item,
    required this.onSubmit,
  });

  @override
  State<InventoryItemDialog> createState() => _InventoryItemDialogState();
}

class _InventoryItemDialogState extends State<InventoryItemDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController emojiCtrl;
  late final TextEditingController weightCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController categoryCtrl;
  bool available = true;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    nameCtrl = TextEditingController(text: item?.name ?? '');
    emojiCtrl = TextEditingController(text: item?.emoji ?? '');
    weightCtrl = TextEditingController(text: item?.weightG.toString() ?? '');
    priceCtrl = TextEditingController(text: item?.pricePerKg.toString() ?? '');
    categoryCtrl = TextEditingController(text: item?.category ?? 'прочее');
    available = item?.available ?? true;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emojiCtrl.dispose();
    weightCtrl.dispose();
    priceCtrl.dispose();
    categoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: widget.item == null ? 'Добавить продукт' : 'Редактировать продукт',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildField(emojiCtrl, 'Эмодзи (🍣, 🥑)', TextInputType.text),
          const SizedBox(height: 12),
          _buildField(nameCtrl, 'Название', TextInputType.text),
          const SizedBox(height: 12),
          _buildField(categoryCtrl, 'Категория (рыба, соусы...)', TextInputType.text),
          const SizedBox(height: 12),
          _buildField(weightCtrl, 'Вес (г)', TextInputType.number),
          const SizedBox(height: 12),
          _buildField(priceCtrl, 'Цена за 1 кг', TextInputType.number),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Доступен'),
            value: available,
            onChanged: (v) => setState(() => available = v),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
        ElevatedButton(
          onPressed: () {
            final name = nameCtrl.text.trim();
            final emoji = emojiCtrl.text.trim();
            final category = categoryCtrl.text.trim().toLowerCase();
            final weight = double.tryParse(weightCtrl.text) ?? 0;
            final price = double.tryParse(priceCtrl.text) ?? 0;

            if (name.isEmpty || emoji.isEmpty || category.isEmpty || weight <= 0 || price <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заполните все поля корректно')),
              );
              return;
            }

            final newItem = InventoryItem(
              id: widget.item?.id ?? '',
              name: name,
              emoji: emoji,
              category: category,
              weightG: weight,
              pricePerKg: price,
              available: available,
              createdAt: widget.item?.createdAt ?? DateTime.now(),
            );

            widget.onSubmit(newItem);
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}


