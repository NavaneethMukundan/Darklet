import 'dart:convert';

import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/user_profile.dart';
import 'package:darklet/src/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local-only auth for demos. Accounts live in SharedPreferences.
/// NOTE: passwords are stored in plain text - this is for demo use only.
class MockAuthRepository implements AuthRepository {
  final Duration latency;
  MockAuthRepository({Duration? latency})
    : latency = latency ?? AppConfig.mockLatency;

  static const _usersKey = 'mock_users';
  static const _sessionKey = 'mock_session';

  Future<void> _delay() => Future<void>.delayed(latency);

  Future<Map<String, Map<String, dynamic>>> _users() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    final map = raw == null
        ? <String, Map<String, dynamic>>{}
        : (jsonDecode(raw) as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, Map<String, dynamic>.from(v)),
          );
    map.putIfAbsent(
      AppConfig.demoEmail,
      () => {
        'id': 'demo-user',
        'name': 'John Doe',
        'email': AppConfig.demoEmail,
        'phone': '+1 555 010 1234',
        'password': AppConfig.demoPassword,
      },
    );
    return map;
  }

  Future<void> _saveUsers(Map<String, Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  UserProfile _profile(Map<String, dynamic> u) => UserProfile.fromJson(u);

  Future<void> _setSession(String email) async =>
      (await SharedPreferences.getInstance()).setString(_sessionKey, email);

  @override
  Future<UserProfile?> currentUser() async {
    final email = (await SharedPreferences.getInstance()).getString(
      _sessionKey,
    );
    if (email == null) return null;
    final u = (await _users())[email];
    return u == null ? null : _profile(u);
  }

  @override
  Future<UserProfile> signIn(String email, String password) async {
    await _delay();
    final key = email.trim().toLowerCase();
    final u = (await _users())[key];
    if (u == null || u['password'] != password) {
      throw const AuthException(AuthError.invalidCredentials);
    }
    await _setSession(key);
    return _profile(u);
  }

  @override
  Future<UserProfile> register(
    String name,
    String email,
    String password,
  ) async {
    await _delay();
    final key = email.trim().toLowerCase();
    final users = await _users();
    if (users.containsKey(key)) throw const AuthException(AuthError.emailInUse);
    if (password.length < 6) throw const AuthException(AuthError.weakPassword);
    final u = {
      'id': 'u${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': key,
      'phone': '',
      'password': password,
    };
    users[key] = u;
    await _saveUsers(users);
    await _setSession(key);
    return _profile(u);
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    await _delay();
    final users = await _users();
    const email = 'google.user@darklet.app';
    users.putIfAbsent(
      email,
      () => {
        'id': 'google-user',
        'name': 'Jane Doe',
        'email': email,
        'phone': '',
        'password': '',
      },
    );
    await _saveUsers(users);
    await _setSession(email);
    return _profile(users[email]!);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await _delay();
    // Real backends should not reveal whether the address exists.
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  @override
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? avatarPath,
  }) async {
    await _delay();
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_sessionKey);
    final users = await _users();
    final u = email == null ? null : users[email];
    if (u == null) throw const AuthException(AuthError.userNotFound);
    u['name'] = name.trim();
    u['phone'] = phone.trim();
    if (avatarPath != null) u['avatarUrl'] = avatarPath;
    await _saveUsers(users);
    return _profile(u);
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _delay();
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_sessionKey);
    final users = await _users();
    final u = email == null ? null : users[email];
    if (u == null) throw const AuthException(AuthError.userNotFound);
    if (u['password'] != currentPassword) {
      throw const AuthException(AuthError.invalidCredentials);
    }
    if (newPassword.length < 6) {
      throw const AuthException(AuthError.weakPassword);
    }
    u['password'] = newPassword;
    await _saveUsers(users);
  }
}
