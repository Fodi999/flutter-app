import 'package:flutter/material.dart';
import 'package:sushi_app/models/inventory_item.dart';
import 'package:sushi_app/services/inventory_service.dart';
import 'components/inventory/inventory_item_dialog.dart';

class ManageInventoryScreen extends StatefulWidget {
  const ManageInventoryScreen({super.key, required this.token});
  final String token;

  @override
  State<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> with TickerProviderStateMixin {
  List<InventoryItem> _items = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  final Map<String, String> _categoryToEmoji = {
    'сыры': '🧀',
    'рыба': '🐟',
    'соусы': '🥣',
    'овощи': '🥑',
    'рис': '🍚',
    'суши': '🍣',
    'зелень': '🥬',
    'прочее': '🍽️',
  };

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

  Future<void> _fetchInventory() async {
    setState(() => _isLoading = true);
    try {
      final fetched = await InventoryService.getInventoryItems(widget.token);
      if (!mounted) return;
      setState(() {
        _items = fetched;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<InventoryItem> _getItemsForCategory(String categoryKey) {
    final query = _searchController.text.toLowerCase();
    return _items.where((item) {
      final itemCategory = item.category?.toLowerCase() ?? 'прочее';
      final matchesCategory = itemCategory == categoryKey;
      final matchesQuery = item.name.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> _deleteItem(String id) async {
    try {
      await InventoryService.deleteInventoryItem(id, widget.token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Продукт удалён')));
      await _fetchInventory();
    } catch (e) {
      debugPrint('Ошибка: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ошибка при удалении')));
      }
    }
  }

  Future<void> _showItemDialog({InventoryItem? item}) async {
    await showDialog(
      context: context,
      builder: (_) => InventoryItemDialog(
        item: item,
        onSubmit: (newItem) async {
          if (item == null) {
            await InventoryService.createInventoryItem(newItem, widget.token);
          } else {
            await InventoryService.updateInventoryItem(item.id, newItem, widget.token);
          }
          await _fetchInventory();
        },
      ),
    );
  }

  Widget _buildStatusBadge(bool available) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: available ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? 'Активен' : 'Нет в наличии',
        style: TextStyle(
          color: available ? theme.colorScheme.primary : theme.colorScheme.error,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildItemCard(InventoryItem item) {
    final theme = Theme.of(context);
    final emoji = (item.emoji != null && item.emoji!.isNotEmpty) ? item.emoji! : '🍽️';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24, fontFamily: 'NotoEmoji'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: theme.textTheme.titleMedium),
                      Text('#${item.id.substring(0, 8)}',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                _buildStatusBadge(item.available),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              children: [
                Text(
                  '${item.weightG.toStringAsFixed(0)} г',
                  style: TextStyle(
                    color: item.weightG < 1000 ? Colors.red : null,
                    fontWeight: item.weightG < 1000 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text('${item.pricePerKg.toStringAsFixed(2)} ₽/кг'),
                Row(
                  mainAxisSize: MainAxisSize.min,
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _categoryToEmoji.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Склад'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _categoryToEmoji.entries
                .map((e) => Tab(child: Text('${e.value} ${e.key.capitalize()}')))
                .toList(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 250,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Поиск...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showItemDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Добавить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: _categoryToEmoji.keys.map((categoryKey) {
                  final items = _getItemsForCategory(categoryKey);
                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: items.length,
                    itemBuilder: (context, i) => _buildItemCard(items[i]),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

extension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}


