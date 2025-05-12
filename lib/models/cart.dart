class Cart {
  final int id;
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: (json['ID'] ?? 0) as int,
        userId: json['userId'] as String,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'ID': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
      };
}

class CartItem {
  final int id;
  final int cartId;
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  /// Дополнительные параметры блюда (например, размер, добавки)
  final Map<String, dynamic> options;

  CartItem({
    required this.id,
    required this.cartId,
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    this.options = const {},
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: (json['ID'] ?? 0) as int,
        cartId: (json['CartID'] ?? 0) as int,
        menuItemId: json['menuItemId'] ?? '',
        name: json['name'] as String? ?? '',
        quantity: (json['quantity'] ?? 0) as int,
        price: (json['price'] ?? 0).toDouble(),
        imageUrl: json['imageUrl'] ?? '',
        options: json['options'] != null && json['options'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['options'])
            : {},
      );

  CartItem copyWith({
    int? quantity,
    double? price,
    Map<String, dynamic>? options,
  }) =>
      CartItem(
        id: id,
        cartId: cartId,
        menuItemId: menuItemId,
        name: name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        imageUrl: imageUrl,
        options: options ?? this.options,
      );

  Map<String, dynamic> toJson() => {
        'ID': id,
        'CartID': cartId,
        'menuItemId': menuItemId,
        'name': name,
        'quantity': quantity,
        'price': price,
        'imageUrl': imageUrl,
        'options': options,
      };
}








