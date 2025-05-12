class AdBanner {
  final String id; // ← здесь теперь String
  final String imageUrl;
  final String text;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdBanner({
    required this.id,
    required this.imageUrl,
    required this.text,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdBanner.fromJson(Map<String, dynamic> json) {
    return AdBanner(
      id: json['id'],
      imageUrl: json['image_url'],
      text: json['text'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

