import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/checkout/controller/checkout_controller.dart';
import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/notifications/controller/notification_controller.dart';
import 'package:darklet/src/orders/controller/order_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Creates the order from the cart + checkout choices, then clears the cart.
/// Called once payment succeeded (or immediately for cash on delivery).
Future<Order> completeOrder(
  BuildContext context, {
  required String notificationTitle,
  required String Function(String id) notificationBody,
  String? paymentRef,
}) async {
  final cart = context.read<CartController>();
  final checkout = context.read<CheckoutController>();
  final orders = context.read<OrderController>();
  final notifications = context.read<NotificationController>();
  final address =
      checkout.address ?? context.read<AddressController>().defaultAddress;
  if (address == null) throw StateError('No delivery address selected');

  final order = await orders.placeOrder(
    items: cart.items,
    address: address,
    delivery: checkout.delivery,
    deliveryFee: checkout.deliveryFee(cart.subtotal),
    paymentMethod: checkout.paymentMethod,
    discount: checkout.discount(cart.subtotal),
    couponCode: checkout.coupon?.code,
    paymentRef: paymentRef,
  );
  cart.clear();
  checkout.reset();
  notifications.add(
    AppNotification(
      // Same id the server push uses, so the inbox never shows it twice.
      id: 'order-${order.id}-placed',
      title: notificationTitle,
      body: notificationBody(order.id),
      createdAt: DateTime.now(),
      type: 'order',
    ),
  );
  return order;
}
