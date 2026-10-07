import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:darklet/src/utils/helpers/user_scoped_controller.dart';

class NotificationController extends UserScopedController {
  final UserDataRepository _repo;
  NotificationController(this._repo);

  List<AppNotification> _items = [];
  bool loading = false;
  List<AppNotification> get items => List.unmodifiable(_items);
  int get unreadCount => _items.where((n) => !n.read).length;

  @override
  void resetState() {
    _items = [];
    loading = false;
  }

  @override
  Future<void> loadForUser(String uid) async {
    loading = true;
    notifyListeners();
    _items = await _repo.loadNotifications(uid)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    loading = false;
  }

  /// Adds a notification at the top (e.g. from an FCM push).
  void add(AppNotification n) {
    _items.insert(0, n);
    _changed();
  }

  void markRead(String id) {
    _items = [for (final n in _items) n.id == id ? n.copyWith(read: true) : n];
    _changed();
  }

  void markAllRead() {
    _items = [for (final n in _items) n.copyWith(read: true)];
    _changed();
  }

  void clear() {
    _items = [];
    _changed();
  }

  void _changed() {
    notifyListeners();
    final id = uid;
    if (id != null) _repo.saveNotifications(id, _items);
  }
}
