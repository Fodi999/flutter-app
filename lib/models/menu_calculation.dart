import 'ingredient.dart';

class MenuCalculation {
  // 1. Конструктор сразу после объявления класса
  const MenuCalculation({
    required this.id,
    required this.menuItemId,
    required this.ingredients,
    required this.totalWeightG,
    required this.totalCost,
    required this.createdAt,
  });

  // 2. Фабричный конструктор из JSON
  factory MenuCalculation.fromJson(Map<String, dynamic> json) {
    return MenuCalculation(
      id: json['id'] as String? ?? '',
      menuItemId: json['menu_item_id'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalWeightG: (json['total_weight_g'] as num? ?? 0).toDouble(),
      totalCost: (json['total_cost'] as num? ?? 0).toDouble(),
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  // 3. Затем — поля
  final String id;
  final String menuItemId;
  final List<Ingredient> ingredients;
  final double totalWeightG;
  final double totalCost;
  final DateTime createdAt;

  // 4. И только потом — методы (toJson)
  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'total_weight_g': totalWeightG,
      'total_cost': totalCost,
      // при необходимости можно добавить 'id' и 'created_at'
    };
  }
}


