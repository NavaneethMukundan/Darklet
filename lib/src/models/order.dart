import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';

enum OrderStatus {
  placed,
  confirmed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

enum PaymentMethod { card, cashOnDelivery }

/// Shipping choices. Labels are localised in the UI by [id].
class DeliveryOption {
  final String id;
  final double price;
  final int minDays;
  final int maxDays;

  const DeliveryOption(this.id, this.price, this.minDays, this.maxDays);

  static const standard = DeliveryOption('standard', 4.99, 3, 5);
  static const express = DeliveryOption('express', 12.99, 1, 2);
  static const pickup = DeliveryOption('pickup', 0, 0, 1);

  static const all = [standard, express, pickup];

  static DeliveryOption byId(String id) =>
      all.firstWhere((o) => o.id == id, orElse: () => standard);
}

class OrderEvent {
  final OrderStatus status;
  final DateTime at;
  const OrderEvent(this.status, this.at);

  factory OrderEvent.fromJson(Map<String, dynamic> j) => OrderEvent(
    OrderStatus.values.byName(j['status'] as String),
    DateTime.parse(j['at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'at': at.toIso8601String(),
  };
}

class Order {
  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final Address address;
  final String deliveryOptionId;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final List<OrderEvent> events;
  final double discount;
  final String? couponCode;
  final String? paymentRef;

  const Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.address,
    required this.deliveryOptionId,
    required this.paymentMethod,
    required this.status,
    required this.events,
    this.discount = 0,
    this.couponCode,
    this.paymentRef,
  });

  double get total => subtotal - discount + deliveryFee;

  bool get canCancel =>
      status == OrderStatus.placed || status == OrderStatus.confirmed;
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  factory Order.fromJson(Map<String, dynamic> j) => Order(
    id: j['id'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    items: (j['items'] as List)
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    subtotal: (j['subtotal'] as num).toDouble(),
    deliveryFee: (j['deliveryFee'] as num).toDouble(),
    address: Address.fromJson(Map<String, dynamic>.from(j['address'])),
    deliveryOptionId: (j['deliveryOptionId'] ?? 'standard') as String,
    paymentMethod: PaymentMethod.values.byName(j['paymentMethod'] as String),
    status: OrderStatus.values.byName(j['status'] as String),
    events: (j['events'] as List)
        .map((e) => OrderEvent.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    discount: ((j['discount'] ?? 0) as num).toDouble(),
    couponCode: j['couponCode'] as String?,
    paymentRef: j['paymentRef'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'address': address.toJson(),
    'deliveryOptionId': deliveryOptionId,
    'paymentMethod': paymentMethod.name,
    'status': status.name,
    'events': events.map((e) => e.toJson()).toList(),
    'discount': discount,
    'couponCode': couponCode,
    'paymentRef': paymentRef,
  };
}
