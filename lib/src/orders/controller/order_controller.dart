import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/repositories/order_repository.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/helpers/user_scoped_controller.dart';
import 'package:flutter/foundation.dart';

class OrderController extends UserScopedController {
  final OrderRepository _repo;
  OrderController(this._repo);

  LoadStatus status = LoadStatus.idle;
  List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  @override
  void resetState() {
    _orders = [];
    status = LoadStatus.idle;
  }

  @override
  Future<void> loadForUser(String uid) => refresh();

  Future<void> refresh() async {
    final id = uid;
    if (id == null) return;
    status = LoadStatus.loading;
    notifyListeners();
    try {
      _orders = await _repo.getOrders(id);
      status = LoadStatus.loaded;
    } catch (e) {
      debugPrint('Orders failed: $e');
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  Order? byId(String id) => _orders.where((o) => o.id == id).firstOrNull;

  Future<Order> placeOrder({
    required List<CartItem> items,
    required Address address,
    required DeliveryOption delivery,
    required double deliveryFee,
    required PaymentMethod paymentMethod,
    double discount = 0,
    String? couponCode,
    String? paymentRef,
  }) async {
    final id = uid;
    if (id == null) throw StateError('No signed-in user');
    final order = await _repo.placeOrder(
      id,
      items: items,
      address: address,
      delivery: delivery,
      deliveryFee: deliveryFee,
      paymentMethod: paymentMethod,
      discount: discount,
      couponCode: couponCode,
      paymentRef: paymentRef,
    );
    _orders = [order, ..._orders];
    status = LoadStatus.loaded;
    notifyListeners();
    return order;
  }

  /// Cancels an order that hasn't shipped yet. Returns `false` on failure.
  Future<bool> cancel(String orderId) async {
    final id = uid;
    if (id == null) return false;
    try {
      final updated = await _repo.cancelOrder(id, orderId);
      _orders = [for (final o in _orders) o.id == orderId ? updated : o];
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Cancel failed: $e');
      return false;
    }
  }
}
