import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';

/// Sends the guest user's data to on-device storage and everyone else's to
/// the real backend, so browsing as a guest never needs a server account.
class RoutedUserDataRepository implements UserDataRepository {
  static const guestId = 'guest';

  final UserDataRepository local;
  final UserDataRepository remote;
  const RoutedUserDataRepository({required this.local, required this.remote});

  UserDataRepository _for(String uid) => uid == guestId ? local : remote;

  @override
  Future<List<CartItem>> loadCart(String u) => _for(u).loadCart(u);
  @override
  Future<void> saveCart(String u, List<CartItem> v) => _for(u).saveCart(u, v);
  @override
  Future<List<String>> loadWishlist(String u) => _for(u).loadWishlist(u);
  @override
  Future<void> saveWishlist(String u, List<String> v) =>
      _for(u).saveWishlist(u, v);
  @override
  Future<List<SavedCard>> loadCards(String u) => _for(u).loadCards(u);
  @override
  Future<void> saveCards(String u, List<SavedCard> v) =>
      _for(u).saveCards(u, v);
  @override
  Future<List<Address>> loadAddresses(String u) => _for(u).loadAddresses(u);
  @override
  Future<void> saveAddresses(String u, List<Address> v) =>
      _for(u).saveAddresses(u, v);
  @override
  Future<List<AppNotification>> loadNotifications(String u) =>
      _for(u).loadNotifications(u);
  @override
  Future<void> saveNotifications(String u, List<AppNotification> v) =>
      _for(u).saveNotifications(u, v);
}
