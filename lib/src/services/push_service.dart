import 'dart:async';

import 'package:darklet/src/models/app_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  /// Android notification channel (also the default for background pushes,
  /// see the meta-data in AndroidManifest.xml).
  static const channel = AndroidNotificationChannel(
    'orders',
    'Order updates',
    description: 'Status updates for your orders',
    importance: Importance.high,
  );

  final SharedPreferences? _prefs;
  final _local = FlutterLocalNotificationsPlugin();
  PushService(this._prefs);

  final _controller = StreamController<AppNotification>.broadcast();
  StreamSubscription<RemoteMessage>? _sub;
  String? _topicUid;

  Stream<AppNotification> get notifications => _controller.stream;

  /// `true` until the user has been asked once.
  bool get shouldAsk => !(_prefs?.getBool(askedKey) ?? false);

  /// Starts listening for foreground messages (no permission prompt).
  ///
  /// Pushes that arrive while the app is open are not drawn by the OS, so on
  /// Android we post a real system notification ourselves; on iOS we ask the
  /// OS to present them.
  Future<void> start() async {
    if (_sub != null) return;
    try {
      await _local.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );
      await _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
      _sub = FirebaseMessaging.onMessage.listen((m) {
        final n = m.notification;
        if (n == null) return;
        if (defaultTargetPlatform == TargetPlatform.android) {
          _local.show(
            m.hashCode,
            n.title,
            n.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
        _controller.add(
          AppNotification(
            id:
                m.data['notifId'] as String? ??
                m.messageId ??
                'push${DateTime.now().millisecondsSinceEpoch}',
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

  /// Whether the OS lets us show system notifications.
  Future<bool> get systemNotificationsAllowed async {
    try {
      final s = await FirebaseMessaging.instance.getNotificationSettings();
      return s.authorizationStatus == AuthorizationStatus.authorized ||
          s.authorizationStatus == AuthorizationStatus.provisional;
    } catch (_) {
      return false;
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
