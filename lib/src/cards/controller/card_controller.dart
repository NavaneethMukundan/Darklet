import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:darklet/src/utils/helpers/user_scoped_controller.dart';

class CardController extends UserScopedController {
  final UserDataRepository _repo;
  CardController(this._repo);

  List<SavedCard> _items = [];
  bool loading = false;
  List<SavedCard> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  SavedCard? get defaultCard =>
      _items.where((c) => c.isDefault).firstOrNull ?? _items.firstOrNull;

  SavedCard? byId(String? id) =>
      id == null ? null : _items.where((c) => c.id == id).firstOrNull;

  @override
  void resetState() {
    _items = [];
    loading = false;
  }

  @override
  Future<void> loadForUser(String uid) async {
    loading = true;
    notifyListeners();
    _items = await _repo.loadCards(uid);
    loading = false;
  }

  /// Saves a card (the newest becomes the default) and returns it.
  SavedCard add({
    required String number,
    required String holder,
    required String expiry,
  }) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final card = SavedCard(
      id: 'c${DateTime.now().microsecondsSinceEpoch}',
      brand: SavedCard.detectBrand(digits),
      last4: digits.substring(digits.length - 4),
      holder: holder.trim(),
      expiry: expiry,
      isDefault: true,
    );
    _items = [card, ..._items.map((c) => c.copyWith(isDefault: false))];
    _changed();
    return card;
  }

  void setDefault(String id) {
    _items = [for (final c in _items) c.copyWith(isDefault: c.id == id)];
    _changed();
  }

  void remove(String id) {
    final wasDefault = byId(id)?.isDefault ?? false;
    _items = _items.where((c) => c.id != id).toList();
    if (wasDefault && _items.isNotEmpty) {
      _items[0] = _items[0].copyWith(isDefault: true);
    }
    _changed();
  }

  void _changed() {
    notifyListeners();
    final id = uid;
    if (id != null) _repo.saveCards(id, _items);
  }
}
