import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final double totalSum;
  final int totalItems;
  final String userId;
  final String token;

  const OrderSuccessScreen({
    Key? key,
    required this.totalSum,
    required this.totalItems,
    required this.userId,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dt = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: cs.primary, size: 72),
              const SizedBox(height: 16),
              Text(
                'Заказ оформлен!',
                style: dt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Спасибо за ваш заказ. Мы уже начали его готовить.',
                style: dt.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Информация о заказе
              Card(
                color: cs.surfaceVariant.withOpacity(0.4),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Товаров:'),
                          Text(
                            '$totalItems шт.',
                            style: dt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Сумма:'),
                          Text(
                            '${totalSum.toStringAsFixed(0)} ₽',
                            style: dt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Кнопки
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/profile',
                    (_) => false,
                    arguments: {
                      'userId': userId,
                      'token': token,
                    },
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text('Вернуться в профиль'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/profile',
                    (_) => false,
                    arguments: {
                      'userId': userId,
                      'token': token,
                      'tabIndex': 2, // История заказов
                    },
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('История заказов'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

