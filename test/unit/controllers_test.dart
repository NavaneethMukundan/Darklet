import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/cart/controller/wishlist_controller.dart';
import 'package:darklet/src/checkout/controller/checkout_controller.dart';
import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/products/controller/product_list_controller.dart';
import 'package:darklet/src/repositories/payment_service.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/settings/controller/locale_controller.dart';
import 'package:darklet/src/settings/controller/theme_controller.dart';
import 'package:darklet/src/utils/helpers/load_status.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

const _p = Product(
  id: 'x1',
  name: 'Thing',
  brand: 'B',
  categoryId: 'phones',
  description: '',
  price: 100,
  oldPrice: 125,
  images: [],
);

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Product model', () {
    test('computes discount and survives a JSON round trip', () {
      expect(_p.discountPercent, 20);
      final copy = Product.fromJson(_p.toJson());
      expect(copy.id, 'x1');
      expect(copy.oldPrice, 125);
    });
  });

  group('CartController', () {
    test('adds, merges, caps quantity, removes and totals', () async {
      final d = await testDeps();
      final cart = CartController(d.userData)..bindUser('u1');
      await settle();
      cart.add(_p);
      cart.add(_p, quantity: 2);
      expect(cart.quantityOf('x1'), 3);
      expect(cart.subtotal, 300);
      cart.setQuantity('x1', 99);
      expect(cart.quantityOf('x1'), CartController.maxQuantity);
      cart.setQuantity('x1', 0);
      expect(cart.isEmpty, isTrue);
    });

    test('persists per user and restores', () async {
      final d = await testDeps();
      final a = CartController(d.userData)..bindUser('u1');
      await settle();
      a.add(_p, quantity: 2);
      await settle();
      final b = CartController(d.userData)..bindUser('u1');
      await settle();
      expect(b.itemCount, 2);
      b.bindUser('u2');
      await settle();
      expect(b.isEmpty, isTrue);
    });

    test('restore puts a removed item back', () async {
      final d = await testDeps();
      final cart = CartController(d.userData)..bindUser('u1');
      await settle();
      cart.add(_p);
      final item = cart.items.first;
      cart.remove('x1');
      cart.restore(item);
      expect(cart.quantityOf('x1'), 1);
    });
  });

  group('WishlistController', () {
    test('toggles and persists', () async {
      final d = await testDeps();
      final w = WishlistController(d.userData, d.products)..bindUser('u1');
      await settle();
      final product = (await d.products.getProduct('ph-1'))!;
      w.toggle(product);
      expect(w.contains('ph-1'), isTrue);
      await settle();
      final w2 = WishlistController(d.userData, d.products)..bindUser('u1');
      await settle();
      expect(w2.items.single.id, 'ph-1');
      w2.toggle(product);
      expect(w2.items, isEmpty);
    });
  });

  group('AddressController', () {
    Address a(String id, {bool def = false}) => Address(
      id: id,
      label: id,
      fullName: 'n',
      phone: 'p',
      line1: 'l',
      city: 'c',
      state: 's',
      zip: 'z',
      country: 'k',
      isDefault: def,
    );

    test(
      'first address becomes default; default can move; delete re-assigns',
      () async {
        final d = await testDeps();
        final c = AddressController(d.userData)..bindUser('fresh');
        await settle();
        c.save(a('1'));
        expect(c.defaultAddress!.id, '1');
        c.save(a('2'));
        expect(c.defaultAddress!.id, '1');
        c.setDefault('2');
        expect(c.defaultAddress!.id, '2');
        c.delete('2');
        expect(c.defaultAddress!.id, '1');
        expect(c.items.length, 1);
      },
    );
  });

  group('CardController', () {
    test(
      'adds cards keeping only last4, newest is default, persists',
      () async {
        final d = await testDeps();
        final c = CardController(d.userData)..bindUser('u9');
        await settle();
        expect(c.isEmpty, isTrue);
        c.add(number: '4242 4242 4242 4242', holder: 'A', expiry: '12/40');
        final second = c.add(
          number: '5555 5555 5555 4444',
          holder: 'A',
          expiry: '01/41',
        );
        expect(second.brand, 'mastercard');
        expect(second.last4, '4444');
        expect(c.defaultCard!.id, second.id);
        expect(c.items.where((x) => x.isDefault).length, 1);
        await settle();
        final again = CardController(d.userData)..bindUser('u9');
        await settle();
        expect(again.items.length, 2);
        again.remove(second.id);
        expect(again.defaultCard!.last4, '4242');
      },
    );
  });

  group('CheckoutController', () {
    test('computes delivery fees including the free-shipping threshold', () {
      final c = CheckoutController();
      expect(c.deliveryFee(100), DeliveryOption.standard.price);
      expect(c.deliveryFee(5000), 0);
      c.selectDelivery(DeliveryOption.express);
      expect(c.deliveryFee(5000), DeliveryOption.express.price);
      expect(c.total(100), 100 + DeliveryOption.express.price);
      c.selectDelivery(DeliveryOption.pickup);
      expect(c.deliveryFee(10), 0);
    });
  });

  group('ProductListController', () {
    test('loads, paginates and applies queries', () async {
      final d = await testDeps();
      final c = ProductListController(d.products, pageSize: 6);
      await c.load();
      expect(c.status, LoadStatus.loaded);
      expect(c.items.length, 6);
      expect(c.hasMore, isTrue);
      expect(c.brands, isNotEmpty);
      for (var i = 0; i < 4; i++) {
        await c.loadMore();
      }
      expect(c.items.length, 28);
      expect(c.hasMore, isFalse);
      await c.setQuery(const ProductQuery(categoryId: 'audio'));
      expect(c.items.every((p) => p.categoryId == 'audio'), isTrue);
      expect(c.query.activeFilters, 1);
    });
  });

  group('HomeController', () {
    test(
      'loads home data and tracks recently viewed (max, no dupes)',
      () async {
        final d = await testDeps();
        final h = HomeController(d.products, d.prefs);
        await h.load();
        expect(h.categories.length, 5);
        expect(h.flashSale, isNotEmpty);
        final all = (await d.products.searchProducts(
          const ProductQuery(),
          pageSize: 100,
        )).items;
        for (final p in all) {
          await h.markViewed(p);
        }
        await h.markViewed(all.first);
        expect(h.recentlyViewed.length, HomeController.maxRecent);
        expect(h.recentlyViewed.first.id, all.first.id);
        final h2 = HomeController(d.products, d.prefs);
        await h2.load();
        expect(h2.recentlyViewed.first.id, all.first.id);
      },
    );
  });

  group('Theme & locale', () {
    test('theme mode persists and drives ColorManager', () async {
      final d = await testDeps();
      final t = ThemeController(d.prefs);
      await t.setMode(ThemeMode.dark);
      expect(ColorManager.isDark, isTrue);
      expect(ThemeController(d.prefs).mode, ThemeMode.dark);
      await t.setMode(ThemeMode.light);
      expect(ColorManager.isDark, isFalse);
      t.dispose();
    });

    test('locale persists', () async {
      final d = await testDeps();
      final l = LocaleController(d.prefs);
      expect(l.locale.languageCode, 'en');
      await l.setLocale(const Locale('ar'));
      expect(l.isRtl, isTrue);
      expect(LocaleController(d.prefs).locale.languageCode, 'ar');
      await l.setLocale(const Locale('en'));
    });
  });

  group('MockPaymentService', () {
    test('succeeds normally and declines the test card', () async {
      const s = MockPaymentService(latency: Duration.zero);
      expect(
        (await s.payByCard(
          amount: 10,
          card: const CardDetails(
            number: '4242 4242 4242 4242',
            holder: 'a',
            expiry: '12/40',
            cvc: '123',
          ),
        )).success,
        isTrue,
      );
      final declined = await s.payByCard(
        amount: 10,
        card: const CardDetails(
          number: '4000 0000 0000 0002',
          holder: 'a',
          expiry: '12/40',
          cvc: '123',
        ),
      );
      expect(declined.success, isFalse);
      expect(declined.error, 'card_declined');
    });
  });
}
