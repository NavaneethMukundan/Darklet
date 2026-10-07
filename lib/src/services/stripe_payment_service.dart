import 'dart:convert';

import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/repositories/payment_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide CardDetails;
import 'package:http/http.dart' as http;

/// Card payments through Stripe's PaymentSheet.
///
/// Your backend (see firebase/functions/index.js) creates a PaymentIntent and
/// returns `{ "clientSecret": "..." }`. The secret key never touches the app.
class StripePaymentService implements PaymentService {
  static bool get isConfigured =>
      AppConfig.stripePublishableKey.isNotEmpty &&
      AppConfig.paymentBackendUrl.isNotEmpty;

  static void init() {
    Stripe.publishableKey = AppConfig.stripePublishableKey;
  }

  @override
  bool get usesExternalSheet => true;

  @override
  Future<PaymentResult> payByCard({
    required double amount,
    CardDetails? card,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(AppConfig.paymentBackendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': (amount * 100).round(), 'currency': 'usd'}),
      );
      if (res.statusCode != 200) {
        return const PaymentResult.failed('backend_error');
      }
      final secret = jsonDecode(res.body)['clientSecret'] as String;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: secret,
          merchantDisplayName: AppConfig.appName,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return PaymentResult.ok(secret.split('_secret').first);
    } on StripeException catch (e) {
      final code = e.error.code;
      return PaymentResult.failed(
        code == FailureCode.Canceled ? 'cancelled' : 'card_declined',
      );
    } catch (_) {
      return const PaymentResult.failed('unknown');
    }
  }
}
