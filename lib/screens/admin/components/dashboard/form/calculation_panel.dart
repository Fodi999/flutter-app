import 'package:flutter/material.dart';

class CalculationPanel extends StatelessWidget {
  const CalculationPanel({
    super.key,
    required this.cost,
    required this.output,
    required this.price,
    required this.onSaveDraft,
    required this.onSaveAndPublish,
    required this.onClear,
    this.isStepCompleted = false,
  });

  final double cost;
  final int output;
  final double price;
  final VoidCallback onSaveDraft;
  final VoidCallback onSaveAndPublish;
  final VoidCallback onClear;
  final bool isStepCompleted;

  @override
  Widget build(BuildContext context) {
    final profit = price - cost;
    final costPerGram = output > 0 ? cost / output : 0;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Шаг 3. Калькуляция',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Себестоимость: ${cost.toStringAsFixed(2)} ₽'),
                    Text('Цена продажи: ${price.toStringAsFixed(2)} ₽'),
                    Text('Прибыль: ${profit.toStringAsFixed(2)} ₽'),
                    Text('Себестоимость за г: ${costPerGram.toStringAsFixed(3)} ₽/г'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Выход: $output г'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isStepCompleted ? onSaveDraft : null,
                    child: const Text('Сохранить как черновик'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isStepCompleted ? onSaveAndPublish : null,
                    child: const Text('Сохранить и опубликовать'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onClear,
                child: const Text('Очистить всё'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


