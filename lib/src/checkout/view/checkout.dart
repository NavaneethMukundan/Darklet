import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/models/saved_card.dart';
import 'package:darklet/src/repositories/coupon_repository.dart';
import 'package:darklet/src/utils/widgets/card_formatters.dart';
import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/checkout/checkout_flow.dart';
import 'package:darklet/src/checkout/controller/checkout_controller.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/order_helpers.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _placing = false;

  /// Selected card, falling back to the default one.
  SavedCard? _effectiveCard(BuildContext context) {
    final cards = context.read<CardController>();
    return cards.byId(context.read<CheckoutController>().cardId) ??
        cards.defaultCard;
  }

  /// Card payments (in-app form) need a saved card before continuing.
  bool _cardReady(BuildContext context) {
    final checkout = context.watch<CheckoutController>();
    if (checkout.paymentMethod != PaymentMethod.card) return true;
    if (context.read<AppDependencies>().payment.usesExternalSheet) return true;
    return context.watch<CardController>().defaultCard != null;
  }

  Future<void> _chooseAddress() async {
    final picked = await context.push<Address>(AppRoutes.addresses, args: true);
    if (picked != null && mounted) {
      context.read<CheckoutController>().selectAddress(picked);
    }
  }

  Future<void> _placeOrder() async {
    final l = context.l10n;
    final checkout = context.read<CheckoutController>();
    final address =
        checkout.address ?? context.read<AddressController>().defaultAddress;
    if (address == null) {
      showSnack(context, l.selectAddressFirst);
      return;
    }
    checkout.selectAddress(address);
    if (checkout.paymentMethod == PaymentMethod.card) {
      if (!context.read<AppDependencies>().payment.usesExternalSheet) {
        final card = _effectiveCard(context);
        if (card == null) {
          showSnack(context, l.addCardFirst);
          return;
        }
        checkout.selectCard(card.id);
      }
      await context.push(AppRoutes.payment);
      return;
    }
    setState(() => _placing = true);
    try {
      final order = await completeOrder(
        context,
        notificationTitle: l.notifOrderPlacedTitle,
        notificationBody: l.notifOrderPlacedBody,
      );
      if (mounted) context.pushAndClear(AppRoutes.orderSuccess, args: order.id);
    } catch (_) {
      if (mounted) {
        setState(() => _placing = false);
        showSnack(context, l.somethingWentWrong);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cart = context.watch<CartController>();
    final checkout = context.watch<CheckoutController>();
    final address =
        checkout.address ?? context.watch<AddressController>().defaultAddress;
    final fee = checkout.deliveryFee(cart.subtotal);
    final discount = checkout.discount(cart.subtotal);
    final usesSheet = context.read<AppDependencies>().payment.usesExternalSheet;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: l.checkout),
        body: ContentWidth(
          maxWidth: 760,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    _Section(l.deliveryAddress),
                    _AddressCard(address: address, onTap: _chooseAddress),
                    kHeight20,
                    _Section(l.deliveryOption),
                    for (final o in DeliveryOption.all)
                      _OptionTile(
                        selected: checkout.delivery.id == o.id,
                        icon: switch (o.id) {
                          'express' => Icons.bolt_rounded,
                          'pickup' => Icons.storefront_outlined,
                          _ => Icons.local_shipping_outlined,
                        },
                        title: deliveryLabel(l, o),
                        subtitle: deliveryEta(l, o),
                        trailing:
                            (o.id == DeliveryOption.standard.id &&
                                cart.subtotal >=
                                    AppConfig.freeShippingThreshold)
                            ? l.free
                            : (o.price == 0 ? l.free : money(o.price)),
                        onTap: () => checkout.selectDelivery(o),
                      ),
                    kHeight20,
                    _Section(l.paymentMethod),
                    _OptionTile(
                      selected: checkout.paymentMethod == PaymentMethod.card,
                      icon: Icons.credit_card_rounded,
                      title: l.payCard,
                      subtitle: usesSheet ? l.payCardSecure : l.payCardSubtitle,
                      onTap: () => checkout.selectPayment(PaymentMethod.card),
                    ),
                    _OptionTile(
                      selected:
                          checkout.paymentMethod ==
                          PaymentMethod.cashOnDelivery,
                      icon: Icons.payments_outlined,
                      title: l.payCod,
                      subtitle: l.payCodSubtitle,
                      onTap: () =>
                          checkout.selectPayment(PaymentMethod.cashOnDelivery),
                    ),
                    if (checkout.paymentMethod == PaymentMethod.card &&
                        !usesSheet) ...[
                      kHeight5,
                      const _CardsSection(),
                    ],
                    kHeight20,
                    _Section(l.promoCode),
                    _CouponBox(subtotal: cart.subtotal),
                    kHeight20,
                    _Section(l.orderSummary),
                    _SummaryCard(
                      cart: cart,
                      fee: fee,
                      discount: discount,
                      total: cart.subtotal - discount + fee,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: color.kWhite,
                  border: Border(
                    top: BorderSide(
                      color: color.kLightGrey.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: PrimaryButton(
                      label: checkout.paymentMethod == PaymentMethod.card
                          ? '${l.continueToPayment} • ${money(cart.subtotal - discount + fee)}'
                          : '${l.placeOrder} • ${money(cart.subtotal - discount + fee)}',
                      loading: _placing,
                      onPressed: cart.isEmpty || !_cardReady(context)
                          ? null
                          : _placeOrder,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String text;
  const _Section(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 6),
    child: Text(text, style: ts(17, w: FontWeight.w600)),
  );
}

class _AddressCard extends StatelessWidget {
  final Address? address;
  final VoidCallback onTap;
  const _AddressCard({required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.kLightGrey.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: color.primaryDarkColor),
            kWidth10,
            Expanded(
              child: address == null
                  ? Text(l.addAddress, style: ts(14, c: color.primaryDarkColor))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address!.label} • ${address!.fullName}',
                          style: ts(14, w: FontWeight.w600),
                        ),
                        kHeight5,
                        Text(
                          address!.oneLine,
                          style: ts(12, w: FontWeight.w400, c: color.kGrey),
                        ),
                      ],
                    ),
            ),
            Text(
              address == null ? '' : l.change,
              style: ts(13, c: color.primaryDarkColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback onTap;
  const _OptionTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected
                  ? color.secondaryColor.withValues(alpha: 0.5)
                  : color.kWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? color.primaryDarkColor
                    : color.kLightGrey.withValues(alpha: 0.5),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color.kBlack),
                kWidth15,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: ts(14, w: FontWeight.w600)),
                      Text(
                        subtitle,
                        style: ts(12, w: FontWeight.w400, c: color.kGrey),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  Text(trailing!, style: ts(14, w: FontWeight.w600)),
                  kWidth10,
                ],
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? color.primaryDarkColor : color.kLightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final CartController cart;
  final double fee;
  final double discount;
  final double total;
  const _SummaryCard({
    required this.cart,
    required this.fee,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget line(String a, String b, {bool bold = false}) => Padding(
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          for (final i in cart.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${i.quantity} × ${i.name}${i.variant.isEmpty ? '' : ' (${i.variant})'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ts(13, w: FontWeight.w400),
                    ),
                  ),
                  kWidth10,
                  Text(money(i.total), style: ts(13)),
                ],
              ),
            ),
          Divider(color: color.kLightGrey.withValues(alpha: 0.4)),
          line(l.subtotal, money(cart.subtotal)),
          if (discount > 0) line(l.discount, '-${money(discount)}'),
          line(l.delivery, fee == 0 ? l.free : money(fee)),
          Divider(color: color.kLightGrey.withValues(alpha: 0.4)),
          line(l.total, money(total), bold: true),
        ],
      ),
    );
  }
}

