class Review {
  final String id;
  final String productId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> j) => Review(
    id: j['id'] as String,
    productId: j['productId'] as String,
    userName: (j['userName'] ?? '') as String,
    rating: ((j['rating'] ?? 0) as num).toInt(),
    comment: (j['comment'] ?? '') as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };
}
