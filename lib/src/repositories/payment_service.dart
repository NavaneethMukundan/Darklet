import 'dart:async';

class CardDetails {
  final String number;
  final String holder;
  final String expiry; // MM/YY
  final String cvc;
  const CardDetails({
    required this.number,
    required this.holder,
    required this.expiry,
    required this.cvc,
  });
}

class PaymentResult {
  final bool success;
  final String? reference;
  final String? error;
  const PaymentResult.ok(this.reference) : success = true, error = null;
  const PaymentResult.failed(this.error) : success = false, reference = null;
}

abstract class PaymentService {
  /// `true` when the service renders its own payment UI (e.g. Stripe's
  /// PaymentSheet) so the app should not show the manual card form.
  bool get usesExternalSheet;

  Future<PaymentResult> payByCard({required double amount, CardDetails? card});
}

/// Simulates a card gateway. Use test card `4000 0000 0000 0002` to see a
/// declined payment; anything else that passes Luhn succeeds.
class MockPaymentService implements PaymentService {
  final Duration latency;
  const MockPaymentService({this.latency = const Duration(milliseconds: 1200)});

  static const declineCard = '4000000000000002';

  @override
  bool get usesExternalSheet => false;

  @override
  Future<PaymentResult> payByCard({
    required double amount,
    CardDetails? card,
  }) async {
    await Future<void>.delayed(latency);
    final digits = (card?.number ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits == declineCard || digits.endsWith('0002')) {
      return const PaymentResult.failed('card_declined');
    }
    return PaymentResult.ok('mock_${DateTime.now().millisecondsSinceEpoch}');
  }
}
