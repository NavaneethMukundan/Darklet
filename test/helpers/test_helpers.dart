import 'package:darklet/l10n/app_localizations.dart';
import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/repositories/mock/mock_auth_repository.dart';
import 'package:darklet/src/repositories/mock/mock_coupon_repository.dart';
import 'package:darklet/src/repositories/mock/mock_order_repository.dart';
import 'package:darklet/src/repositories/mock/mock_product_repository.dart';
import 'package:darklet/src/repositories/mock/mock_user_data_repository.dart';
import 'package:darklet/src/repositories/payment_service.dart';
import 'package:darklet/src/utils/resource/provider_notifier.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/app_theme.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _zero = Duration.zero;

/// Mock backend without artificial latency.
Future<AppDependencies> testDeps([
  Map<String, Object> prefsValues = const {},
]) async {
  SharedPreferences.setMockInitialValues(prefsValues);
  final prefs = await SharedPreferences.getInstance();
  // A fresh, non-caching bundle per test so a load left pending by one test
  // can never block the next.
  final bundle = PlatformAssetBundle();
  return AppDependencies(
    prefs: prefs,
    auth: MockAuthRepository(latency: _zero),
    products: MockProductRepository(latency: _zero, bundle: bundle),
    orders: MockOrderRepository(latency: _zero, bundle: bundle),
    userData: MockUserDataRepository(bundle: bundle),
    coupons: MockCouponRepository(latency: _zero, bundle: bundle),
    payment: const MockPaymentService(latency: Duration(milliseconds: 10)),
  );
}

/// Pumps [child] with all app providers, localisation and theme.
/// Signs the demo user in first when [signedIn] is true.
Future<AppDependencies> pumpScreen(
  WidgetTester tester,
  Widget child, {
  bool signedIn = true,
  AppDependencies? deps,
  Locale locale = const Locale('en'),
  Size size = const Size(420, 900),
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.resetPhysicalSize);
  ColorManager.isDark = false;
  final d = deps ?? await testDeps();
  await tester.pumpWidget(
    MultiProvider(
      providers: buildProviders(d),
      child: MaterialApp(
        theme: AppTheme.build(dark: false),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: child,
      ),
    ),
  );
  if (signedIn) {
    final auth = tester
        .element(find.byType(MaterialApp))
        .read<AuthController>();
    await tester.runAsync(
      () => auth.signIn(AppConfig.demoEmail, AppConfig.demoPassword),
    );
    // Rebuild so user-scoped controllers bind, then give real time for their
    // asset / preference reads to finish.
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 250)),
    );
  }
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  return d;
}
