import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';

/// Cart, wishlist, addresses and notifications live in Firestore so they sync
/// across devices: `carts/{uid}`, `wishlists/{uid}`, `users/{uid}/meta/*`.
class FirebaseUserDataRepository implements UserDataRepository {
  final FirebaseFirestore _db;
  FirebaseUserDataRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _meta(String uid, String name) =>
      _db.collection('users').doc(uid).collection('meta').doc(name);

  List<Map<String, dynamic>> _list(Map<String, dynamic>? data) =>
      List<Map<String, dynamic>>.from(
        (data?['items'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

  @override
  Future<List<CartItem>> loadCart(String userId) async => _list(
    (await _db.collection('carts').doc(userId).get()).data(),
  ).map(CartItem.fromJson).toList();

  @override
  Future<void> saveCart(String userId, List<CartItem> items) => _db
      .collection('carts')
      .doc(userId)
      .set({'items': items.map((e) => e.toJson()).toList()});

  @override
  Future<List<String>> loadWishlist(String userId) async {
    final data = (await _db.collection('wishlists').doc(userId).get()).data();
    return List<String>.from(data?['ids'] ?? []);
  }

  @override
  Future<void> saveWishlist(String userId, List<String> ids) =>
      _db.collection('wishlists').doc(userId).set({'ids': ids});

  @override
  Future<List<SavedCard>> loadCards(String userId) async => _list(
    (await _meta(userId, 'cards').get()).data(),
  ).map(SavedCard.fromJson).toList();

  @override
  Future<void> saveCards(String userId, List<SavedCard> cards) => _meta(
    userId,
    'cards',
  ).set({'items': cards.map((e) => e.toJson()).toList()});

  @override
  Future<List<Address>> loadAddresses(String userId) async => _list(
    (await _meta(userId, 'addresses').get()).data(),
  ).map(Address.fromJson).toList();

  @override
  Future<void> saveAddresses(String userId, List<Address> addresses) => _meta(
    userId,
    'addresses',
  ).set({'items': addresses.map((e) => e.toJson()).toList()});

  @override
  Future<List<AppNotification>> loadNotifications(String userId) async => _list(
    (await _meta(userId, 'notifications').get()).data(),
  ).map(AppNotification.fromJson).toList();

  @override
  Future<void> saveNotifications(String userId, List<AppNotification> items) =>
      _meta(
        userId,
        'notifications',
      ).set({'items': items.map((e) => e.toJson()).toList()});
}
