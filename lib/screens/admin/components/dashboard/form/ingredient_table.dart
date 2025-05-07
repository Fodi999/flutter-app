import 'package:flutter/material.dart';
import 'package:sushi_app/models/ingredient.dart';

class IngredientTable extends StatelessWidget {
  const IngredientTable({
    super.key,
    required this.ingredients,
    required this.onSelect,
    required this.onUpdateGrams,
    required this.onUpdateWaste,
    required this.onDelete,
  });

  final List<Ingredient> ingredients;
  final void Function(int index) onSelect;
  final void Function(int index, int grams) onUpdateGrams;
  final void Function(int index, double waste) onUpdateWaste;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'Ингредиенты не добавлены.',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Шаг 2. Ингредиенты',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),

        // Заголовки колонок (необязательно, можно убрать)
        Row(
          children: const [
            Expanded(flex: 3, child: Text('Ингредиент')),
            SizedBox(width: 8),
            Expanded(flex: 2, child: Text('Гр.', textAlign: TextAlign.center)),
            SizedBox(width: 8),
            Expanded(flex: 2, child: Text('1г', textAlign: TextAlign.center)),
            SizedBox(width: 8),
            Expanded(flex: 2, child: Text('%', textAlign: TextAlign.center)),
            SizedBox(width: 8),
            Expanded(flex: 2, child: Text('С учётом', textAlign: TextAlign.center)),
            SizedBox(width: 8),
            Expanded(flex: 2, child: Text('Стоимость', textAlign: TextAlign.center)),
            SizedBox(width: 40), // для кнопки удаления
          ],
        ),
        const Divider(),

        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ingredients.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final ing = ingredients[i];
            final pricePerGram = ing.pricePerKg / 1000;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1) Название / выбор ингредиента
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () => onSelect(i),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ing.productName.isNotEmpty
                            ? ing.productName
                            : 'Выбрать инг.',
                        style: TextStyle(
                          color: ing.productName.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 2) Граммы
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: ing.amountGrams.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Гр.',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        onUpdateGrams(i, int.tryParse(v) ?? 0),
                    validator: (v) {
                      final val = int.tryParse(v ?? '');
                      if (val == null || val <= 0) return '';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // 3) Цена за 1 грамм + иконка подсказки
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pricePerGram.toStringAsFixed(2)),
                      const SizedBox(width: 4),
                      Tooltip(
                        message: 'Цена за 1 грамм без учёта отходов',
                        child: const Icon(Icons.info_outline, size: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 4) Процент отходов
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: ing.wastePercent.toString(),
                    decoration: const InputDecoration(
                      labelText: '%',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        onUpdateWaste(i, double.tryParse(v) ?? 0),
                    validator: (v) {
                      final val = double.tryParse(v ?? '');
                      if (val == null || val < 0 || val > 100) return '';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // 5) Цена с учётом отходов + иконка
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(ing.priceAfterWaste.toStringAsFixed(3)),
                      const SizedBox(width: 4),
                      Tooltip(
                        message:
                            'Цена за 1 грамм с учётом процента отходов',
                        child: const Icon(Icons.info_outline, size: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 6) Итоговая стоимость + иконка
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${ing.totalCost.toStringAsFixed(2)} ₽'),
                      const SizedBox(width: 4),
                      Tooltip(
                        message: 'Итоговая стоимость ингредиента',
                        child: const Icon(Icons.info_outline, size: 16),
                      ),
                    ],
                  ),
                ),

                // 7) Удалить
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(i),
                  tooltip: 'Удалить ингредиент',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}





