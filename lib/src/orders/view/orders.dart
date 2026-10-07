import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/orders/controller/order_controller.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/helpers/order_helpers.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/skeleton.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.watch<OrderController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: l.myOrders),
        body: ContentWidth(
          maxWidth: 760,
          child: switch (c.status) {
            LoadStatus.idle ||
            LoadStatus.loading when c.orders.isEmpty => const Padding(
              padding: EdgeInsets.all(16),
              child: ListSkeleton(count: 4, itemHeight: 120),
            ),
            LoadStatus.error => ErrorState(onRetry: c.refresh),
            _ when c.orders.isEmpty => EmptyState(
              icon: Icons.receipt_long_outlined,
              title: l.ordersEmptyTitle,
              message: l.ordersEmptyMessage,
              actionLabel: l.startShopping,
              onAction: () {
                context.read<NavigationController>().select(0);
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
            ),
            _ => RefreshIndicator(
              color: color.primaryDarkColor,
              onRefresh: c.refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: c.orders.length,
                separatorBuilder: (_, _) => kHeight10,
                itemBuilder: (_, i) => _OrderCard(order: c.orders[i]),
              ),
            ),
          },
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final OrderStatus status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = orderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        orderStatusLabel(context.l10n, status),
        style: ts(12, w: FontWeight.w600, c: c),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: color.kWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(AppRoutes.orderDetails, args: order.id),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.orderNumber(order.id),
                      style: ts(15, w: FontWeight.w600),
                    ),
                  ),
                  StatusChip(order.status),
                ],
              ),
              kHeight5,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  shortDate(order.createdAt),
                  style: ts(12, w: FontWeight.w400, c: color.kGrey),
                ),
              ),
              kHeight10,
              Row(
                children: [
                  for (final i in order.items.take(3))
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: AppNetworkImage(i.image),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l.itemsCount(order.itemCount),
                        style: ts(12, w: FontWeight.w400, c: color.kGrey),
                      ),
                      Text(
                        money(order.total),
                        style: ts(17, w: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
