import 'dart:async';

import 'package:darklet/src/models/app_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase Cloud Messaging: asks for permission and turns foreground pushes
/// into [AppNotification]s for the in-app inbox. Send order-status pushes from
/// a Cloud Function (see docs/FIREBASE_SETUP.md).
class PushService {
  final _controller = StreamController<AppNotification>.broadcast();
  StreamSubscription<RemoteMessage>? _sub;

  Stream<AppNotification> get notifications => _controller.stream;

  Future<void> start() async {
    try {
      final fcm = FirebaseMessaging.instance;
      await fcm.requestPermission();
      _sub = FirebaseMessaging.onMessage.listen((m) {
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

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
