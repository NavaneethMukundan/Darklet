import 'dart:convert';

import 'package:darklet/src/models/category.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

/// Data for the home screen: categories, flash sale, recently viewed.
class HomeController extends ChangeNotifier {
  static const _recentKey = 'recently_viewed';
  static const maxRecent = 10;

  final ProductRepository _repo;
  final SharedPreferences? _prefs;
  HomeController(this._repo, this._prefs);

  LoadStatus status = LoadStatus.idle;
  List<Category> categories = [];
  List<Product> flashSale = [];
  List<Product> recentlyViewed = [];

  Category? categoryById(String id) =>
      categories.where((c) => c.id == id).firstOrNull;

  Future<void> load({bool force = false}) async {
    if (status == LoadStatus.loading) return;
    if (status == LoadStatus.loaded && !force) return;
    status = LoadStatus.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repo.getCategories(),
        _repo.getFlashSale(),
      ]);
      categories = results[0] as List<Category>;
      flashSale = results[1] as List<Product>;
      recentlyViewed = await _repo.getProductsByIds(_recentIds());
      status = LoadStatus.loaded;
    } catch (e) {
      debugPrint('Home load failed: $e');
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  List<String> _recentIds() {
    final raw = _prefs?.getString(_recentKey);
    return raw == null ? [] : List<String>.from(jsonDecode(raw) as List);
  }

  /// Records that [product] was opened (most recent first, no duplicates).
  Future<void> markViewed(Product product) async {
    recentlyViewed = [
      product,
      ...recentlyViewed.where((p) => p.id != product.id),
    ].take(maxRecent).toList();
    notifyListeners();
    await _prefs?.setString(
      _recentKey,
      jsonEncode(recentlyViewed.map((p) => p.id).toList()),
    );
  }
}
