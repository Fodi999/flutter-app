import 'package:flutter/material.dart';
import '../../models/inventory_item.dart';
import '../../services/inventory_service.dart';

class ManageInventoryScreen extends StatefulWidget {
  final String token;
  const ManageInventoryScreen({super.key, required this.token});

  @override
  State<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> {
  List<InventoryItem> items = [];
  List<InventoryItem> filteredItems = [];
  String searchQuery = '';
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    setState(() => isLoading = true);
    try {
      final fetched = await InventoryService.getInventoryItems();
      setState(() {
        items = fetched;
        _applyFilter();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteItem(String id) async {
    try {
      await InventoryService.deleteInventoryItem(id, widget.token);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Продукт удалён')),
      );
      _fetchInventory(); // Обновить список после удаления
    } catch (e) {
      debugPrint('Ошибка при удалении: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при удалении продукта')),
      );
    }
  }

  void _applyFilter() {
    final query = searchQuery.toLowerCase();
    setState(() {
      filteredItems = items.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
    });
  }

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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Склад', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Row(children: [
          SizedBox(
            width: 250,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Поиск...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _applyFilter();
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _showItemDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Добавить продукт'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ])
      ],
    );
  }

  Future<void> _showItemDialog({InventoryItem? item}) async {
    final nameController = TextEditingController(text: item?.name ?? '');
    final emojiController = TextEditingController(text: item?.emoji ?? '');
    final weightController = TextEditingController(text: item?.weightG.toString() ?? '');
    final priceController = TextEditingController(text: item?.pricePerKg.toString() ?? '');
    bool available = item?.available ?? true;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(item == null ? 'Добавить продукт' : 'Редактировать продукт'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emojiController,
                  decoration: const InputDecoration(labelText: 'Эмодзи (🍣, 🍕, 🍇 и т.д.)'),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Вес (г)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Цена за 1 кг'),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: const Text('Доступен'),
                  value: available,
                  onChanged: (val) => setStateDialog(() => available = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final emoji = emojiController.text.trim();
                final weight = double.tryParse(weightController.text) ?? 0;
                final price = double.tryParse(priceController.text) ?? 0;

                if (name.isEmpty || weight <= 0 || price <= 0 || emoji.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Заполните все поля корректно')),
                  );
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

                Navigator.pop(context);
                _fetchInventory();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(InventoryItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade100,
          child: Text(
            item.emoji ?? '🍽️',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600))),
        SizedBox(width: 100, child: Text('#${item.id.substring(0, 8)}', style: const TextStyle(color: Colors.grey))),
        SizedBox(width: 80, child: Text('${item.pricePerKg.toStringAsFixed(2)} ₽/кг')),
        SizedBox(width: 80, child: Text('${item.weightG.toStringAsFixed(0)} г')),
        SizedBox(width: 120, child: _buildStatusBadge(item.available)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showItemDialog(item: item)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(item.id)),
          ],
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildItemCard(filteredItems[index]);
                  },
                )
              ],
            ),
          );
  }
}

