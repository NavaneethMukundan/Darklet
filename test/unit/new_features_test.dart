import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/cart/controller/wishlist_controller.dart';
import 'package:darklet/src/checkout/controller/checkout_controller.dart';
import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/coupon.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/repositories/coupon_repository.dart';
import 'package:darklet/src/repositories/routed_user_data_repository.dart';
import 'package:darklet/src/search/controller/search_history.dart';
import 'package:darklet/src/services/connectivity_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

const _address = Address(
  id: 'a',
  label: 'Home',
  fullName: 'A',
  phone: '1',
  line1: 'x',
  city: 'c',
  state: 's',
  zip: 'z',
  country: 'k',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Product variants', () {
    const phone = Product(
      id: 'p',
      name: 'Phone',
      brand: 'B',
      categoryId: 'phones',
      description: '',
      price: 800,
      images: [],
      options: [
        ProductOption('Storage', [
          OptionValue('128 GB', priceDelta: -100),
          OptionValue('256 GB'),
          OptionValue('512 GB', priceDelta: 150),
        ]),
        ProductOption('Color', [OptionValue('Black'), OptionValue('Blue')]),
      ],
    );

    test('price and label follow the selection', () {
      expect(phone.defaultSelection, [0, 0]);
      expect(phone.priceFor([0, 0]), 700);
      expect(phone.priceFor([2, 1]), 950);
      expect(phone.variantLabel([1, 1]), '256 GB • Blue');
    });

    test('JSON round trip keeps options', () {
      final copy = Product.fromJson(phone.toJson());
      expect(copy.options.length, 2);
      expect(copy.options.first.values.last.priceDelta, 150);
    });

    test('cart keeps different variants as separate lines', () async {
      final d = await testDeps();
      final cart = CartController(d.userData)..bindUser('u1');
      await settle();
      cart.add(phone, selection: [1, 0]);
      cart.add(phone, selection: [1, 0]);
      cart.add(phone, selection: [2, 1]);
      expect(cart.items.length, 2);
      expect(cart.quantityOf('p'), 3);
      final line = cart.items.first;
      expect(line.lineId, 'p|256 GB • Black');
      expect(line.price, 800);
      expect(line.quantity, 2);
      cart.remove(line.lineId);
      expect(cart.items.single.variant, '512 GB • Blue');
      expect(cart.subtotal, 950);
    });
  });

  group('Coupons', () {
    test('discount maths', () {
      const pct = Coupon(code: 'A', type: 'percent', value: 10);
      const amt = Coupon(code: 'B', type: 'amount', value: 500);
      expect(pct.discountFor(200), 20);
      expect(amt.discountFor(200), 200); // never more than the subtotal
      expect(const Coupon(code: 'C', type: 'freeShipping').discountFor(99), 0);
    });

    test('mock repository validates codes', () async {
      final d = await testDeps();
      expect((await d.coupons.validate(' dark10 ', 100)).value, 10);
      expect(
        () => d.coupons.validate('NOPE', 100),
        throwsA(
          isA<CouponException>().having(
            (e) => e.error,
            'e',
            CouponError.notFound,
          ),
        ),
      );
      expect(
        () => d.coupons.validate('SAVE20', 50),
        throwsA(
          isA<CouponException>().having(
            (e) => e.error,
            'e',
            CouponError.minSubtotal,
          ),
        ),
      );
    });

    test('checkout totals include discount and free shipping', () async {
      final d = await testDeps();
      final c = CheckoutController(d.coupons);
      expect(await c.applyCoupon('DARK10', 200), isNull);
      expect(c.discount(200), 20);
      expect(c.total(200), 200 - 20 + DeliveryOption.standard.price);
      expect(await c.applyCoupon('FREESHIP', 200), isNull);
      expect(c.deliveryFee(200), 0);
      expect(c.total(200), 200);
      expect(await c.applyCoupon('bad', 200), isNotNull);
      expect(c.coupon?.code, 'FREESHIP'); // a failed attempt keeps the old one
      c.removeCoupon();
      expect(c.coupon, isNull);
    });
  });

  group('Orders: cancel and totals', () {
    test('cancel works only while placed / confirmed', () async {
      final d = await testDeps();
      final order = await d.orders.placeOrder(
        'u1',
        items: const [
          CartItem(productId: 'p', name: 'P', image: '', price: 100),
        ],
        address: _address,
        delivery: DeliveryOption.standard,
        deliveryFee: 4.99,
        paymentMethod: PaymentMethod.cashOnDelivery,
        discount: 10,
        couponCode: 'DARK10',
      );
      expect(order.total, closeTo(94.99, 0.001));
      expect(order.canCancel, isTrue);
      final cancelled = await d.orders.cancelOrder('u1', order.id);
      expect(cancelled.status, OrderStatus.cancelled);
      expect(cancelled.events.last.status, OrderStatus.cancelled);
      expect(cancelled.discount, 10);
      // Already cancelled -> cannot cancel again.
      expect(() => d.orders.cancelOrder('u1', order.id), throwsStateError);
      // Seeded shipped order cannot be cancelled either.
      expect(
        () => d.orders.cancelOrder('demo-user', 'DK-1042'),
        throwsStateError,
      );
    });
  });

  group('Cards wallet', () {
    test('setDefault keeps exactly one default', () async {
      final d = await testDeps();
      final c = CardController(d.userData)..bindUser('u3');
      await settle();
      final a = c.add(
        number: '4242 4242 4242 4242',
        holder: 'A',
        expiry: '12/40',
      );
      c.add(number: '5555 5555 5555 4444', holder: 'A', expiry: '12/40');
      c.setDefault(a.id);
      expect(c.items.where((x) => x.isDefault).single.id, a.id);
    });
  });

  group('Guest mode', () {
    test('guest has an id, persists, and leaves on sign in', () async {
      final d = await testDeps();
      final auth = AuthController(d.auth, d.prefs);
      await auth.init();
      expect(auth.userId, isNull);
      await auth.continueAsGuest();
      expect(auth.isGuest, isTrue);
      expect(auth.userId, 'guest');
      final again = AuthController(d.auth, d.prefs);
      await again.init();
      expect(again.isGuest, isTrue);
      expect(
        await again.signIn(AppConfig.demoEmail, AppConfig.demoPassword),
        isNull,
      );
      expect(again.isGuest, isFalse);
      expect(again.userId, 'demo-user');
      await again.signOut();
      expect(again.userId, isNull);
    });

    test('guest data is routed to local storage', () async {
      final d = await testDeps();
      var remoteCalls = 0;
      final routed = RoutedUserDataRepository(
        local: d.userData,
        remote: _Counting(d.userData, () => remoteCalls++),
      );
      await routed.saveWishlist('guest', ['a']);
      expect(await routed.loadWishlist('guest'), ['a']);
      expect(remoteCalls, 0);
      await routed.saveWishlist('u1', ['b']);
      expect(remoteCalls, 1);
    });
  });

  group('Guest -> account merge', () {
    test('cart and wishlist carry over on sign in', () async {
      final d = await testDeps();
      // The account already has one phone line in its cart.
      await d.userData.saveCart('demo-user', const [
        CartItem(
          productId: 'ph-1',
          name: 'Nova',
          image: '',
          price: 700,
          variant: 'a',
        ),
      ]);
      final cart = CartController(d.userData)..bindUser('guest');
      final wish = WishlistController(d.userData, d.products)
        ..bindUser('guest');
      await settle();
      final product = (await d.products.getProduct('au-1'))!;
      cart.add(product);
      cart.addItem(
        const CartItem(
          productId: 'ph-1',
          name: 'Nova',
          image: '',
          price: 700,
          variant: 'a',
        ),
      );
      wish.toggle(product);
      await settle();

      cart.bindUser('demo-user');
      wish.bindUser('demo-user');
      await settle();
      await settle();

      expect(cart.quantityOf('au-1'), 1);
      expect(cart.quantityOf('ph-1'), 2); // merged with the account's line
      expect(wish.contains('au-1'), isTrue);
      // The guest storage is emptied.
      expect(await d.userData.loadCart('guest'), isEmpty);
      expect(await d.userData.loadWishlist('guest'), isEmpty);
      // ...and what was merged is persisted for the account.
      expect((await d.userData.loadCart('demo-user')).length, 2);
    });

    test(
      'signing out of an account does not leak items into the next user',
      () async {
        final d = await testDeps();
        final cart = CartController(d.userData)..bindUser('u1');
        await settle();
        cart.add((await d.products.getProduct('au-1'))!);
        cart.bindUser('u2');
        await settle();
        expect(cart.isEmpty, isTrue);
      },
    );
  });

  group('Search history', () {
    test('keeps newest first, de-duplicates, caps and clears', () async {
      final d = await testDeps();
      final h = SearchHistory(d.prefs);
      await h.add('phone');
      await h.add('laptop');
      await h.add('PHONE');
      expect(h.items, ['PHONE', 'laptop']);
      await h.add('x'); // too short
      expect(h.items.length, 2);
      for (var i = 0; i < 12; i++) {
        await h.add('term $i');
      }
      expect(h.items.length, SearchHistory.maxItems);
      await h.clear();
      expect(h.items, isEmpty);
    });
  });

  test('connectivity controller flags offline and reconnect', () {
    final c = ConnectivityController(listen: false);
    expect(c.online, isTrue);
    c.setOnline(false);
    expect(c.online, isFalse);
    c.setOnline(true);
    expect(c.justReconnected, isTrue);
  });
}

/// Delegates to [inner] and counts calls (used to prove routing).
class _Counting extends RoutedUserDataRepository {
  final void Function() onCall;
  _Counting(dynamic inner, this.onCall) : super(local: inner, remote: inner);

  @override
  Future<void> saveWishlist(String u, List<String> v) {
    onCall();
    return super.saveWishlist(u, v);
  }
}
