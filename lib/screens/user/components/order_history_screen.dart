import 'package:flutter/material.dart';
import 'package:sushi_app/models/order.dart';
import 'package:sushi_app/services/order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  final String userId;
  final String token;

  const OrderHistoryScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.fetchOrders(
      token: widget.token,
      userId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('История заказов')),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('У вас пока нет заказов.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Заказ #${order.id}', style: dt.titleMedium),
                      const SizedBox(height: 4),
                      Text('Адрес: ${order.address}'),
                      if (order.comment != null && order.comment!.isNotEmpty)
                        Text('Комментарий: ${order.comment}'),
                      const Divider(),
                      ...order.items.map((item) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.name} x${item.quantity}'),
                              Text('${(item.price * item.quantity).toStringAsFixed(0)}₽'),
                            ],
                          )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Итого:'),
                          Text('${order.totalPrice.toStringAsFixed(0)}₽',
                              style: dt.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Статус: ${order.status}'),
                      Text('Создан: ${order.createdAt.toLocal().toString().substring(0, 16)}',
                          style: dt.bodySmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
