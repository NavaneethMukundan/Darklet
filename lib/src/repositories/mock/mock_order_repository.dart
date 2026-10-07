import 'dart:convert';

import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/repositories/order_repository.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockOrderRepository implements OrderRepository {
  final AssetBundle bundle;
  final Duration latency;

  MockOrderRepository({AssetBundle? bundle, Duration? latency})
    : bundle = bundle ?? rootBundle,
      latency = latency ?? AppConfig.mockLatency;

  Future<List<Order>> _load(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$userId.orders');
    if (raw != null) {
      return (jsonDecode(raw) as List)
          .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (userId == 'demo-user') {
      final seed = jsonDecode(
        await bundle.loadString('assets/mock/seed_user.json'),
      );
      return (seed['orders'] as List)
          .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<void> _save(String userId, List<Order> orders) async =>
      (await SharedPreferences.getInstance()).setString(
        '$userId.orders',
        jsonEncode(orders.map((o) => o.toJson()).toList()),
      );

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
    await Future<void>.delayed(latency);
    final orders = await _load(userId);
    final now = DateTime.now();
    final subtotal = items.fold<double>(0, (s, i) => s + i.total);
    final order = Order(
      id: 'DK-${1000 + orders.length + 43}',
      createdAt: now,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      address: address,
      deliveryOptionId: delivery.id,
      paymentMethod: paymentMethod,
      status: OrderStatus.placed,
      events: [OrderEvent(OrderStatus.placed, now)],
      discount: discount,
      couponCode: couponCode,
      paymentRef: paymentRef,
    );
    await _save(userId, [order, ...orders]);
    return order;
  }

  @override
  Future<Order> cancelOrder(String userId, String orderId) async {
    await Future<void>.delayed(latency);
    final orders = await _load(userId);
    final i = orders.indexWhere((o) => o.id == orderId);
    if (i < 0 || !orders[i].canCancel) {
      throw StateError('Order can no longer be cancelled');
    }
    final o = orders[i];
    final updated = Order(
      id: o.id,
      createdAt: o.createdAt,
      items: o.items,
      subtotal: o.subtotal,
      deliveryFee: o.deliveryFee,
      address: o.address,
      deliveryOptionId: o.deliveryOptionId,
      paymentMethod: o.paymentMethod,
      status: OrderStatus.cancelled,
      events: [...o.events, OrderEvent(OrderStatus.cancelled, DateTime.now())],
      discount: o.discount,
      couponCode: o.couponCode,
      paymentRef: o.paymentRef,
    );
    orders[i] = updated;
    await _save(userId, orders);
    return updated;
  }

  @override
  Future<List<Order>> getOrders(String userId) async {
    await Future<void>.delayed(latency);
    final list = await _load(userId);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<Order?> getOrder(String userId, String orderId) async =>
      (await _load(userId)).where((o) => o.id == orderId).firstOrNull;
}
