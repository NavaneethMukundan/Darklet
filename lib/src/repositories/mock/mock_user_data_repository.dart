import 'dart:convert';

import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserDataRepository implements UserDataRepository {
  final AssetBundle bundle;
  MockUserDataRepository({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  Future<List<dynamic>?> _read(String key) async {
    final raw = (await SharedPreferences.getInstance()).getString(key);
    return raw == null ? null : jsonDecode(raw) as List<dynamic>;
  }

  Future<void> _write(String key, Object value) async =>
      (await SharedPreferences.getInstance()).setString(key, jsonEncode(value));

  @override
  Future<List<CartItem>> loadCart(String userId) async =>
      (await _read('$userId.cart') ?? [])
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();

  @override
  Future<void> saveCart(String userId, List<CartItem> items) =>
      _write('$userId.cart', items.map((e) => e.toJson()).toList());

  @override
  Future<List<String>> loadWishlist(String userId) async =>
      List<String>.from(await _read('$userId.wishlist') ?? []);

  @override
  Future<void> saveWishlist(String userId, List<String> ids) =>
      _write('$userId.wishlist', ids);

  @override
  Future<List<SavedCard>> loadCards(String userId) async =>
      (await _read('$userId.cards') ?? [])
          .map((e) => SavedCard.fromJson(Map<String, dynamic>.from(e)))
          .toList();

  @override
  Future<void> saveCards(String userId, List<SavedCard> cards) =>
      _write('$userId.cards', cards.map((e) => e.toJson()).toList());

  @override
  Future<List<Address>> loadAddresses(String userId) async {
    final saved = await _read('$userId.addresses');
    if (saved != null) {
      return saved
          .map((e) => Address.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    // The demo account starts with one address.
    if (userId == 'demo-user') {
      final seed = jsonDecode(
        await bundle.loadString('assets/mock/seed_user.json'),
      );
      return [Address.fromJson(Map<String, dynamic>.from(seed['address']))];
    }
    return [];
  }

  @override
  Future<void> saveAddresses(String userId, List<Address> addresses) =>
      _write('$userId.addresses', addresses.map((e) => e.toJson()).toList());

  @override
  Future<List<AppNotification>> loadNotifications(String userId) async {
    final saved = await _read('$userId.notifications');
    final raw =
        saved ??
        jsonDecode(await bundle.loadString('assets/mock/notifications.json'))
            as List<dynamic>;
    return raw
        .map((e) => AppNotification.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> saveNotifications(
    String userId,
    List<AppNotification> notifications,
  ) => _write(
    '$userId.notifications',
    notifications.map((e) => e.toJson()).toList(),
  );
}
