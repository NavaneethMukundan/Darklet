import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/repositories/order_repository.dart';

/// Orders are created and cancelled by Cloud Functions, never directly by the
/// app: the server re-reads product prices (including option price
/// differences), re-validates the coupon, computes the totals and, for card
/// payments, checks the Stripe PaymentIntent really succeeded. Firestore rules
/// let users read their own orders only. See firebase/functions/index.js.
class FirebaseOrderRepository implements OrderRepository {
  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  FirebaseOrderRepository({FirebaseFirestore? db, FirebaseFunctions? functions})
    : _db = db ?? FirebaseFirestore.instance,
      _functions = functions ?? FirebaseFunctions.instance;

  @override
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
  }) async {
    // Only identifiers are sent - the server decides every price.
    final res = await _functions.httpsCallable('placeOrder').call({
      'items': [
        for (final i in items)
          {
            'productId': i.productId,
            'variant': i.variant,
            'quantity': i.quantity,
          },
      ],
      'address': address.toJson(),
      'deliveryOptionId': delivery.id,
      'paymentMethod': paymentMethod.name,
      'couponCode': couponCode,
      'paymentRef': paymentRef,
    });
    return Order.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  @override
  Future<Order> cancelOrder(String userId, String orderId) async {
    final res = await _functions.httpsCallable('cancelOrder').call({
      'orderId': orderId,
    });
    return Order.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  @override
  Future<List<Order>> getOrders(String userId) async {
    final snap = await _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    return snap.docs.map((d) => Order.fromJson(d.data())).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Order?> getOrder(String userId, String orderId) async {
    final d = await _db.collection('orders').doc(orderId).get();
    if (!d.exists || d.data()?['userId'] != userId) return null;
    return Order.fromJson(d.data()!);
  }
}
