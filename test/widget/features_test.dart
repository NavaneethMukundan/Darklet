import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/cart/view/cart.dart';
import 'package:darklet/src/checkout/view/checkout.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/orders/view/order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../helpers/test_helpers.dart';

const _p = Product(
  id: 'x',
  name: 'Gadget',
  brand: 'B',
  categoryId: 'audio',
  description: '',
  price: 200,
  images: [],
  stock: 5,
);

Future<void> _pumpFor(WidgetTester t, [int ms = 300]) async {
  await t.pump(Duration(milliseconds: ms));
  await t.pump(Duration(milliseconds: ms));
}

/// Scrolls the first list until [finder] has been built (lists are lazy).
Future<void> _scrollTo(WidgetTester t, Finder finder) async {
  for (var i = 0; i < 12 && finder.evaluate().isEmpty; i++) {
    await t.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await t.pump(const Duration(milliseconds: 100));
  }
  await t.ensureVisible(finder);
  await t.pump();
}

void main() {
  testWidgets('promo code applies at checkout and shows a discount line', (
    tester,
  ) async {
    await pumpScreen(tester, const CheckoutScreen());
    final context = tester.element(find.byType(CheckoutScreen));
    context.read<CartController>().add(_p);
    await _pumpFor(tester);

    await _scrollTo(tester, find.text('Promo code'));
    await tester.enterText(find.byType(TextField).first, 'nope');
    await tester.tap(find.text('Apply'));
    await _pumpFor(tester);
    expect(find.text("This code isn't valid"), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'dark10');
    await tester.tap(find.text('Apply'));
    await _pumpFor(tester);
    expect(find.text('DARK10 applied'), findsOneWidget);
    await _scrollTo(tester, find.text('Discount'));
    expect(find.text(r'-$20.00'), findsOneWidget);
  });

  testWidgets('a guest is asked to sign in before checkout', (tester) async {
    final deps = await testDeps();
    await pumpScreen(tester, const CartScreen(), signedIn: false, deps: deps);
    final context = tester.element(find.byType(CartScreen));
    await tester.runAsync(
      () => context.read<AuthController>().continueAsGuest(),
    );
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    context.read<CartController>().add(_p);
    await tester.pump();

    await tester.tap(find.text('Checkout'));
    await _pumpFor(tester);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.byType(CheckoutScreen), findsNothing);
  });

  testWidgets(
    'order details: buy again fills the cart; shipped can not be cancelled',
    (tester) async {
      await pumpScreen(tester, const OrderDetailsScreen(orderId: 'DK-1042'));
      final context = tester.element(find.byType(OrderDetailsScreen));
      await _pumpFor(tester);

      expect(
        find.text('Cancel order'),
        findsNothing,
      ); // seeded order is shipped
      await _scrollTo(tester, find.text('Buy again'));
      await tester.tap(find.text('Buy again'));
      await _pumpFor(tester);
      expect(context.read<CartController>().quantityOf('au-3'), 1);
    },
  );
}
