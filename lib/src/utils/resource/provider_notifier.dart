import 'package:darklet/src/address/controller/address_controller.dart';
import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/cards/controller/card_controller.dart';
import 'package:darklet/src/cart/controller/cart_controller.dart';
import 'package:darklet/src/cart/controller/wishlist_controller.dart';
import 'package:darklet/src/checkout/controller/checkout_controller.dart';
import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/home/controller/navigation_controller.dart';
import 'package:darklet/src/notifications/controller/notification_controller.dart';
import 'package:darklet/src/orders/controller/order_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// One provider per feature. User-scoped controllers are re-bound whenever
/// the signed-in user changes.
List<SingleChildWidget> buildProviders(AppDependencies d) => [
  Provider<AppDependencies>.value(value: d),
  ChangeNotifierProvider(create: (_) => AuthController(d.auth, d.prefs)),
  ChangeNotifierProvider(create: (_) => NavigationController()),
  ChangeNotifierProvider(create: (_) => HomeController(d.products, d.prefs)),
  ChangeNotifierProvider(create: (_) => CheckoutController(d.coupons)),
  ChangeNotifierProxyProvider<AuthController, CartController>(
    create: (_) => CartController(d.userData),
    update: (_, auth, c) => c!..bindUser(auth.userId),
  ),
  ChangeNotifierProxyProvider<AuthController, WishlistController>(
    create: (_) => WishlistController(d.userData, d.products),
    update: (_, auth, c) => c!..bindUser(auth.userId),
  ),
  ChangeNotifierProxyProvider<AuthController, AddressController>(
    create: (_) => AddressController(d.userData),
    update: (_, auth, c) => c!..bindUser(auth.userId),
  ),
  ChangeNotifierProxyProvider<AuthController, CardController>(
    create: (_) => CardController(d.userData),
    update: (_, auth, c) => c!..bindUser(auth.userId),
  ),
  ChangeNotifierProxyProvider<AuthController, OrderController>(
    create: (_) => OrderController(d.orders),
    update: (_, auth, c) => c!..bindUser(auth.userId),
  ),
  ChangeNotifierProxyProvider<AuthController, NotificationController>(
    create: (_) => NotificationController(d.userData),
    update: (_, auth, c) => c!..bindUser(auth.userId),
  ),
];
