import 'dart:async';

import 'package:darklet/src/models/app_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Firebase Cloud Messaging.
///
/// * Foreground pushes become [AppNotification]s in the in-app inbox.
/// * A signed-in user is subscribed to the topic `user_<uid>` (the Cloud
///   Function `onOrderStatusChange` publishes to it) - this needs no permission.
/// * The permission prompt is **not** shown at launch. The app asks right
///   after the first order (see `OrderSuccessScreen`), when the benefit - order
///   updates - is obvious, using a short explanation first.
class PushService {
  static const askedKey = 'push_permission_asked';

  final SharedPreferences? _prefs;
  PushService(this._prefs);

  final _controller = StreamController<AppNotification>.broadcast();
  StreamSubscription<RemoteMessage>? _sub;
  String? _topicUid;

  Stream<AppNotification> get notifications => _controller.stream;

  /// `true` until the user has been asked once.
  bool get shouldAsk => !(_prefs?.getBool(askedKey) ?? false);

  /// Starts listening for foreground messages (no permission prompt).
  void start() {
    try {
      _sub ??= FirebaseMessaging.onMessage.listen((m) {
        final n = m.notification;
        if (n == null) return;
        _controller.add(
          AppNotification(
            id: m.messageId ?? 'push${DateTime.now().millisecondsSinceEpoch}',
            title: n.title ?? '',
            body: n.body ?? '',
            createdAt: DateTime.now(),
            type: (m.data['type'] as String?) ?? 'order',
          ),
        );
      });
    } catch (e) {
      debugPrint('Push notifications unavailable: $e');
    }
  }

  /// Subscribes the signed-in user (or unsubscribes when [uid] is null/guest).
  Future<void> setUser(String? uid) async {
    final next = (uid == null || uid == 'guest') ? null : uid;
    if (next == _topicUid) return;
    try {
      final fcm = FirebaseMessaging.instance;
      if (_topicUid != null) await fcm.unsubscribeFromTopic('user_$_topicUid');
      if (next != null) await fcm.subscribeToTopic('user_$next');
      _topicUid = next;
    } catch (e) {
      debugPrint('Push topic change failed: $e');
    }
  }

  /// Shows the system permission prompt. Call at a meaningful moment.
  Future<bool> requestPermission() async {
    await _prefs?.setBool(askedKey, true);
    try {
      final s = await FirebaseMessaging.instance.requestPermission();
      return s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      debugPrint('Push permission failed: $e');
      return false;
    }
  }

  Future<void> markAsked() async => _prefs?.setBool(askedKey, true);

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
