// lib/models/menu_item.dart

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double costPrice;
  final String imageUrl;
  final double margin;
  final DateTime createdAt;
  final String categoryId;
  final bool published;
  final String? categoryName; // ← теперь необязательный

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.costPrice,
    required this.imageUrl,
    required this.margin,
    required this.createdAt,
    required this.categoryId,
    required this.published,
    this.categoryName, // ← не required
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      costPrice: (json['cost_price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      margin: (json['margin'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      categoryId: json['category_id'] as String,
      published: json['published'] as bool,
      categoryName: json['category_name'], // ← может быть null
    );
  }

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final data = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'cost_price': costPrice,
      'image_url': imageUrl,
      'category_id': categoryId,
      'published': published,
    };
    if (forUpdate) data['id'] = id;
    return data;
  }
}









