class User {
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

  User({
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
    final name = json['name'] ?? '';
    return User(
      id: json['id'] ?? '',
      name: name,
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      address: json['address'] ?? '',
      bio: json['bio'] ?? '',
      birthday: json['birthday'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      lastActive: DateTime.tryParse(json['last_active'] ?? '') ?? DateTime.now(),
      online: json['online'] ?? false,
      orders: json['orders'] ?? 0,
      avatarLetter: json['avatar_letter'] ?? (name.isNotEmpty ? name[0].toUpperCase() : '?'),
    );
  }

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

