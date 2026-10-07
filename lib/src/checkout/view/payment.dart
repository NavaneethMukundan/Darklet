import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/checkout/checkout_flow.dart';
import 'package:darklet/src/checkout/controller/checkout_controller.dart';
import 'package:darklet/src/repositories/payment_service.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/format.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/app_text_field.dart';
import 'package:darklet/src/utils/widgets/buttons.dart';
import 'package:darklet/src/utils/widgets/card_formatters.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum _PayState { form, processing, failed }

/// Pays with the card chosen at checkout. Only the CVC is asked again.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cvc = TextEditingController();
  _PayState _state = _PayState.form;
  String? _failure;

  @override
  void dispose() {
    _cvc.dispose();
    super.dispose();
  }

  double get _total {
    final cart = context.read<CartController>();
    return context.read<CheckoutController>().total(cart.subtotal);
  }

  Future<void> _pay() async {
    final service = context.read<AppDependencies>().payment;
    final cards = context.read<CardController>();
    final card =
        cards.byId(context.read<CheckoutController>().cardId) ??
        cards.defaultCard;
    if (!service.usesExternalSheet) {
      if (card == null) return;
      if (!_formKey.currentState!.validate()) return;
    }
    final l = context.l10n;
    setState(() => _state = _PayState.processing);
    final result = await service.payByCard(
      amount: _total,
      card: service.usesExternalSheet || card == null
          ? null
          : CardDetails(
              number: card.last4,
              holder: card.holder,
              expiry: card.expiry,
              cvc: _cvc.text,
            ),
    );
    if (!mounted) return;
    if (!result.success) {
      setState(() {
        _state = _PayState.failed;
        _failure = result.error == 'card_declined'
            ? l.paymentDeclined
            : l.paymentFailedGeneric;
      });
      return;
    }
    try {
      final order = await completeOrder(
        context,
        notificationTitle: l.notifOrderPlacedTitle,
        notificationBody: l.notifOrderPlacedBody,
        paymentRef: result.reference,
      );
      if (mounted) context.pushAndClear(AppRoutes.orderSuccess, args: order.id);
    } catch (_) {
      if (mounted) {
        setState(() {
          _state = _PayState.failed;
          _failure = l.somethingWentWrong;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final service = context.read<AppDependencies>().payment;
    final cards = context.watch<CardController>();
    final card =
        cards.byId(context.watch<CheckoutController>().cardId) ??
        cards.defaultCard;
    return PopScope(
      canPop: _state != _PayState.processing,
      child: KeyboardDismiss(
        child: AppBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppTopBar(title: l.payment),
            body: ContentWidth(
              maxWidth: 560,
              child: switch (_state) {
                _PayState.processing => _Processing(label: l.processingPayment),
                _PayState.failed => _Failed(
                  message: _failure ?? l.paymentFailedGeneric,
                  onRetry: () => setState(() => _state = _PayState.form),
                ),
                _PayState.form => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    if (card != null && !service.usesExternalSheet) ...[
                      CardPreview.saved(card),
                      kHeight10,
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: Text(l.changeCard),
                        ),
                      ),
                      kHeight10,
                      Form(
                        key: _formKey,
                        child: AppTextField(
                          label: l.cvcConfirm,
                          hint: '123',
                          controller: _cvc,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: Validators.cvc(l),
                        ),
                      ),
                      kHeight10,
                      Text(
                        l.testCardHint,
                        textAlign: TextAlign.center,
                        style: ts(12, w: FontWeight.w400, c: color.kGrey),
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          l.stripeSheetHint,
                          textAlign: TextAlign.center,
                          style: ts(14, w: FontWeight.w400, c: color.kGrey),
                        ),
                      ),
                    kHeight25,
                    PrimaryButton(
                      label: l.payAmount(money(_total)),
                      icon: Icons.lock_outline_rounded,
                      onPressed: (card != null || service.usesExternalSheet)
                          ? _pay
                          : null,
                    ),
                  ],
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Processing extends StatelessWidget {
  final String label;
  const _Processing({required this.label});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: color.primaryDarkColor),
        kHeight20,
        Text(label, style: ts(16, w: FontWeight.w500)),
      ],
    ),
  );
}

class _Failed extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _Failed({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.error.withValues(alpha: 0.15),
                ),
                child: Icon(Icons.close_rounded, size: 60, color: color.error),
              ),
            ),
            kHeight25,
            Text(l.paymentFailedTitle, style: ts(22, w: FontWeight.w700)),
            kHeight10,
            Text(
              message,
              textAlign: TextAlign.center,
              style: ts(14, w: FontWeight.w400, c: color.kGrey),
            ),
            kHeight30,
            PrimaryButton(label: l.tryAgain, onPressed: onRetry),
            kHeight10,
            SecondaryButton(
              label: l.changePaymentMethod,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}
