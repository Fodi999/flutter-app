import 'package:flutter/material.dart';
import 'package:sushi_app/models/inventory_item.dart';
import 'package:sushi_app/services/inventory_service.dart';

class ManageInventoryScreen extends StatefulWidget {
  // 1. Конструктор – сразу после заголовка класса
  const ManageInventoryScreen({super.key, required this.token});

  // 2. Поле
  final String token;

  @override
  State<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> {
  // 3. Поля состояния
  List<InventoryItem> _items = [];
  List<InventoryItem> _filteredItems = [];
  String _searchQuery = '';
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 4. Загрузка списка
  Future<void> _fetchInventory() async {
    setState(() => _isLoading = true);
    try {
      final fetched = await InventoryService.getInventoryItems(widget.token);
      if (!mounted) return;
      setState(() {
        _items = fetched;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // 5. Удаление элемента с проверкой mounted
  Future<void> _deleteItem(String id) async {
    try {
      await InventoryService.deleteInventoryItem(id, widget.token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Продукт удалён')),
      );
      await _fetchInventory();
    } catch (e) {
      debugPrint('Ошибка при удалении: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при удалении продукта')),
      );
    }
  }

  // 6. Фильтрация
  void _applyFilter() {
    final q = _searchQuery.toLowerCase();
    setState(() {
      _filteredItems = _items.where((item) {
        return item.name.toLowerCase().contains(q);
      }).toList();
    });
  }

  // 7. Бейдж статуса
  Widget _buildStatusBadge(bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: available ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? 'Активен' : 'Нет в наличии',
        style: TextStyle(
          color: available ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // 8. Хедер с поиском и кнопкой
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Склад',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Row(
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Поиск...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (v) {
                  _searchQuery = v;
                  _applyFilter();
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Добавить продукт'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => _showItemDialog(),
            ),
          ],
        ),
      ],
    );
  }

 Future<void> _showItemDialog({InventoryItem? item}) async {
  final nameCtrl = TextEditingController(text: item?.name ?? '');
  final emojiCtrl = TextEditingController(text: item?.emoji ?? '');
  final weightCtrl = TextEditingController(text: item?.weightG.toString() ?? '');
  final priceCtrl = TextEditingController(text: item?.pricePerKg.toString() ?? '');
  // ignore: prefer_final_locals
  bool available = item?.available ?? true;

  await showDialog<void>(
    context: context,
    builder: (dialogCtx) {
      return StatefulBuilder(
        builder: (dialogCtx, setStateDialog) {
          return AlertDialog(
            title: Text(item == null ? 'Добавить продукт' : 'Редактировать продукт'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emojiCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Эмодзи (🍣, 🍕, 🍇 и т.д.)',
                    ),
                  ),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Название'),
                  ),
                  TextField(
                    controller: weightCtrl,
                    decoration: const InputDecoration(labelText: 'Вес (г)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: 'Цена за 1 кг'),
                    keyboardType: TextInputType.number,
                  ),
                  SwitchListTile(
                    title: const Text('Доступен'),
                    value: available,
                    onChanged: (v) => setStateDialog(() => available = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
                },
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final emoji = emojiCtrl.text.trim();
                  final weight = double.tryParse(weightCtrl.text) ?? 0;
                  final price = double.tryParse(priceCtrl.text)  ?? 0;

                  if (name.isEmpty || emoji.isEmpty || weight <= 0 || price <= 0) {
                    if (dialogCtx.mounted) {
                      ScaffoldMessenger.of(dialogCtx).showSnackBar(
                        const SnackBar(content: Text('Заполните все поля корректно')),
                      );
                    }
                    return;
                  }

                  final newItem = InventoryItem(
                    id: item?.id ?? '',
                    name: name,
                    emoji: emoji,
                    weightG: weight,
                    pricePerKg: price,
                    available: available,
                    createdAt: item?.createdAt ?? DateTime.now(),
                  );

                  if (item == null) {
                    await InventoryService.createInventoryItem(newItem, widget.token);
                  } else {
                    await InventoryService.updateInventoryItem(item.id, newItem, widget.token);
                  }

                  if (dialogCtx.mounted) Navigator.of(dialogCtx).pop();
                  if (!mounted) return;
                  await _fetchInventory();
                },
                child: const Text('Сохранить'),
              ),
            ],
          );
        },
      );
    },
  );
}


  // 10. Карточка элемента
  Widget _buildItemCard(InventoryItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade100,
            child: Text(
              item.emoji ?? '🍽️',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 100,
            child: Text('#${item.id.substring(0, 8)}',
                style: const TextStyle(color: Colors.grey)),
          ),
          SizedBox(
            width: 80,
            child: Text('${item.pricePerKg.toStringAsFixed(2)} ₽/кг'),
          ),
          SizedBox(
            width: 80,
            child: Text('${item.weightG.toStringAsFixed(0)} г'),
          ),
          SizedBox(width: 120, child: _buildStatusBadge(item.available)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showItemDialog(item: item),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteItem(item.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 11. Основной билд
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) => _buildItemCard(_filteredItems[i]),
                ),
              ],
            ),
          );
  }
}



