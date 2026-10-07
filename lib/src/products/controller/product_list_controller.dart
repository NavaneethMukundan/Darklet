import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:flutter/foundation.dart';

/// Paginated, filterable product listing. One instance per list screen.
class ProductListController extends ChangeNotifier {
  final ProductRepository _repo;
  final int pageSize;

  ProductListController(
    this._repo, {
    ProductQuery initial = const ProductQuery(),
    this.pageSize = AppConfig.pageSize,
  }) : _query = initial;

  ProductQuery _query;
  LoadStatus status = LoadStatus.idle;
  bool loadingMore = false;
  bool hasMore = false;
  int _page = 0;
  int _token = 0; // discards responses from superseded requests
  final List<Product> items = [];
  List<String> brands = [];

  ProductQuery get query => _query;

  Future<void> load() async {
    final token = ++_token;
    status = LoadStatus.loading;
    _page = 0;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repo.searchProducts(_query, page: 0, pageSize: pageSize),
        if (brands.isEmpty) _repo.getBrands(),
      ]);
      if (token != _token) return;
      final page = results[0] as ProductPage;
      if (results.length > 1) brands = results[1] as List<String>;
      items
        ..clear()
        ..addAll(page.items);
      hasMore = page.hasMore;
      status = LoadStatus.loaded;
    } catch (e) {
      if (token != _token) return;
      debugPrint('Product list failed: $e');
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    if (loadingMore || !hasMore || status != LoadStatus.loaded) return;
    final token = _token;
    loadingMore = true;
    notifyListeners();
    try {
      final page = await _repo.searchProducts(
        _query,
        page: _page + 1,
        pageSize: pageSize,
      );
      if (token != _token) return;
      _page++;
      items.addAll(page.items);
      hasMore = page.hasMore;
    } catch (e) {
      debugPrint('Load more failed: $e');
    }
    loadingMore = false;
    notifyListeners();
  }

  Future<void> setQuery(ProductQuery q) {
    _query = q;
    return load();
  }

  Future<void> setText(String text) => setQuery(_query.copyWith(query: text));
}
