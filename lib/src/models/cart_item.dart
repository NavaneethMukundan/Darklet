import 'package:darklet/src/models/product.dart';

/// A product snapshot plus quantity. Storing the snapshot keeps the cart
/// readable even if the catalogue changes later.
///
/// [variant] is a readable label of the chosen options (e.g. `256 GB • Black`);
/// [price] already includes the options' price differences.
class CartItem {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String variant;

  const CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.variant = '',
  });

  factory CartItem.fromProduct(
    Product p, {
    int quantity = 1,
    String variant = '',
    double? price,
  }) => CartItem(
    productId: p.id,
    name: p.name,
    image: p.image,
    price: price ?? p.price,
    quantity: quantity,
    variant: variant,
  );

  /// Unique cart line: the same product with different options is a different line.
  String get lineId => variant.isEmpty ? productId : '$productId|$variant';

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    name: name,
    image: image,
    price: price,
    quantity: quantity ?? this.quantity,
    variant: variant,
  );

  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
    productId: j['productId'] as String,
    name: j['name'] as String,
    image: (j['image'] ?? '') as String,
    price: (j['price'] as num).toDouble(),
    quantity: ((j['quantity'] ?? 1) as num).toInt(),
    variant: (j['variant'] ?? '') as String,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'image': image,
    'price': price,
    'quantity': quantity,
    'variant': variant,
  };
}
