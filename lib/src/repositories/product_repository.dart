import 'package:darklet/src/models/category.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/models/review.dart';

enum ProductSort { relevance, priceLowHigh, priceHighLow, topRated }

/// Filters + sorting for a product listing.
class ProductQuery {
  final String query;
  final String? categoryId;
  final Set<String> brands;
  final double? minPrice;
  final double? maxPrice;
  final ProductSort sort;

  const ProductQuery({
    this.query = '',
    this.categoryId,
    this.brands = const {},
    this.minPrice,
    this.maxPrice,
    this.sort = ProductSort.relevance,
  });

  ProductQuery copyWith({
    String? query,
    Object? categoryId = _keep,
    Set<String>? brands,
    Object? minPrice = _keep,
    Object? maxPrice = _keep,
    ProductSort? sort,
  }) => ProductQuery(
    query: query ?? this.query,
    categoryId: identical(categoryId, _keep)
        ? this.categoryId
        : categoryId as String?,
    brands: brands ?? this.brands,
    minPrice: identical(minPrice, _keep) ? this.minPrice : minPrice as double?,
    maxPrice: identical(maxPrice, _keep) ? this.maxPrice : maxPrice as double?,
    sort: sort ?? this.sort,
  );

  /// Number of active filters (excluding text query and sort).
  int get activeFilters =>
      (categoryId != null ? 1 : 0) +
      brands.length +
      (minPrice != null || maxPrice != null ? 1 : 0);

  static const Object _keep = Object();
}

class ProductPage {
  final List<Product> items;
  final bool hasMore;
  const ProductPage(this.items, {this.hasMore = false});
}

/// Catalogue access. Implement this to plug in your own REST API.
abstract class ProductRepository {
  Future<List<Category>> getCategories();

  Future<ProductPage> searchProducts(
    ProductQuery query, {
    int page = 0,
    int pageSize = 10,
  });

  Future<Product?> getProduct(String id);
  Future<List<Product>> getProductsByIds(List<String> ids);
  Future<List<Product>> getFlashSale();
  Future<List<String>> getBrands();

  Future<List<Review>> getReviews(String productId);
  Future<Review> addReview(Review review);
}

/// Shared in-memory filtering used by the mock and Firestore repositories.
List<Product> applyProductQuery(List<Product> all, ProductQuery q) {
  final text = q.query.trim().toLowerCase();
  final list = all.where((p) {
    if (q.categoryId != null && p.categoryId != q.categoryId) return false;
    if (q.brands.isNotEmpty && !q.brands.contains(p.brand)) return false;
    if (q.minPrice != null && p.price < q.minPrice!) return false;
    if (q.maxPrice != null && p.price > q.maxPrice!) return false;
    if (text.isNotEmpty &&
        !('${p.name} ${p.brand} ${p.description}'.toLowerCase()).contains(
          text,
        )) {
      return false;
    }
    return true;
  }).toList();
  switch (q.sort) {
    case ProductSort.priceLowHigh:
      list.sort((a, b) => a.price.compareTo(b.price));
    case ProductSort.priceHighLow:
      list.sort((a, b) => b.price.compareTo(a.price));
    case ProductSort.topRated:
      list.sort((a, b) => b.rating.compareTo(a.rating));
    case ProductSort.relevance:
      break;
  }
  return list;
}
