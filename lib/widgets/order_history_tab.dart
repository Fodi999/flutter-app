import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sushi_app/models/order.dart';
import 'package:sushi_app/services/order_service.dart';
import 'package:sushi_app/services/cart_service.dart';
import 'package:sushi_app/state/cart_state.dart';
import 'package:sushi_app/utils/log_helper.dart';

class OrderHistoryTab extends ConsumerStatefulWidget {
  final String userId;
  final String token;
  final VoidCallback onOpenCart; // ✅ добавлено

  const OrderHistoryTab({
    super.key,
    required this.userId,
    required this.token,
    required this.onOpenCart, // ✅ зарегистрировано
  });

  @override
  ConsumerState<OrderHistoryTab> createState() => _OrderHistoryTabState();
}

class _OrderHistoryTabState extends ConsumerState<OrderHistoryTab> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void didUpdateWidget(covariant OrderHistoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId || oldWidget.token != widget.token) {
      _loadOrders();
    }
  }

  void _loadOrders() {
    logInfo('Загрузка заказов пользователя ${widget.userId}', tag: 'OrderHistory');
    setState(() {
      _ordersFuture = OrderService.fetchOrders(
        token: widget.token,
        userId: widget.userId,
      );
    });
  }

  Future<void> _repeatOrder(BuildContext context, Order order) async {
    try {
      await OrderService.repeatOrderToCart(
        token: widget.token,
        userId: widget.userId,
        orderId: order.id,
      );

      final cart = await CartService.getCart(
        userId: widget.userId,
        token: widget.token,
      );
      ref.read(cartStateProvider.notifier).set(cart.items);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Товары из заказа #${order.id} добавлены в корзину'),
          action: SnackBarAction(
            label: 'Открыть',
            onPressed: widget.onOpenCart, // ✅ добавлено
          ),
        ),
      );
    } catch (e, st) {
      logError('❌ Ошибка повтора заказа', error: e, stackTrace: st, tag: 'OrderHistory');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось повторить заказ')),
      );
    }
  }

  String formatDate(DateTime dt) {
    final d = dt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year} ${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'новый':
        return Colors.orange;
      case 'в пути':
        return Colors.blue;
      case 'доставлен':
        return Colors.green;
      case 'отменен':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dt = Theme.of(context).textTheme;

    return FutureBuilder<List<Order>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          logError('Ошибка загрузки заказов', error: snapshot.error, tag: 'OrderHistory');
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ошибка загрузки заказов.'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loadOrders,
                  child: const Text('Повторить'),
                ),
              ],
            ),
          );
        }

        final orders = snapshot.data!;
        logInfo('Загружено заказов: ${orders.length}', tag: 'OrderHistory');

        if (orders.isEmpty) {
          return const Center(child: Text('У вас пока нет заказов.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, i) {
            final order = orders[i];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Заказ #${order.id}', style: dt.titleMedium),
                      subtitle: Text('Создан: ${formatDate(order.createdAt)}'),
                      trailing: Chip(
                        label: Text(order.status),
                        backgroundColor: _statusColor(order.status, context).withOpacity(0.15),
                        labelStyle: TextStyle(
                          color: _statusColor(order.status, context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(),
                    Wrap(
                      runSpacing: 8,
                      children: order.items.map((item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.name.isNotEmpty ? item.name : 'Без названия'} x${item.quantity}'),
                            Text('${(item.price * item.quantity).toStringAsFixed(0)}₽'),
                          ],
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Итого:'),
                        Text(
                          '${order.totalPrice.toStringAsFixed(0)}₽',
                          style: dt.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Адрес: ${order.address}',
                      style: dt.bodySmall?.copyWith(color: Colors.grey[700]),
                    ),
                    if (order.comment != null && order.comment!.isNotEmpty)
                      Text(
                        'Комментарий: ${order.comment}',
                        style: dt.bodySmall?.copyWith(color: Colors.grey[700]),
                      ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.repeat),
                        label: const Text('Повторить'),
                        onPressed: () => _repeatOrder(context, order),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}






