class Category {
  // 1. Сразу после заголовка класса — все конструкторы
  const Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  // 2. Затем — все поля
  final String id;
  final String name;

  // 3. И только потом — остальные методы
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