/// Saved cards (radio list) with an "Add new card" action, or an empty prompt.
class _CardsSection extends StatelessWidget {
  const _CardsSection();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cards = context.watch<CardController>();
    final checkout = context.watch<CheckoutController>();
    final selected = cards.byId(checkout.cardId) ?? cards.defaultCard;

    Future<void> add() async {
      final card = await context.push<SavedCard>(AppRoutes.addCard);
      if (card != null && context.mounted) {
        context.read<CheckoutController>().selectCard(card.id);
      }
    }

    if (cards.loading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (cards.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.kLightGrey.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Icon(Icons.credit_card_off_outlined, color: color.kGrey, size: 32),
            kHeight10,
            Text(l.noCardsTitle, style: ts(15, w: FontWeight.w600)),
            kHeight5,
            Text(
              l.noCardsMessage,
              textAlign: TextAlign.center,
              style: ts(12, w: FontWeight.w400, c: color.kGrey),
            ),
            kHeight15,
            SecondaryButton(
              label: l.addCard,
              icon: Icons.add_card_rounded,
              onPressed: add,
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (final c in cards.items)
          _OptionTile(
            selected: selected?.id == c.id,
            icon: Icons.credit_card_rounded,
            title: '${brandLabel(c.brand)} •••• ${c.last4}',
            subtitle: '${c.holder} • ${l.expiresOn(c.expiry)}',
            onTap: () => checkout.selectCard(c.id),
          ),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: add,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.primaryDarkColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: color.primaryDarkColor),
                kWidth10,
                Text(
                  l.addNewCard,
                  style: ts(14, w: FontWeight.w600, c: color.primaryDarkColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Promo code entry: field + Apply, or the applied coupon with a remove button.
class _CouponBox extends StatefulWidget {
  final double subtotal;
  const _CouponBox({required this.subtotal});

  @override
  State<_CouponBox> createState() => _CouponBoxState();
}

class _CouponBoxState extends State<_CouponBox> {
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final l = context.l10n;
    final text = _code.text.trim();
    if (text.isEmpty) return;
    final err = await context.read<CheckoutController>().applyCoupon(
      text,
      widget.subtotal,
    );
    if (!mounted) return;
    setState(() {
      _error = err == null
          ? null
          : err.error == CouponError.minSubtotal
          ? l.couponMinSubtotal(money(err.minSubtotal ?? 0))
          : l.couponNotFound;
    });
    if (err == null) _code.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final checkout = context.watch<CheckoutController>();
    final coupon = checkout.coupon;
    if (coupon != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.secondaryColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.primaryDarkColor),
        ),
        child: Row(
          children: [
            Icon(Icons.local_offer_rounded, color: color.primaryDarkColor),
            kWidth10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.couponApplied(coupon.code),
                    style: ts(14, w: FontWeight.w600),
                  ),
                  if (coupon.description.isNotEmpty)
                    Text(
                      coupon.description,
                      style: ts(12, w: FontWeight.w400, c: color.kGrey),
                    ),
                ],
              ),
            ),
            TextButton(onPressed: checkout.removeCoupon, child: Text(l.remove)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _apply(),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                style: ts(14, w: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: l.enterPromoCode,
                  prefixIcon: Icon(
                    Icons.local_offer_outlined,
                    color: color.kGrey,
                  ),
                ),
              ),
            ),
            kWidth10,
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: checkout.couponBusy ? null : _apply,
                style: FilledButton.styleFrom(
                  backgroundColor: color.kBlack,
                  foregroundColor: color.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: checkout.couponBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.apply),
              ),
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 6),
            child: Text(_error!, style: ts(12, c: color.error)),
          ),
      ],
    );
  }
}
