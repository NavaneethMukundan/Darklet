import 'package:darklet/src/models/user_profile.dart';
import 'package:darklet/src/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  static const _guestKey = 'guest_mode';

  final AuthRepository _repo;
  final SharedPreferences? _prefs;
  AuthController(this._repo, [this._prefs]);

  /// Browsing without an account. Cart and wishlist stay on the device.
  bool isGuest = false;

  UserProfile? user;
  bool initialized = false;
  bool busy = false;

  bool get isLoggedIn => user != null;

  /// Id that user-scoped data is stored under (`guest` while browsing as guest).
  String? get userId => user?.id ?? (isGuest ? 'guest' : null);

  Future<void> continueAsGuest() async {
    isGuest = true;
    notifyListeners();
    await _prefs?.setBool(_guestKey, true);
  }

  Future<void> _leaveGuest() async {
    if (!isGuest) return;
    isGuest = false;
    await _prefs?.remove(_guestKey);
  }

  /// Restores the previous session (called once from the splash screen).
  Future<void> init() async {
    if (initialized) return;
    try {
      user = await _repo.currentUser();
    } catch (_) {
      user = null;
    }
    isGuest = user == null && (_prefs?.getBool(_guestKey) ?? false);
    initialized = true;
    notifyListeners();
  }

  /// Runs [action] and converts failures to an [AuthError]. Returns `null`
  /// on success so UIs can show a localised message for the error.
  Future<AuthError?> _run(Future<void> Function() action) async {
    busy = true;
    notifyListeners();
    try {
      await action();
      if (user != null) await _leaveGuest();
      return null;
    } on AuthException catch (e) {
      return e.error;
    } catch (e) {
      debugPrint('Auth error: $e');
      return AuthError.unknown;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<AuthError?> signIn(String email, String password) =>
      _run(() async => user = await _repo.signIn(email.trim(), password));

  Future<AuthError?> register(String name, String email, String password) =>
      _run(
        () async => user = await _repo.register(name, email.trim(), password),
      );

  Future<AuthError?> signInWithGoogle() =>
      _run(() async => user = await _repo.signInWithGoogle());

  Future<AuthError?> sendPasswordReset(String email) =>
      _run(() => _repo.sendPasswordReset(email.trim()));

  Future<AuthError?> updateProfile({
    required String name,
    required String phone,
    String? avatarPath,
  }) => _run(
    () async => user = await _repo.updateProfile(
      name: name,
      phone: phone,
      avatarPath: avatarPath,
    ),
  );

  Future<AuthError?> changePassword(String current, String next) =>
      _run(() => _repo.changePassword(current, next));

  Future<void> signOut() async {
    await _repo.signOut();
    user = null;
    isGuest = false;
    await _prefs?.remove(_guestKey);
    notifyListeners();
  }
}
