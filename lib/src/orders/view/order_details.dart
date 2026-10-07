import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/orders/controller/order_controller.dart';
import 'package:darklet/src/orders/view/orders.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/order_helpers.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  static const _steps = [
    OrderStatus.placed,
    OrderStatus.confirmed,
    OrderStatus.shipped,
    OrderStatus.outForDelivery,
    OrderStatus.delivered,
  ];

  void _buyAgain(BuildContext context, Order order) {
    final l = context.l10n;
    final cart = context.read<CartController>();
    for (final item in order.items) {
      cart.addItem(item);
    }
    showSnack(
      context,
      l.itemsAddedToCart(order.itemCount),
      actionLabel: l.viewCart,
      onAction: () => context.push(AppRoutes.cart),
    );
  }

  Future<void> _cancel(BuildContext context, Order order) async {
    final l = context.l10n;
    final orders = context.read<OrderController>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.cancelOrder),
        content: Text(l.cancelOrderConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.keepOrder),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.cancelOrder, style: TextStyle(color: color.error)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final done = await orders.cancel(order.id);
    if (context.mounted) {
      showSnack(context, done ? l.orderCancelled : l.cancelFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final order = context.watch<OrderController>().byId(orderId);
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: l.orderNumber(orderId)),
        body: order == null
            ? EmptyState(
                icon: Icons.receipt_long_outlined,
                title: l.orderNotFound,
              )
            : ContentWidth(
                maxWidth: 760,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.orderTracking,
                                  style: ts(16, w: FontWeight.w600),
                                ),
                              ),
                              StatusChip(order.status),
                            ],
                          ),
                          kHeight15,
                          if (order.status == OrderStatus.cancelled)
                            Text(
                              l.orderCancelledMessage,
                              style: ts(13, w: FontWeight.w400, c: color.error),
                            )
                          else
                            _Timeline(order: order),
                        ],
                      ),
                    ),
                    kHeight15,
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.items, style: ts(16, w: FontWeight.w600)),
                          kHeight10,
                          for (final i in order.items)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width: 52,
                                      height: 52,
                                      child: AppNetworkImage(i.image),
                                    ),
                                  ),
                                  kWidth10,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          i.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: ts(13, w: FontWeight.w500),
                                        ),
                                        Text(
                                          '${i.quantity} × ${money(i.price)}${i.variant.isEmpty ? '' : ' • ${i.variant}'}',
                                          style: ts(
                                            12,
                                            w: FontWeight.w400,
                                            c: color.kGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    money(i.total),
                                    style: ts(14, w: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    kHeight15,
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Info(
                            Icons.location_on_outlined,
                            l.deliveryAddress,
                            '${order.address.fullName}\n${order.address.oneLine}',
                          ),
                          kHeight15,
                          _Info(
                            Icons.local_shipping_outlined,
                            l.deliveryOption,
                            deliveryLabel(
                              l,
                              DeliveryOption.byId(order.deliveryOptionId),
                            ),
                          ),
                          kHeight15,
                          _Info(
                            Icons.payments_outlined,
                            l.paymentMethod,
                            paymentLabel(l, order.paymentMethod),
                          ),
                        ],
                      ),
                    ),
                    kHeight15,
                    _Card(
                      child: Column(
                        children: [
                          _Row(l.subtotal, money(order.subtotal)),
                          if (order.discount > 0)
                            _Row(
                              '${l.discount}${order.couponCode == null ? '' : ' (${order.couponCode})'}',
                              '-${money(order.discount)}',
                            ),
                          _Row(
                            l.delivery,
                            order.deliveryFee == 0
                                ? l.free
                                : money(order.deliveryFee),
                          ),
                          Divider(
                            color: color.kLightGrey.withValues(alpha: 0.4),
                          ),
                          _Row(l.total, money(order.total), bold: true),
                        ],
                      ),
                    ),
                    kHeight20,
                    PrimaryButton(
                      label: l.buyAgain,
                      icon: Icons.replay_rounded,
                      onPressed: () => _buyAgain(context, order),
                    ),
                    if (order.canCancel) ...[
                      kHeight10,
                      SecondaryButton(
                        label: l.cancelOrder,
                        icon: Icons.cancel_outlined,
                        onPressed: () => _cancel(context, order),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.kWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
    ),
    child: child,
  );
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _Info(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: color.primaryDarkColor, size: 22),
      kWidth10,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ts(12, w: FontWeight.w400, c: color.kGrey),
            ),
            kHeight5,
            Text(value, style: ts(14, w: FontWeight.w500)),
          ],
        ),
      ),
    ],
  );
}

class _Row extends StatelessWidget {
  final String a;
  final String b;
  final bool bold;
  const _Row(this.a, this.b, {this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            a,
            style: ts(
              bold ? 16 : 14,
              w: bold ? FontWeight.w700 : FontWeight.w400,
              c: bold ? color.kBlack : color.kGrey,
            ),
          ),
        ),
        Text(
          b,
          style: ts(
            bold ? 18 : 14,
            w: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

/// Vertical tracking timeline. Reached steps are filled and show their time.
class _Timeline extends StatelessWidget {
  final Order order;
  const _Timeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reached = OrderDetailsScreen._steps.indexOf(order.status);
    return Column(
      children: [
        for (final (i, step) in OrderDetailsScreen._steps.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= reached
                              ? color.primaryDarkColor
                              : color.kWhite,
                          border: Border.all(
                            color: i <= reached
                                ? color.primaryDarkColor
                                : color.kLightGrey,
                            width: 2,
                          ),
                        ),
                        child: i <= reached
                            ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      if (i < OrderDetailsScreen._steps.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: i < reached
                                ? color.primaryDarkColor
                                : color.kLightGrey,
                          ),
                        ),
                    ],
                  ),
                ),
                kWidth10,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderStatusLabel(l, step),
                          style: ts(
                            14,
                            w: i <= reached ? FontWeight.w600 : FontWeight.w400,
                            c: i <= reached ? color.kBlack : color.kGrey,
                          ),
                        ),
                        if (_timeFor(step) != null)
                          Text(
                            dateTime(_timeFor(step)!),
                            style: ts(12, w: FontWeight.w400, c: color.kGrey),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  DateTime? _timeFor(OrderStatus s) =>
      order.events.where((e) => e.status == s).firstOrNull?.at;
}
