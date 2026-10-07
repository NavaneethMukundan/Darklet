import 'dart:async';

import 'package:flutter/foundation.dart';

/// Base class for controllers whose data belongs to the signed-in user
/// (cart, wishlist, addresses...). `bindUser` is called from a
/// `ChangeNotifierProxyProvider` whenever the auth state changes.
abstract class UserScopedController extends ChangeNotifier {
  String? _uid;
  bool _disposed = false;

  String? get uid => _uid;

  /// Clear in-memory state (called synchronously, must not notify).
  @protected
  void resetState();

  /// Load the user's data (called after [resetState] when a user is bound).
  @protected
  Future<void> loadForUser(String uid);

  void bindUser(String? userId) {
    if (userId == _uid) return;
    _uid = userId;
    resetState();
    // Defer: bindUser runs during a provider update (i.e. during build).
    scheduleMicrotask(() async {
      if (userId != null) {
        try {
          await loadForUser(userId);
        } catch (e, st) {
          debugPrint('Failed to load user data: $e\n$st');
        }
      }
      if (_uid == userId) notifyListeners();
    });
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
