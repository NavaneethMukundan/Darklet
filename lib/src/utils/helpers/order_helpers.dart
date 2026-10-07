import 'package:darklet/l10n/app_localizations.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';

String orderStatusLabel(AppLocalizations l, OrderStatus s) => switch (s) {
  OrderStatus.placed => l.statusPlaced,
  OrderStatus.confirmed => l.statusConfirmed,
  OrderStatus.shipped => l.statusShipped,
  OrderStatus.outForDelivery => l.statusOutForDelivery,
  OrderStatus.delivered => l.statusDelivered,
  OrderStatus.cancelled => l.statusCancelled,
};

Color orderStatusColor(OrderStatus s) => switch (s) {
  OrderStatus.delivered => color.success,
  OrderStatus.cancelled => color.error,
  _ => color.primaryDarkColor,
};

String deliveryLabel(AppLocalizations l, DeliveryOption o) => switch (o.id) {
  'express' => l.deliveryExpress,
  'pickup' => l.deliveryPickup,
  _ => l.deliveryStandard,
};

String deliveryEta(AppLocalizations l, DeliveryOption o) => switch (o.id) {
  'pickup' => l.etaPickup,
  'express' => l.etaDays(o.minDays, o.maxDays),
  _ => l.etaDays(o.minDays, o.maxDays),
};

String paymentLabel(AppLocalizations l, PaymentMethod m) => switch (m) {
  PaymentMethod.card => l.payCard,
  PaymentMethod.cashOnDelivery => l.payCod,
};
