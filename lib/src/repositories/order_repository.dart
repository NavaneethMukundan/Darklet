import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/order.dart';

abstract class OrderRepository {
  Future<Order> placeOrder(
    String userId, {
    required List<CartItem> items,
    required Address address,
    required DeliveryOption delivery,
    required double deliveryFee,
    required PaymentMethod paymentMethod,
    double discount = 0,
    String? couponCode,
    String? paymentRef,
  });

  /// Cancels an order that is still placed / confirmed.
  Future<Order> cancelOrder(String userId, String orderId);

  Future<List<Order>> getOrders(String userId);
  Future<Order?> getOrder(String userId, String orderId);
}
