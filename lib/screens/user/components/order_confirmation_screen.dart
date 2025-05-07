// lib/screens/user/components/order_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:sushi_app/models/cart.dart';
import 'package:sushi_app/models/user.dart';
import 'package:sushi_app/services/order_service.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final User user;
  final String token;

  const OrderConfirmationScreen({
    Key? key,
    required this.cartItems,
    required this.user,
    required this.token,
  }) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late List<CartItem> _items;
  late TextEditingController _nameC;
  late TextEditingController _phoneC;
  late TextEditingController _addressC;
  final TextEditingController _commentC = TextEditingController();

  @override
  void initState() {
    super.initState();
    // создаём локальную копию корзины, чтобы можно было редактировать UI
    _items = List<CartItem>.from(widget.cartItems);
    _nameC = TextEditingController(text: widget.user.name);
    _phoneC = TextEditingController(text: widget.user.phone);
    _addressC = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _addressC.dispose();
    _commentC.dispose();
    super.dispose();
  }

  int get _totalQty => _items.fold(0, (sum, e) => sum + e.quantity);
  double get _totalSum => _items.fold(0.0, (sum, e) => sum + e.quantity * e.price);

  void _inc(CartItem ci) {
    setState(() {
      _items = _items
          .map((e) => e.id == ci.id ? e.copyWith(quantity: e.quantity + 1) : e)
          .toList();
    });
  }

  void _dec(CartItem ci) {
    setState(() {
      _items = _items.fold<List<CartItem>>([], (acc, e) {
        if (e.id == ci.id) {
          if (e.quantity > 1) {
            acc.add(e.copyWith(quantity: e.quantity - 1));
          }
        } else {
          acc.add(e);
        }
        return acc;
      });
    });
  }

  void _remove(CartItem ci) {
    setState(() {
      _items.removeWhere((e) => e.id == ci.id);
    });
  }

  Future<void> _submitOrder() async {
    try {
      await OrderService.createOrder(
        token: widget.token,
        userId: widget.user.id,
        name: _nameC.text,
        phone: _phoneC.text,
        address: _addressC.text,
        comment:
            _commentC.text.trim().isEmpty ? null : _commentC.text.trim(),
        items: _items
            .map((ci) => {
                  'menuItemId': ci.menuItemId,
                  'quantity': ci.quantity,
                  'price': ci.price,
                })
            .toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заказ успешно оформлен!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при оформлении заказа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dt = Theme.of(context).textTheme;

    BoxDecoration boxDecor() => BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        );

    Widget formBox() => Container(
          decoration: boxDecor(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Данные получателя', style: dt.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nameC,
                decoration: const InputDecoration(labelText: 'Имя'),
              ),
              TextField(
                controller: _phoneC,
                decoration: const InputDecoration(labelText: 'Телефон'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _addressC,
                decoration:
                    const InputDecoration(labelText: 'Адрес доставки'),
                maxLines: 2,
              ),
              TextField(
                controller: _commentC,
                decoration: const InputDecoration(
                    labelText: 'Комментарий (необязательно)'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Всего товаров:',
                      style: dt.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('$_totalQty',
                      style: dt.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Сумма заказа:',
                      style: dt.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text('${_totalSum.toStringAsFixed(0)} ₽',
                      style: dt.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _items.isEmpty ? null : _submitOrder,
                  child: const Text('Подтвердить заказ'),
                ),
              ),
            ],
          ),
        );

    Widget itemsBox() => Container(
          decoration: boxDecor(),
          padding: const EdgeInsets.all(8),
          child: _items.isEmpty
              ? Center(child: Text('Корзина пуста', style: dt.bodyMedium))
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: cs.outline.withOpacity(0.3)),
                  itemBuilder: (_, i) {
                    final ci = _items[i];
                    final total = (ci.price * ci.quantity).toStringAsFixed(0);
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            ci.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: cs.surfaceVariant,
                              child: const Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ci.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: dt.bodyMedium),
                              const SizedBox(height: 2),
                              Text('${ci.price.toStringAsFixed(0)} ₽/шт.',
                                  style: dt.bodySmall
                                      ?.copyWith(color: cs.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _dec(ci),
                          visualDensity: VisualDensity.compact,
                        ),
                        Text('${ci.quantity}', style: dt.bodyMedium),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _inc(ci),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 4),
                        Text('$total ₽',
                            style: dt.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Удалить позицию',
                          onPressed: () => _remove(ci),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    );
                  },
                ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заказа'),
        leading: const BackButton(),
      ),
      body: LayoutBuilder(builder: (ctx, constraints) {
        final wide = constraints.maxWidth >= 800;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: wide
              ? Row(
                  children: [
                    Flexible(flex: 3, child: formBox()),
                    const SizedBox(width: 16),
                    Flexible(flex: 5, child: itemsBox()),
                  ],
                )
              : Column(
                  children: [
                    formBox(),
                    const SizedBox(height: 16),
                    Expanded(child: itemsBox()),
                  ],
                ),
        );
      }),
    );
  }
}











