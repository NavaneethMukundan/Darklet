/// Central app configuration - the one place to rebrand or switch backends.
///
/// Every value can be overridden at build time without touching code:
///   flutter run --dart-define=USE_MOCK=false
class AppConfig {
  AppConfig._();

  /// `true`  -> offline demo data (assets/mock/*.json + SharedPreferences).
  /// `false` -> Firebase (Auth, Firestore, Storage). See docs/FIREBASE_SETUP.md.
  static const bool useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: true,
  );

  static const String appName = 'Darklet';
  static const String currencySymbol = r'$';

  /// Fake network delay in mock mode so loading states are visible.
  static const Duration mockLatency = Duration(milliseconds: 500);

  /// Items loaded per page on product lists.
  static const int pageSize = 6;

  /// Flat shipping rates are defined in `DeliveryOption`; orders above this
  /// subtotal ship free with the Standard option.
  static const double freeShippingThreshold = 1000;

  // ---- Demo account (mock mode only) ------------------------------------
  static const String demoEmail = 'demo@darklet.app';
  static const String demoPassword = 'demo1234';

  // ---- Payments (never commit live keys; pass them with --dart-define) ----
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
  );

  /// Endpoint that creates a Stripe PaymentIntent and returns its
  /// `clientSecret`. See docs/STRIPE_SETUP.md.
  static const String paymentBackendUrl = String.fromEnvironment(
    'PAYMENT_BACKEND_URL',
  );
}
