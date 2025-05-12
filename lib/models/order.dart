import 'cart.dart';

class Order {
  final int id;
  final String userId;
  final String name;
  final String phone;
  final String address;
  final String? comment;
  final List<CartItem> items;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.comment,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json['ID'] ?? 0,
      userId: json['userId'] as String,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      comment: json['comment'] as String?,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt']),
    );

}
