import 'package:darklet/src/address/view/address_form.dart';
import 'package:darklet/src/cards/view/add_card.dart';
import 'package:darklet/src/cards/view/cards.dart';
import 'package:darklet/src/address/view/address_list.dart';
import 'package:darklet/src/auth/view/forgot_password.dart';
import 'package:darklet/src/auth/view/login.dart';
import 'package:darklet/src/auth/view/register.dart';
import 'package:darklet/src/cart/view/cart.dart';
import 'package:darklet/src/checkout/view/checkout.dart';
import 'package:darklet/src/checkout/view/order_success.dart';
import 'package:darklet/src/checkout/view/payment.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/product.dart';
import 'package:darklet/src/notifications/view/notifications.dart';
import 'package:darklet/src/onboarding/view/onboarding.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/orders/view/order_details.dart';
import 'package:darklet/src/orders/view/orders.dart';
import 'package:darklet/src/products/view/product_details.dart';
import 'package:darklet/src/products/view/products.dart';
import 'package:darklet/src/profile/view/change_password.dart';
import 'package:darklet/src/profile/view/edit_profile.dart';
import 'package:darklet/src/reviews/view/reviews.dart';
import 'package:darklet/src/reviews/view/write_review.dart';
import 'package:darklet/src/search/view/search.dart';
import 'package:darklet/src/settings/view/settings.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';

/// Arguments for [AppRoutes.products].
class ProductListArgs {
  final String? categoryId;
  final String title;
  const ProductListArgs({this.categoryId, required this.title});
}

/// Arguments for [AppRoutes.productDetails]. [heroTag] must match the tag used
/// by the card that opened the page so the image can fly between screens.
class ProductDetailsArgs {
  final Product product;
  final String heroTag;
  const ProductDetailsArgs(this.product, this.heroTag);
}

class AppRouter {
  AppRouter._();

  static Route<T> _page<T>(RouteSettings s, Widget child, {bool fade = false}) {
    if (fade) {
      return PageRouteBuilder<T>(
        settings: s,
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) => child,
        transitionsBuilder: (_, a, _, c) =>
            FadeTransition(opacity: a, child: c),
      );
    }
    return MaterialPageRoute<T>(settings: s, builder: (_) => child);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings s) {
    final a = s.arguments;
    switch (s.name) {
      case AppRoutes.splash:
        return _page(s, const SplashScreen(), fade: true);
      case AppRoutes.onboarding:
        return _page(s, const OnboardingScreen(), fade: true);
      case AppRoutes.login:
        return _page(s, const LoginScreen(), fade: true);
      case AppRoutes.register:
        return _page(s, const RegisterScreen());
      case AppRoutes.forgotPassword:
        return _page(s, const ForgotPasswordScreen());
      case AppRoutes.home:
        return _page(s, const BottomNavigation(), fade: true);
      case AppRoutes.products:
        return _page(s, ProductScreen(args: a as ProductListArgs));
      case AppRoutes.search:
        return _page(s, const SearchScreen());
      case AppRoutes.productDetails:
        return _page(s, ProductDetailsScreen(args: a as ProductDetailsArgs));
      case AppRoutes.reviews:
        return _page(s, ReviewsScreen(product: a as Product));
      case AppRoutes.writeReview:
        return _page(s, WriteReviewScreen(product: a as Product));
      case AppRoutes.cart:
        return _page(s, const CartScreen());
      case AppRoutes.checkout:
        return _page(s, const CheckoutScreen());
      case AppRoutes.cards:
        return _page(s, const CardsScreen());
      case AppRoutes.addCard:
        return _page(s, const AddCardScreen());
      case AppRoutes.payment:
        return _page(s, const PaymentScreen());
      case AppRoutes.orderSuccess:
        return _page(s, OrderSuccessScreen(orderId: a as String), fade: true);
      case AppRoutes.orders:
        return _page(s, const OrdersScreen());
      case AppRoutes.orderDetails:
        return _page(s, OrderDetailsScreen(orderId: a as String));
      case AppRoutes.addresses:
        return _page(s, AddressListScreen(selectMode: a == true));
      case AppRoutes.addressForm:
        return _page(s, AddressFormScreen(address: a as Address?));
      case AppRoutes.editProfile:
        return _page(s, const EditProfileScreen());
      case AppRoutes.changePassword:
        return _page(s, const ChangePasswordScreen());
      case AppRoutes.notifications:
        return _page(s, const NotificationsScreen());
      case AppRoutes.settings:
        return _page(s, const SettingsScreen());
    }
    return _page(s, const SplashScreen());
  }
}

extension AppNavigation on BuildContext {
  Future<T?> push<T>(String route, {Object? args}) async {
    // Routes are built as Route<dynamic>; cast the result instead of the route.
    final result = await Navigator.of(
      this,
    ).pushNamed<Object?>(route, arguments: args);
    return result as T?;
  }

  Future<void> pushReplace(String route, {Object? args}) => Navigator.of(
    this,
  ).pushReplacementNamed<Object?, void>(route, arguments: args);

  /// Clears the whole stack and shows [route].
  Future<void> pushAndClear(String route, {Object? args}) => Navigator.of(
    this,
  ).pushNamedAndRemoveUntil<Object?>(route, (_) => false, arguments: args);

  void pop<T>([T? result]) => Navigator.of(this).pop<T>(result);
}
