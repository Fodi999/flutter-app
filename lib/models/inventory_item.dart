class InventoryItem {
  final String id;
  final String name;
  final double weightG;
  final double pricePerKg;
  final bool available;
  final DateTime createdAt;
  final String? emoji; // ✅ Новое поле

  InventoryItem({
    required this.id,
    required this.name,
    required this.weightG,
    required this.pricePerKg,
    required this.available,
    required this.createdAt,
    this.emoji, // ✅ Добавляем
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['product_name'],
      weightG: (json['weight_grams'] as num).toDouble(),
      pricePerKg: (json['price_per_kg'] as num).toDouble(),
      available: json['available'],
      createdAt: DateTime.parse(json['created_at']),
      emoji: json['emoji'], // ✅ Добавляем
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': name,
      'weight_grams': weightG,
      'price_per_kg': pricePerKg,
      'available': available,
      'emoji': emoji, // ✅ Добавляем
    };
  }
}



