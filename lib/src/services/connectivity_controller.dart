import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Tracks whether the device has a network connection.
/// Fails safe: if the platform plugin is unavailable the app is treated as online.
class ConnectivityController extends ChangeNotifier {
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _online = true;
  bool get online => _online;

  /// Set when the connection comes back, so the UI can flash "back online".
  bool justReconnected = false;

  ConnectivityController({bool listen = true}) {
    if (listen) _start();
  }

  Future<void> _start() async {
    try {
      final c = Connectivity();
      _apply(await c.checkConnectivity());
      _sub = c.onConnectivityChanged.listen(_apply, onError: (_) {});
    } catch (e) {
      debugPrint('Connectivity unavailable: $e');
    }
  }

  void _apply(List<ConnectivityResult> results) =>
      setOnline(!results.every((r) => r == ConnectivityResult.none));

  @visibleForTesting
  void setOnline(bool value) {
    if (value == _online) return;
    justReconnected = value;
    _online = value;
    notifyListeners();
    if (value) {
      Future<void>.delayed(const Duration(seconds: 2), () {
        justReconnected = false;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
