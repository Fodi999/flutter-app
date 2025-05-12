import 'package:flutter/material.dart';
import 'package:sushi_app/models/order.dart';
import 'package:sushi_app/services/order_service.dart';

class ManageOrdersScreen extends StatefulWidget {
  final String token;

  const ManageOrdersScreen({super.key, required this.token});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  late Future<List<Order>> _ordersFuture;
  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await OrderService.fetchAllOrders(widget.token);
      if (!mounted) return;
      setState(() {
        _allOrders = orders;
        _filteredOrders = orders;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки заказов: $e')),
      );
    }
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        return order.name.toLowerCase().contains(query) ||
            order.userId.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы пользователей'),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Поиск по имени или ID пользователя',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredOrders.isEmpty
                ? const Center(child: Text('Нет заказов'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (_, i) {
                      final order = _filteredOrders[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${order.name} (${order.phone})',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text('User ID: ${order.userId}'),
                              Text('Адрес: ${order.address}'),
                              if (order.comment != null &&
                                  order.comment!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('Комментарий: ${order.comment}'),
                                ),
                              const SizedBox(height: 8),
                              Text('Товары:',
                                  style: theme.textTheme.labelMedium),
                              const SizedBox(height: 4),
                              ...order.items.map((item) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${item.name} x${item.quantity}'),
                                      Text(
                                          '${(item.price * item.quantity).toStringAsFixed(0)}₽'),
                                    ],
                                  )),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Сумма:',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Text('${order.totalPrice.toStringAsFixed(0)}₽',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('Статус: ${order.status}'),
                              Text(
                                'Создан: ${order.createdAt.toLocal().toString().substring(0, 16)}',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

