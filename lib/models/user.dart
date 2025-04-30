class User {
  // 1️⃣ Сначала — конструкторы
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    required this.bio,
    required this.birthday,
    required this.createdAt,
    required this.lastActive,
    required this.online,
    required this.orders,
    required this.avatarLetter,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final nameValue = json['name'] as String? ?? '';
    return User(
      id: json['id'] as String? ?? '',
      name: nameValue,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      address: json['address'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      lastActive: DateTime.tryParse(json['last_active'] as String? ?? '') ??
          DateTime.now(),
      online: json['online'] as bool? ?? false,
      orders: json['orders'] as int? ?? 0,
      avatarLetter: json['avatar_letter'] as String? ??
          (nameValue.isNotEmpty ? nameValue[0].toUpperCase() : '?'),
    );
  }

  // 2️⃣ Затем — поля
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String address;
  final String bio;
  final String birthday;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool online;
  final int orders;
  final String avatarLetter;

  // 3️⃣ И только потом — остальные методы
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'bio': bio,
      'birthday': birthday,
      'created_at': createdAt.toIso8601String(),
      'last_active': lastActive.toIso8601String(),
      'online': online,
      'orders': orders,
      'avatar_letter': avatarLetter,
    };
  }
}


