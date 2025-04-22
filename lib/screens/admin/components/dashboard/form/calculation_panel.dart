import 'package:flutter/material.dart';

class CalculationPanel extends StatelessWidget {
  final double cost;
  final int output;
  final VoidCallback onSave;
  final VoidCallback onClear;

  const CalculationPanel({
    Key? key,
    required this.cost,
    required this.output,
    required this.onSave,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Калькуляция',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Себестоимость: ${cost.toStringAsFixed(2)} ₽'),
                Text('Выход: $output г'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onSave,
                  child: const Text('Сохранить'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onClear,
                  child: const Text('Очистить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
