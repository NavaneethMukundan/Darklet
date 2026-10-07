/// A saved payment card. Only display data is kept - never the full number or
/// CVC (real gateways return a token / payment-method id instead).
class SavedCard {
  final String id;
  final String brand; // visa, mastercard, amex, card
  final String last4;
  final String holder;
  final String expiry; // MM/YY
  final bool isDefault;

  const SavedCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.holder,
    required this.expiry,
    this.isDefault = false,
  });

  SavedCard copyWith({bool? isDefault}) => SavedCard(
    id: id,
    brand: brand,
    last4: last4,
    holder: holder,
    expiry: expiry,
    isDefault: isDefault ?? this.isDefault,
  );

  static String detectBrand(String number) {
    final d = number.replaceAll(RegExp(r'\D'), '');
    if (d.startsWith('4')) return 'visa';
    if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(d)) return 'mastercard';
    if (RegExp(r'^3[47]').hasMatch(d)) return 'amex';
    return 'card';
  }

  factory SavedCard.fromJson(Map<String, dynamic> j) => SavedCard(
    id: j['id'] as String,
    brand: (j['brand'] ?? 'card') as String,
    last4: (j['last4'] ?? '') as String,
    holder: (j['holder'] ?? '') as String,
    expiry: (j['expiry'] ?? '') as String,
    isDefault: (j['isDefault'] ?? false) as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'last4': last4,
    'holder': holder,
    'expiry': expiry,
    'isDefault': isDefault,
  };
}
