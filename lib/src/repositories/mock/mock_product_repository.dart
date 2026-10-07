import 'dart:convert';

import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/category.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/models/review.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads the catalogue from `assets/mock/*.json`.
/// Reviews written by the user are kept in SharedPreferences.
class MockProductRepository implements ProductRepository {
  final AssetBundle bundle;
  final Duration latency;

  MockProductRepository({AssetBundle? bundle, Duration? latency})
    : bundle = bundle ?? rootBundle,
      latency = latency ?? AppConfig.mockLatency;

  List<Product>? _products;
  List<Category>? _categories;
  List<Review>? _seedReviews;

  static const _reviewsKey = 'mock_user_reviews';

  Future<void> _delay() => Future<void>.delayed(latency);

  Future<List<dynamic>> _json(String name) async =>
      jsonDecode(await bundle.loadString('assets/mock/$name')) as List<dynamic>;

  Future<List<Product>> _all() async => _products ??= (await _json(
    'products.json',
  )).map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();

  @override
  Future<List<Category>> getCategories() async {
    await _delay();
    return _categories ??= (await _json(
      'categories.json',
    )).map((e) => Category.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<ProductPage> searchProducts(
    ProductQuery query, {
    int page = 0,
    int pageSize = 10,
  }) async {
    await _delay();
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
  Future<Product?> getProduct(String id) async {
    await _delay();
    return (await _all()).where((p) => p.id == id).firstOrNull;
  }

  @override
  Future<List<Product>> getProductsByIds(List<String> ids) async {
    await _delay();
    final all = await _all();
    return [
      for (final id in ids)
        if (all.any((p) => p.id == id)) all.firstWhere((p) => p.id == id),
    ];
  }

  @override
  Future<List<Product>> getFlashSale() async {
    await _delay();
    return (await _all()).where((p) => p.isFlashSale).toList();
  }

  @override
  Future<List<String>> getBrands() async =>
      ((await _all()).map((p) => p.brand).toSet().toList()..sort());

  @override
  Future<List<Review>> getReviews(String productId) async {
    await _delay();
    _seedReviews ??= (await _json(
      'reviews.json',
    )).map((e) => Review.fromJson(Map<String, dynamic>.from(e))).toList();
    final prefs = await SharedPreferences.getInstance();
    final mine = (prefs.getStringList(_reviewsKey) ?? []).map(
      (s) => Review.fromJson(jsonDecode(s) as Map<String, dynamic>),
    );
    final list =
        [
            ..._seedReviews!,
            ...mine,
          ].where((r) => r.productId == productId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<Review> addReview(Review review) async {
    await _delay();
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_reviewsKey) ?? [];
    list.add(jsonEncode(review.toJson()));
    await prefs.setStringList(_reviewsKey, list);
    return review;
  }
}
