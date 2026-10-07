import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_network_image.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:darklet/src/utils/widgets/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cart = context.watch<CartController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: l.cartTitle),
        body: ContentWidth(
          maxWidth: 760,
          child: cart.isEmpty
              ? EmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: l.cartEmptyTitle,
                  message: l.cartEmptyMessage,
                  actionLabel: l.startShopping,
                  onAction: () {
                    context.read<NavigationController>().select(0);
                    Navigator.of(context).popUntil(
                      (r) => r.isFirst || r.settings.name == AppRoutes.home,
                    );
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, _) => kHeight10,
                        itemBuilder: (_, i) => _CartRow(item: cart.items[i]),
                      ),
                    ),
                    _Summary(cart: cart),
                  ],
                ),
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  const _CartRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cart = context.read<CartController>();
    return Dismissible(
      key: ValueKey(item.lineId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: color.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        cart.remove(item.lineId);
        showSnack(
          context,
          l.itemRemoved,
          actionLabel: l.undo,
          onAction: () => cart.restore(item),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 84,
                height: 84,
                child: AppNetworkImage(item.image),
              ),
            ),
            kWidth10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ts(14, w: FontWeight.w600),
                  ),
                  if (item.variant.isNotEmpty) ...[
                    kHeight5,
                    Text(
                      item.variant,
                      style: ts(12, w: FontWeight.w400, c: color.kGrey),
                    ),
                  ],
                  kHeight5,
                  Text(
                    money(item.price),
                    style: ts(13, w: FontWeight.w400, c: color.kGrey),
                  ),
                  kHeight10,
                  Row(
                    children: [
                      QuantityStepper(
                        value: item.quantity,
                        onChanged: (v) => cart.setQuantity(item.lineId, v),
                      ),
                      const Spacer(),
                      Text(
                        money(item.total),
                        style: ts(16, w: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l.remove,
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close_rounded, color: color.kGrey, size: 20),
              onPressed: () {
                cart.remove(item.lineId);
                showSnack(
                  context,
                  l.itemRemoved,
                  actionLabel: l.undo,
                  onAction: () => cart.restore(item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final CartController cart;
  const _Summary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: color.kWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.itemsCount(cart.itemCount),
                      style: ts(14, c: color.kGrey),
                    ),
                  ),
                  Text(l.subtotal, style: ts(14, c: color.kGrey)),
                  kWidth10,
                  Text(money(cart.subtotal), style: ts(20, w: FontWeight.w700)),
                ],
              ),
              kHeight5,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l.shippingAtCheckout,
                  style: ts(12, w: FontWeight.w400, c: color.kGrey),
                ),
              ),
              kHeight15,
              PrimaryButton(
                label: l.checkout,
                icon: Icons.lock_outline_rounded,
                onPressed: () async {
                  if (await ensureSignedIn(context) && context.mounted) {
                    context.push(AppRoutes.checkout);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
