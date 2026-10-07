import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/repositories/auth_repository.dart';
import 'package:darklet/src/repositories/coupon_repository.dart';
import 'package:darklet/src/repositories/firebase/firebase_coupon_repository.dart';
import 'package:darklet/src/repositories/mock/mock_coupon_repository.dart';
import 'package:darklet/src/repositories/routed_user_data_repository.dart';
import 'package:darklet/src/repositories/mock/mock_auth_repository.dart';
import 'package:darklet/src/repositories/mock/mock_order_repository.dart';
import 'package:darklet/src/repositories/mock/mock_product_repository.dart';
import 'package:darklet/src/repositories/mock/mock_user_data_repository.dart';
import 'package:darklet/src/repositories/order_repository.dart';
import 'package:darklet/src/repositories/payment_service.dart';
import 'package:darklet/src/repositories/product_repository.dart';
import 'package:darklet/src/repositories/user_data_repository.dart';
import 'package:darklet/src/repositories/firebase/firebase_auth_repository.dart';
import 'package:darklet/src/repositories/firebase/firebase_order_repository.dart';
import 'package:darklet/src/repositories/firebase/firebase_product_repository.dart';
import 'package:darklet/src/repositories/firebase/firebase_user_data_repository.dart';
import 'package:darklet/src/services/stripe_payment_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Everything the controllers need from the outside world. Swapping the
/// backend means building a different [AppDependencies] - nothing else changes.
class AppDependencies {
  final SharedPreferences prefs;
  final AuthRepository auth;
  final ProductRepository products;
  final OrderRepository orders;
  final UserDataRepository userData;
  final CouponRepository coupons;
  final PaymentService payment;

  const AppDependencies({
    required this.prefs,
    required this.auth,
    required this.products,
    required this.orders,
    required this.userData,
    required this.coupons,
    required this.payment,
  });

  /// Offline demo backend.
  factory AppDependencies.mock(SharedPreferences prefs) => AppDependencies(
    prefs: prefs,
    auth: MockAuthRepository(),
    products: MockProductRepository(),
    orders: MockOrderRepository(),
    userData: MockUserDataRepository(),
    coupons: MockCouponRepository(),
    payment: const MockPaymentService(),
  );

  /// Firebase backend (Auth, Firestore, Storage). Card payments use Stripe
  /// when the keys in [AppConfig] are provided, otherwise the mock gateway.
  factory AppDependencies.firebase(SharedPreferences prefs) => AppDependencies(
    prefs: prefs,
    auth: FirebaseAuthRepository(),
    products: FirebaseProductRepository(),
    orders: FirebaseOrderRepository(),
    userData: RoutedUserDataRepository(
      local: MockUserDataRepository(),
      remote: FirebaseUserDataRepository(),
    ),
    coupons: FirebaseCouponRepository(),
    payment: StripePaymentService.isConfigured
        ? StripePaymentService()
        : const MockPaymentService(),
  );

  /// Builds dependencies for the backend selected in [AppConfig.useMock].
  static Future<AppDependencies> create() async {
    final prefs = await SharedPreferences.getInstance();
    if (AppConfig.useMock) return AppDependencies.mock(prefs);
    await Firebase.initializeApp();
    if (StripePaymentService.isConfigured) StripePaymentService.init();
    return AppDependencies.firebase(prefs);
  }
}
