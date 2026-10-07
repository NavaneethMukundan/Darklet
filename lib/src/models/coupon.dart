/// A promo code. Percent off, fixed amount off, or free shipping.
class Coupon {
  final String code;
  final String type; // percent | amount | freeShipping
  final double value;
  final double minSubtotal;
  final String description;

  const Coupon({
    required this.code,
    required this.type,
    this.value = 0,
    this.minSubtotal = 0,
    this.description = '',
  });

  bool get isFreeShipping => type == 'freeShipping';

  /// Discount on [subtotal] (never more than the subtotal).
  double discountFor(double subtotal) {
    final d = switch (type) {
      'percent' => subtotal * value / 100,
      'amount' => value,
      _ => 0.0,
    };
    return d.clamp(0, subtotal).toDouble();
  }

  factory Coupon.fromJson(Map<String, dynamic> j) => Coupon(
    code: (j['code'] as String).toUpperCase(),
    type: (j['type'] ?? 'percent') as String,
    value: ((j['value'] ?? 0) as num).toDouble(),
    minSubtotal: ((j['minSubtotal'] ?? 0) as num).toDouble(),
    description: (j['description'] ?? '') as String,
  );
}
