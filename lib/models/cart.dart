// lib/models/cart.dart

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
        id: (json['ID'] as num).toInt(),
        userId: json['userId'] as String,
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class CartItem {
  final int    id;
  final int    cartId;
  final String menuItemId;
  final String name;
  final int    quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.cartId,
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id:        (json['ID']      as num).toInt(),
        cartId:    (json['CartID']  as num).toInt(),
        menuItemId: json['menuItemId'] as String,
        name:       json['name']       as String,
        quantity:  (json['quantity'] as num).toInt(),
        price:     (json['price']    as num).toDouble(),
        imageUrl:   json['imageUrl'] as String? ?? '',
      );

  /// Создаёт копию с изменёнными полями (по-умолчанию — без изменений).
  CartItem copyWith({
    int?    quantity,
    double? price,
  }) =>
      CartItem(
        id: id,
        cartId: cartId,
        menuItemId: menuItemId,
        name: name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        imageUrl: imageUrl,
      );
}






