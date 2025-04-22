import 'ingredient.dart';

class MenuCalculation {
  final String id;
  final String menuItemId;
  final List<Ingredient> ingredients;
  final double totalWeightG;
  final double totalCost;
  final DateTime createdAt;

  MenuCalculation({
    required this.id,
    required this.menuItemId,
    required this.ingredients,
    required this.totalWeightG,
    required this.totalCost,
    required this.createdAt,
  });

factory MenuCalculation.fromJson(Map<String, dynamic> json) {
  return MenuCalculation(
    id: json['id'] ?? '',
    menuItemId: json['menu_item_id'] ?? '',
    ingredients: (json['ingredients'] as List<dynamic>?)
            ?.map((e) => Ingredient.fromJson(e))
            .toList() ??
        [],
    totalWeightG: (json['total_weight_g'] ?? 0).toDouble(),
    totalCost: (json['total_cost'] ?? 0).toDouble(),
    createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'total_weight_g': totalWeightG,
      'total_cost': totalCost,
    };
  }
}

