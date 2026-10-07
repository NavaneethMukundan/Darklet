import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:darklet/src/utils/helpers/user_scoped_controller.dart';

class CartController extends UserScopedController {
  static const maxQuantity = 10;

  final UserDataRepository _repo;
  CartController(this._repo);

  List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (s, i) => s + i.quantity);
  double get subtotal => _items.fold(0, (s, i) => s + i.total);

  int quantityOf(String productId) => _items
      .where((i) => i.productId == productId)
      .fold(0, (s, i) => s + i.quantity);

  /// Guest items waiting to be merged into the account that just signed in.
  List<CartItem> _guestItems = [];

  @override
  void bindUser(String? userId) {
    // Signing in from guest mode: carry the guest's cart over.
    final from = uid;
    if (from == 'guest' && userId != null && userId != 'guest') {
      _guestItems = List.of(_items);
    }
    super.bindUser(userId);
  }

  @override
  void resetState() => _items = [];

  @override
  Future<void> loadForUser(String uid) async {
    _items = await _repo.loadCart(uid);
    if (_guestItems.isNotEmpty) {
      for (final g in _guestItems) {
        final i = _items.indexWhere((e) => e.lineId == g.lineId);
        if (i >= 0) {
          _items[i] = _items[i].copyWith(
            quantity: (_items[i].quantity + g.quantity).clamp(1, maxQuantity),
          );
        } else {
          _items.add(g);
        }
      }
      _guestItems = [];
      await _repo.saveCart(uid, _items);
      await _repo.saveCart(
        'guest',
        const [],
      ); // guest cart is now in the account
    }
  }

  /// Adds [product]. [selection] holds the chosen value index of each option
  /// (defaults to the first value of every option).
  void add(Product product, {int quantity = 1, List<int>? selection}) {
    final sel = selection ?? product.defaultSelection;
    addItem(
      CartItem.fromProduct(
        product,
        quantity: quantity,
        variant: product.variantLabel(sel),
        price: product.priceFor(sel),
      ),
    );
  }

  /// Adds a ready-made line (also used by "Buy again"). Merges equal lines.
  void addItem(CartItem item) {
    final i = _items.indexWhere((e) => e.lineId == item.lineId);
    if (i >= 0) {
      _items[i] = _items[i].copyWith(
        quantity: (_items[i].quantity + item.quantity).clamp(1, maxQuantity),
      );
    } else {
      _items.add(item.copyWith(quantity: item.quantity.clamp(1, maxQuantity)));
    }
    _changed();
  }

  void setQuantity(String lineId, int quantity) {
    if (quantity <= 0) return remove(lineId);
    final i = _items.indexWhere((e) => e.lineId == lineId);
    if (i < 0) return;
    _items[i] = _items[i].copyWith(quantity: quantity.clamp(1, maxQuantity));
    _changed();
  }

  void remove(String lineId) {
    _items.removeWhere((e) => e.lineId == lineId);
    _changed();
  }

  /// Puts a removed item back (used by the "Undo" snackbar action).
  void restore(CartItem item) {
    if (_items.any((e) => e.lineId == item.lineId)) return;
    _items.add(item);
    _changed();
  }

  void clear() {
    _items = [];
    _changed();
  }

  void _changed() {
    notifyListeners();
    final id = uid;
    if (id != null) _repo.saveCart(id, _items);
  }
}
