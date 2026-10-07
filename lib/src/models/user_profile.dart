class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarUrl,
  });

  UserProfile copyWith({String? name, String? phone, String? avatarUrl}) =>
      UserProfile(
        id: id,
        name: name ?? this.name,
        email: email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    id: j['id'] as String,
    name: (j['name'] ?? '') as String,
    email: (j['email'] ?? '') as String,
    phone: (j['phone'] ?? '') as String,
    avatarUrl: j['avatarUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatarUrl': avatarUrl,
  };
}
