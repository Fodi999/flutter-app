import 'package:flutter/material.dart';
import 'package:sushi_app/models/ingredient.dart';

class IngredientTable extends StatelessWidget {
  // 1️⃣ Сначала — конструктор с super-parameter
  const IngredientTable({
    super.key,
    required this.ingredients,
    required this.onSelect,
    required this.onUpdateGrams,
    required this.onUpdateWaste,
    required this.onDelete,
  });

  // 2️⃣ Затем — поля
  final List<Ingredient> ingredients;
  final void Function(int index) onSelect;
  final void Function(int index, int grams) onUpdateGrams;
  final void Function(int index, double waste) onUpdateWaste;
  final void Function(int index) onDelete;

  // 3️⃣ И только потом — вспомогательные методы
  Widget _numberField(String initialValue, void Function(String) onChanged) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration:
            const InputDecoration(isDense: true, border: OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('🧾 Ингредиенты',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('🧾 Ингредиент')),
              DataColumn(label: Text('⚖️ Граммы')),
              DataColumn(label: Text('💸 1г')),
              DataColumn(label: Text('🗑️ Потери %')),
              DataColumn(label: Text('📦 Цена с потерями')),
              DataColumn(label: Text('💰 Стоимость')),
              DataColumn(label: Text('')),
            ],
            rows: ingredients.asMap().entries.map((entry) {
              final i = entry.key;
              final ing = entry.value;
              return DataRow(cells: [
                DataCell(
                  InkWell(
                    onTap: () => onSelect(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ing.productName.isNotEmpty
                            ? ing.productName
                            : 'Выбрать',
                        style: TextStyle(
                          color: ing.productName.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(_numberField(
                  ing.amountGrams.toString(),
                  (v) => onUpdateGrams(i, int.tryParse(v) ?? 0),
                )),
                DataCell(
                    Text((ing.pricePerKg / 1000).toStringAsFixed(2))),
                DataCell(_numberField(
                  ing.wastePercent.toString(),
                  (v) => onUpdateWaste(i, double.tryParse(v) ?? 0),
                )),
                DataCell(Text(ing.priceAfterWaste.toStringAsFixed(3))),
                DataCell(Text('${ing.totalCost.toStringAsFixed(2)} ₽')),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(i),
                )),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }
}


