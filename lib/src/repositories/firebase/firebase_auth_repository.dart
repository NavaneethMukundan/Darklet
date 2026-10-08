import 'dart:io';

import 'package:darklet/firebase_options.dart';
import 'package:darklet/src/models/user_profile.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:darklet/src/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Auth + a `users/{uid}` Firestore profile document.
class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  bool _googleReady = false;

  FirebaseAuthRepository({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? db,
    FirebaseStorage? storage,
  }) : _auth = auth ?? fb.FirebaseAuth.instance,
       _db = db ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  AuthException _map(fb.FirebaseAuthException e) => switch (e.code) {
    'invalid-credential' ||
    'wrong-password' ||
    'invalid-email' => AuthException(AuthError.invalidCredentials, e.code),
    'user-not-found' => AuthException(AuthError.userNotFound, e.code),
    'email-already-in-use' => AuthException(AuthError.emailInUse, e.code),
    'weak-password' => AuthException(AuthError.weakPassword, e.code),
    'requires-recent-login' => AuthException(
      AuthError.requiresRecentLogin,
      e.code,
    ),
    'network-request-failed' => AuthException(AuthError.network, e.code),
    _ => AuthException(AuthError.unknown, e.code),
  };

  Future<UserProfile> _profile(fb.User user, {String? fallbackName}) async {
    final ref = _doc(user.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      final p = UserProfile(
        id: user.uid,
        name: fallbackName ?? user.displayName ?? '',
        email: user.email ?? '',
        avatarUrl: user.photoURL,
      );
      await ref.set(p.toJson());
      return p;
    }
    return UserProfile.fromJson({...snap.data()!, 'id': user.uid});
  }

  @override
  Future<UserProfile?> currentUser() async {
    final u = _auth.currentUser;
    return u == null ? null : _profile(u);
  }

  @override
  Future<UserProfile> signIn(String email, String password) async {
    try {
      final c = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _profile(c.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<UserProfile> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final c = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await c.user!.updateDisplayName(name);
      return _profile(c.user!, fallbackName: name);
    } on fb.FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    try {
      if (!_googleReady) {
        await GoogleSignIn.instance.initialize(
          // Web client id (needed on Android to get an id token) and the iOS
          // client id come from lib/firebase_options.dart.
          serverClientId: DefaultFirebaseOptions.googleServerClientId,
          clientId: defaultTargetPlatform == TargetPlatform.iOS
              ? DefaultFirebaseOptions.ios.iosClientId
              : null,
        );
        _googleReady = true;
      }
      final account = await GoogleSignIn.instance.authenticate();
      final cred = fb.GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final c = await _auth.signInWithCredential(cred);
      return _profile(c.user!);
    } on GoogleSignInException {
      throw const AuthException(AuthError.cancelled);
    } on fb.FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      // Do not reveal whether an account exists.
      if (e.code != 'user-not-found') throw _map(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      if (_googleReady) await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  @override
  Future<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? avatarPath,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthException(AuthError.userNotFound);
    String? url;
    if (avatarPath != null) {
      final ref = _storage.ref('avatars/${user.uid}.jpg');
      await ref.putFile(File(avatarPath));
      url = await ref.getDownloadURL();
    }
    await user.updateDisplayName(name);
    await _doc(user.uid).set({
      'name': name.trim(),
      'phone': phone.trim(),
      'avatarUrl': ?url,
    }, SetOptions(merge: true));
    return _profile(user);
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthException(AuthError.userNotFound);
    }
    try {
      await user.reauthenticateWithCredential(
        fb.EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        ),
      );
      await user.updatePassword(newPassword);
    } on fb.FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }
}
