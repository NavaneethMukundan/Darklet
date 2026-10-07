class Address {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String line1;
  final String city;
  final String state;
  final String zip;
  final String country;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.line1,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    this.isDefault = false,
  });

  String get oneLine => '$line1, $city, $state $zip, $country';

  Address copyWith({
    String? label,
    String? fullName,
    String? phone,
    String? line1,
    String? city,
    String? state,
    String? zip,
    String? country,
    bool? isDefault,
  }) => Address(
    id: id,
    label: label ?? this.label,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    line1: line1 ?? this.line1,
    city: city ?? this.city,
    state: state ?? this.state,
    zip: zip ?? this.zip,
    country: country ?? this.country,
    isDefault: isDefault ?? this.isDefault,
  );

  factory Address.fromJson(Map<String, dynamic> j) => Address(
    id: j['id'] as String,
    label: (j['label'] ?? '') as String,
    fullName: (j['fullName'] ?? '') as String,
    phone: (j['phone'] ?? '') as String,
    line1: (j['line1'] ?? '') as String,
    city: (j['city'] ?? '') as String,
    state: (j['state'] ?? '') as String,
    zip: (j['zip'] ?? '') as String,
    country: (j['country'] ?? '') as String,
    isDefault: (j['isDefault'] ?? false) as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'fullName': fullName,
    'phone': phone,
    'line1': line1,
    'city': city,
    'state': state,
    'zip': zip,
    'country': country,
    'isDefault': isDefault,
  };
}
