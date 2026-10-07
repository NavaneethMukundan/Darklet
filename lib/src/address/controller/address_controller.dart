import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:darklet/src/utils/helpers/user_scoped_controller.dart';

class AddressController extends UserScopedController {
  final UserDataRepository _repo;
  AddressController(this._repo);

  List<Address> _items = [];
  List<Address> get items => List.unmodifiable(_items);

  Address? get defaultAddress =>
      _items.where((a) => a.isDefault).firstOrNull ?? _items.firstOrNull;

  @override
  void resetState() => _items = [];

  @override
  Future<void> loadForUser(String uid) async =>
      _items = await _repo.loadAddresses(uid);

  /// Adds a new address or replaces the one with the same id.
  void save(Address address) {
    final i = _items.indexWhere((a) => a.id == address.id);
    final makeDefault = address.isDefault || _items.isEmpty;
    final saved = address.copyWith(isDefault: makeDefault);
    if (i >= 0) {
      _items[i] = saved;
    } else {
      _items.add(saved);
    }
    if (makeDefault) {
      _items = [
        for (final a in _items) a.copyWith(isDefault: a.id == saved.id),
      ];
    }
    _changed();
  }

  void delete(String id) {
    final wasDefault =
        _items.where((a) => a.id == id).firstOrNull?.isDefault ?? false;
    _items.removeWhere((a) => a.id == id);
    if (wasDefault && _items.isNotEmpty) {
      _items[0] = _items[0].copyWith(isDefault: true);
    }
    _changed();
  }

  void setDefault(String id) {
    _items = [for (final a in _items) a.copyWith(isDefault: a.id == id)];
    _changed();
  }

  void _changed() {
    notifyListeners();
    final id = uid;
    if (id != null) _repo.saveAddresses(id, _items);
  }
}
