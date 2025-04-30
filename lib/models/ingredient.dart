class Ingredient {
  // 1. Сначала — все конструкторы
  Ingredient({
    required this.productName,
    required this.amountGrams,
    required this.pricePerKg,
    required this.wastePercent,
    required this.priceAfterWaste,
    required this.totalCost,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      productName: json['product_name'] as String? ?? '',
      amountGrams: json['amount_grams'] as int? ?? 0,
      pricePerKg: (json['price_per_kg'] as num? ?? 0).toDouble(),
      wastePercent: (json['waste_percent'] as num? ?? 0).toDouble(),
      priceAfterWaste: (json['price_after_waste'] as num? ?? 0).toDouble(),
      totalCost: (json['total_cost'] as num? ?? 0).toDouble(),
    );
  }

  // 2. Затем — поля
  final String productName;
  final int amountGrams;
  final double pricePerKg;
  final double wastePercent;
  final double priceAfterWaste;
  final double totalCost;

  // 3. И только потом — остальные методы
  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'amount_grams': amountGrams,
      'price_per_kg': pricePerKg,
      'waste_percent': wastePercent,
      'price_after_waste': priceAfterWaste,
      'total_cost': totalCost,
    };
  }
}


