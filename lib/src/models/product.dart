class Product {
  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final String description;
  final double price;
  final double? oldPrice;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFlashSale;
  final Map<String, String> specs;

  /// Selectable options (storage, colour...). Each value can add to the price.
  final List<ProductOption> options;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.images,
    this.rating = 0,
    this.reviewCount = 0,
    this.stock = 0,
    this.isFlashSale = false,
    this.specs = const {},
    this.options = const [],
  });

  /// First value of every option.
  List<int> get defaultSelection => List.filled(options.length, 0);

  /// Price with the chosen option values applied.
  double priceFor(List<int> selection) {
    var p = price;
    for (var i = 0; i < options.length && i < selection.length; i++) {
      p += options[i].values[selection[i]].priceDelta;
    }
    return p;
  }

  /// Readable label such as `256 GB • Black` (empty without options).
  String variantLabel(List<int> selection) => [
    for (var i = 0; i < options.length && i < selection.length; i++)
      options[i].values[selection[i]].label,
  ].join(' • ');

  String get image => images.isEmpty ? '' : images.first;
  bool get inStock => stock > 0;
  int get discountPercent => oldPrice == null || oldPrice! <= price
      ? 0
      : (((oldPrice! - price) / oldPrice!) * 100).round();

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as String,
    name: j['name'] as String,
    brand: (j['brand'] ?? '') as String,
    categoryId: (j['categoryId'] ?? '') as String,
    description: (j['description'] ?? '') as String,
    price: (j['price'] as num).toDouble(),
    oldPrice: (j['oldPrice'] as num?)?.toDouble(),
    images: List<String>.from(j['images'] ?? const []),
    rating: ((j['rating'] ?? 0) as num).toDouble(),
    reviewCount: ((j['reviewCount'] ?? 0) as num).toInt(),
    stock: ((j['stock'] ?? 0) as num).toInt(),
    isFlashSale: (j['isFlashSale'] ?? false) as bool,
    specs: Map<String, String>.from(j['specs'] ?? const {}),
    options: (j['options'] as List? ?? const [])
        .map((e) => ProductOption.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'brand': brand,
    'categoryId': categoryId,
    'description': description,
    'price': price,
    'oldPrice': oldPrice,
    'images': images,
    'rating': rating,
    'reviewCount': reviewCount,
    'stock': stock,
    'isFlashSale': isFlashSale,
    'specs': specs,
    'options': options.map((e) => e.toJson()).toList(),
  };
}

class OptionValue {
  final String label;
  final double priceDelta;

  /// Hex colour (`0xFFRRGGBB`) - shown as a swatch when set.
  final int? swatch;
  const OptionValue(this.label, {this.priceDelta = 0, this.swatch});

  factory OptionValue.fromJson(Map<String, dynamic> j) => OptionValue(
    j['label'] as String,
    priceDelta: ((j['priceDelta'] ?? 0) as num).toDouble(),
    swatch: j['swatch'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'label': label,
    'priceDelta': priceDelta,
    'swatch': swatch,
  };
}

class ProductOption {
  final String name;
  final List<OptionValue> values;
  const ProductOption(this.name, this.values);

  factory ProductOption.fromJson(Map<String, dynamic> j) => ProductOption(
    j['name'] as String,
    (j['values'] as List)
        .map((e) => OptionValue.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'values': values.map((e) => e.toJson()).toList(),
  };
}
