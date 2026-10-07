import 'package:darklet/src/models/user_profile.dart';

enum AuthError {
  invalidCredentials,
  emailInUse,
  weakPassword,
  userNotFound,
  requiresRecentLogin,
  cancelled,
  network,
  unknown,
}

class AuthException implements Exception {
  final AuthError error;
  final String? detail;
  const AuthException(this.error, [this.detail]);

  @override
  String toString() =>
      'AuthException($error${detail == null ? '' : ': $detail'})';
}

abstract class AuthRepository {
  /// The signed-in user, restored from the previous session if any.
  Future<UserProfile?> currentUser();

  Future<UserProfile> signIn(String email, String password);
  Future<UserProfile> register(String name, String email, String password);
  Future<UserProfile> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();

  /// [avatarPath] is a local file path picked by the user (optional).
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? avatarPath,
  });

  Future<void> changePassword(String currentPassword, String newPassword);
}
