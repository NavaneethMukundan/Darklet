import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:darklet/src/utils/helpers/user_scoped_controller.dart';

class WishlistController extends UserScopedController {
  final UserDataRepository _userData;
  final ProductRepository _products;
  WishlistController(this._userData, this._products);

  List<Product> _items = [];
  bool loading = false;
  List<Product> get items => List.unmodifiable(_items);

  bool contains(String productId) => _items.any((p) => p.id == productId);

  /// Guest favourites waiting to be merged into the account that just signed in.
  List<Product> _guestItems = [];

  @override
  void bindUser(String? userId) {
    final from = uid;
    if (from == 'guest' && userId != null && userId != 'guest') {
      _guestItems = List.of(_items);
    }
    super.bindUser(userId);
  }

  @override
  void resetState() {
    _items = [];
    loading = false;
  }

  @override
  Future<void> loadForUser(String uid) async {
    loading = true;
    notifyListeners();
    final ids = await _userData.loadWishlist(uid);
    _items = ids.isEmpty ? [] : await _products.getProductsByIds(ids);
    if (_guestItems.isNotEmpty) {
      for (final g in _guestItems) {
        if (!contains(g.id)) _items.insert(0, g);
      }
      _guestItems = [];
      await _userData.saveWishlist(uid, _items.map((p) => p.id).toList());
      await _userData.saveWishlist('guest', const []);
    }
    loading = false;
  }

  void toggle(Product product) {
    if (contains(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.insert(0, product);
    }
    notifyListeners();
    final id = uid;
    if (id != null) {
      _userData.saveWishlist(id, _items.map((p) => p.id).toList());
    }
  }
}
