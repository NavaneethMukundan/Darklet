import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darklet/src/models/category.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/models/review.dart';
import 'package:darklet/src/repositories/product_repository.dart';

/// Firestore catalogue: collections `categories`, `products`, `reviews`.
///
/// The catalogue is fetched once and cached; filtering, sorting and
/// pagination run on the device. For very large catalogues replace
/// [searchProducts] with server-side queries or a search service.
class FirebaseProductRepository implements ProductRepository {
  final FirebaseFirestore _db;
  FirebaseProductRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  List<Product>? _cache;

  Future<List<Product>> _all() async {
    if (_cache != null) return _cache!;
    final snap = await _db.collection('products').get();
    return _cache = snap.docs
        .map((d) => Product.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final snap = await _db.collection('categories').get();
    return snap.docs
        .map((d) => Category.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  @override
  Future<ProductPage> searchProducts(
    ProductQuery query, {
    int page = 0,
    int pageSize = 10,
  }) async {
    final filtered = applyProductQuery(await _all(), query);
    final start = page * pageSize;
    if (start >= filtered.length) return const ProductPage([]);
    final end = (start + pageSize).clamp(0, filtered.length);
    return ProductPage(
      filtered.sublist(start, end),
      hasMore: end < filtered.length,
    );
  }

  @override
  Future<Product?> getProduct(String id) async =>
      (await _all()).where((p) => p.id == id).firstOrNull;

  @override
  Future<List<Product>> getProductsByIds(List<String> ids) async {
    final all = await _all();
    return [for (final id in ids) ...all.where((p) => p.id == id)];
  }

  @override
  Future<List<Product>> getFlashSale() async =>
      (await _all()).where((p) => p.isFlashSale).toList();

  @override
  Future<List<String>> getBrands() async =>
      ((await _all()).map((p) => p.brand).toSet().toList()..sort());

  @override
  Future<List<Review>> getReviews(String productId) async {
    final snap = await _db
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();
    return snap.docs
        .map((d) => Review.fromJson({...d.data(), 'id': d.id}))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Review> addReview(Review review) async {
    final ref = await _db.collection('reviews').add(review.toJson());
    return Review.fromJson({...review.toJson(), 'id': ref.id});
  }
}
