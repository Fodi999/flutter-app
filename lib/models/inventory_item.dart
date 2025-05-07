class InventoryItem {
  // 1️⃣ Конструктор
  const InventoryItem({
    required this.id,
    required this.name,
    required this.weightG,
    required this.pricePerKg,
    required this.available,
    required this.createdAt,
    this.emoji,
    required this.category,
  });

  // 2️⃣ fromJson
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String? ?? '',
      name: json['product_name'] as String? ?? '',
      weightG: (json['weight_grams'] as num?)?.toDouble() ?? 0.0,
      pricePerKg: (json['price_per_kg'] as num?)?.toDouble() ?? 0.0,
      available: json['available'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      emoji: json['emoji'] as String?,
      category: json['category'] as String? ?? 'прочее',
    );
  }

  // 3️⃣ Поля
  final String id;
  final String name;
  final double weightG;
  final double pricePerKg;
  final bool available;
  final DateTime createdAt;
  final String? emoji;
  final String category;

  // 4️⃣ toJson
  Map<String, dynamic> toJson() {
    return {
      'product_name': name,
      'weight_grams': weightG,
      'price_per_kg': pricePerKg,
      'available': available,
      'emoji': emoji,
      'category': category,
    };
  }
}





