
class InventoryItem {
  // 1️⃣ Сначала — конструкторы
  const InventoryItem({
    required this.id,
    required this.name,
    required this.weightG,
    required this.pricePerKg,
    required this.available,
    required this.createdAt,
    this.emoji,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String? ?? '',
      name: json['product_name'] as String? ?? '',
      weightG: (json['weight_grams'] as num?)?.toDouble() ?? 0.0,
      pricePerKg: (json['price_per_kg'] as num?)?.toDouble() ?? 0.0,
      available: json['available'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      emoji: json['emoji'] as String?,
    );
  }

  // 2️⃣ Затем — поля
  final String id;
  final String name;
  final double weightG;
  final double pricePerKg;
  final bool available;
  final DateTime createdAt;
  final String? emoji;

  // 3️⃣ И только потом — вспомогательные методы
  Map<String, dynamic> toJson() {
    return {
      'product_name': name,
      'weight_grams': weightG,
      'price_per_kg': pricePerKg,
      'available': available,
      'emoji': emoji,
    };
  }
}




