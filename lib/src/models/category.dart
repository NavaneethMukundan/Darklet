class Category {
  final String id;
  final String name;
  final String image;

  /// Hex colour (`0xFFRRGGBB`) used for the category tile gradient.
  final int tint;

  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.tint,
  });

  factory Category.fromJson(Map<String, dynamic> j) => Category(
    id: j['id'] as String,
    name: j['name'] as String,
    image: (j['image'] ?? '') as String,
    tint: (j['tint'] ?? 0xFF6CAC00) as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'tint': tint,
  };
}
