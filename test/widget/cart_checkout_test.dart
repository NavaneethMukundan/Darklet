import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/checkout/view/checkout.dart';
import 'package:darklet/src/cart/view/cart.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/orders/controller/order_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../helpers/test_helpers.dart';

const _phone = Product(
  id: 'ph-1',
  name: 'Nova X Pro 256GB',
  brand: 'Nova',
  categoryId: 'phones',
  description: '',
  price: 799,
  images: [],
  stock: 5,
);

Future<void> _pumpFor(WidgetTester t, [int ms = 300]) async {
  await t.pump(Duration(milliseconds: ms));
  await t.pump(Duration(milliseconds: ms));
}

void main() {
  testWidgets('empty cart shows the empty state', (tester) async {
    await pumpScreen(tester, const CartScreen());
    await _pumpFor(tester);
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Start shopping'), findsOneWidget);
  });

  testWidgets('cart: quantity stepper, subtotal and remove with undo', (
    tester,
  ) async {
    await pumpScreen(tester, const CartScreen());
    await _pumpFor(tester);
    final context = tester.element(find.byType(CartScreen));
    final cart = context.read<CartController>();
    cart.add(_phone);
    await tester.pump();

    expect(find.text('Nova X Pro 256GB'), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(cart.quantityOf('ph-1'), 2);
    expect(find.text(r'$1,598'), findsWidgets);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(cart.isEmpty, isTrue);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Item removed'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pump();
    expect(cart.quantityOf('ph-1'), 2);
  });

  testWidgets('checkout with cash on delivery places an order', (tester) async {
    await pumpScreen(tester, const CheckoutScreen());
    await _pumpFor(tester);
    final context = tester.element(find.byType(CheckoutScreen));
    final cart = context.read<CartController>();
    cart.add(_phone);
    await _pumpFor(tester);

    // The demo user's default address is pre-selected.
    expect(context.read<AddressController>().defaultAddress, isNotNull);
    expect(find.textContaining('221 Market Street'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Cash on delivery'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Cash on delivery'));
    await tester.pump();

    await tester.tap(find.textContaining('Place order'));
    await _pumpFor(tester, 400);

    // The screen was replaced by the success page and the cart emptied.
    expect(find.text('Order placed!'), findsOneWidget);
    final nav = tester.element(find.text('Order placed!'));
    // Two seeded demo orders + the new one.
    final orders = nav.read<OrderController>().orders;
    expect(orders.length, 3);
    expect(orders.first.status, OrderStatus.placed);
    expect(orders.first.paymentMethod, PaymentMethod.cashOnDelivery);
    expect(nav.read<CartController>().isEmpty, isTrue);
    expect(AppRoutes.orderSuccess, isNotEmpty);
  });

  testWidgets('tapping the address opens the picker and returns the choice', (
    tester,
  ) async {
    await pumpScreen(tester, const CheckoutScreen());
    await _pumpFor(tester);
    final context = tester.element(find.byType(CheckoutScreen));
    context.read<CartController>().add(_phone);
    await _pumpFor(tester);

    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await _pumpFor(tester);
    // Used to throw: Route<dynamic> is not a Route<Address?>.
    await tester.tap(find.textContaining('221 Market Street'));
    await _pumpFor(tester);
    expect(find.text('Select address'), findsOneWidget);
    await tester.tap(find.text('John Doe'));
    await _pumpFor(tester);
    expect(find.byType(CheckoutScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('card payment needs a saved card; adding one enables continue', (
    tester,
  ) async {
    await pumpScreen(tester, const CheckoutScreen());
    await _pumpFor(tester);
    final context = tester.element(find.byType(CheckoutScreen));
    context.read<CartController>().add(_phone);
    await _pumpFor(tester);

    await tester.scrollUntilVisible(
      find.text('No saved cards'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    final button = find.byType(FilledButton, skipOffstage: false).last;
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    context.read<CardController>().add(
      number: '4242 4242 4242 4242',
      holder: 'John Doe',
      expiry: '12/40',
    );
    await _pumpFor(tester);
    expect(find.textContaining('•••• 4242'), findsWidgets);
    expect(find.text('Add new card'), findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
  });
}
