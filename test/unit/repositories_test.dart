import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/cart_item.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/models/review.dart';
import 'package:darklet/src/repositories/auth_repository.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockProductRepository', () {
    test('loads categories and the full catalogue', () async {
      final d = await testDeps();
      expect((await d.products.getCategories()).length, 5);
      final page = await d.products.searchProducts(
        const ProductQuery(),
        pageSize: 100,
      );
      expect(page.items.length, 28);
      expect(page.hasMore, isFalse);
    });

    test('paginates', () async {
      final d = await testDeps();
      final p0 = await d.products.searchProducts(
        const ProductQuery(),
        page: 0,
        pageSize: 6,
      );
      final p2 = await d.products.searchProducts(
        const ProductQuery(),
        page: 4,
        pageSize: 6,
      );
      final p3 = await d.products.searchProducts(
        const ProductQuery(),
        page: 5,
        pageSize: 6,
      );
      expect(p0.items.length, 6);
      expect(p0.hasMore, isTrue);
      expect(p2.items.length, 4);
      expect(p2.hasMore, isFalse);
      expect(p3.items, isEmpty);
    });

    test('filters by category, brand, price and text', () async {
      final d = await testDeps();
      final phones = await d.products.searchProducts(
        const ProductQuery(categoryId: 'phones'),
        pageSize: 100,
      );
      expect(phones.items.every((p) => p.categoryId == 'phones'), isTrue);

      final cheap = await d.products.searchProducts(
        const ProductQuery(maxPrice: 100),
        pageSize: 100,
      );
      expect(cheap.items.every((p) => p.price <= 100), isTrue);
      expect(cheap.items, isNotEmpty);

      final brand = await d.products.searchProducts(
        const ProductQuery(brands: {'Titan'}),
        pageSize: 100,
      );
      expect(brand.items.map((p) => p.brand).toSet(), {'Titan'});

      final text = await d.products.searchProducts(
        const ProductQuery(query: 'nebula'),
        pageSize: 100,
      );
      expect(text.items.single.id, 'lp-4');
    });

    test('sorts by price', () async {
      final d = await testDeps();
      final asc = await d.products.searchProducts(
        const ProductQuery(sort: ProductSort.priceLowHigh),
        pageSize: 100,
      );
      final prices = asc.items.map((p) => p.price).toList();
      expect(prices, [...prices]..sort());
    });

    test('stores reviews', () async {
      final d = await testDeps();
      final before = (await d.products.getReviews('ph-1')).length;
      await d.products.addReview(
        Review(
          id: 'x',
          productId: 'ph-1',
          userName: 'Tester',
          rating: 5,
          comment: 'Great',
          createdAt: DateTime.now(),
        ),
      );
      expect((await d.products.getReviews('ph-1')).length, before + 1);
    });
  });

  group('MockAuthRepository', () {
    test('signs in the demo user and restores the session', () async {
      final d = await testDeps();
      expect(await d.auth.currentUser(), isNull);
      final u = await d.auth.signIn(
        AppConfig.demoEmail,
        AppConfig.demoPassword,
      );
      expect(u.name, 'John Doe');
      expect((await d.auth.currentUser())?.id, u.id);
      await d.auth.signOut();
      expect(await d.auth.currentUser(), isNull);
    });

    test('rejects wrong credentials', () async {
      final d = await testDeps();
      expect(
        () => d.auth.signIn(AppConfig.demoEmail, 'nope'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.error,
            'error',
            AuthError.invalidCredentials,
          ),
        ),
      );
    });

    test('registers, blocks duplicates and weak passwords', () async {
      final d = await testDeps();
      final u = await d.auth.register('Ann', 'ann@x.io', 'secret1');
      expect(u.email, 'ann@x.io');
      expect(
        () => d.auth.register('Ann', 'ann@x.io', 'secret1'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.error,
            'e',
            AuthError.emailInUse,
          ),
        ),
      );
      expect(
        () => d.auth.register('Bo', 'bo@x.io', '123'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.error,
            'e',
            AuthError.weakPassword,
          ),
        ),
      );
    });

    test('updates profile and changes password', () async {
      final d = await testDeps();
      await d.auth.signIn(AppConfig.demoEmail, AppConfig.demoPassword);
      final u = await d.auth.updateProfile(name: 'Johnny', phone: '123');
      expect(u.name, 'Johnny');
      await d.auth.changePassword(AppConfig.demoPassword, 'newpass1');
      await d.auth.signOut();
      expect(
        (await d.auth.signIn(AppConfig.demoEmail, 'newpass1')).name,
        'Johnny',
      );
    });
  });

  group('Order + user data repositories', () {
    test('demo user starts with seeded orders and an address', () async {
      final d = await testDeps();
      expect((await d.orders.getOrders('demo-user')).length, 2);
      expect(
        (await d.userData.loadAddresses('demo-user')).single.isDefault,
        isTrue,
      );
      expect(await d.userData.loadAddresses('someone-else'), isEmpty);
    });

    test('places an order and lists it first', () async {
      final d = await testDeps();
      const address = Address(
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
      final order = await d.orders.placeOrder(
        'u1',
        items: const [
          CartItem(
            productId: 'p',
            name: 'P',
            image: '',
            price: 10,
            quantity: 3,
          ),
        ],
        address: address,
        delivery: DeliveryOption.express,
        deliveryFee: 12.99,
        paymentMethod: PaymentMethod.cashOnDelivery,
      );
      expect(order.subtotal, 30);
      expect(order.total, closeTo(42.99, 0.001));
      expect(order.status, OrderStatus.placed);
      expect((await d.orders.getOrders('u1')).first.id, order.id);
      expect((await d.orders.getOrder('u1', order.id))?.itemCount, 3);
    });

    test('persists cart and wishlist per user', () async {
      final d = await testDeps();
      await d.userData.saveCart('u1', const [
        CartItem(productId: 'p', name: 'P', image: '', price: 1),
      ]);
      await d.userData.saveWishlist('u1', ['ph-1']);
      expect((await d.userData.loadCart('u1')).single.productId, 'p');
      expect(await d.userData.loadWishlist('u1'), ['ph-1']);
      expect(await d.userData.loadCart('u2'), isEmpty);
    });
  });
}
