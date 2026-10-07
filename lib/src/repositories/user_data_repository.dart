import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/saved_card.dart';

/// Per-user data that should follow the user across devices:
/// cart, wishlist, addresses and notifications.
abstract class UserDataRepository {
  Future<List<CartItem>> loadCart(String userId);
  Future<void> saveCart(String userId, List<CartItem> items);

  Future<List<String>> loadWishlist(String userId);
  Future<void> saveWishlist(String userId, List<String> productIds);

  Future<List<SavedCard>> loadCards(String userId);
  Future<void> saveCards(String userId, List<SavedCard> cards);

  Future<List<Address>> loadAddresses(String userId);
  Future<void> saveAddresses(String userId, List<Address> addresses);

  Future<List<AppNotification>> loadNotifications(String userId);
  Future<void> saveNotifications(
    String userId,
    List<AppNotification> notifications,
  );
}
