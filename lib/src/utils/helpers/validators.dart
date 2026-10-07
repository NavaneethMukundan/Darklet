import 'package:darklet/l10n/app_localizations.dart';
import 'package:darklet/src/utils/constants/app_constants.dart';

/// Form validators returning a localised message or `null` when valid.
class Validators {
  Validators._();

  static String? Function(String?) required(AppLocalizations l) =>
      (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null;

  static String? Function(String?) email(AppLocalizations l) => (v) {
    if (v == null || v.trim().isEmpty) return l.fieldRequired;
    return AppConstants.emailRegex.hasMatch(v.trim()) ? null : l.invalidEmail;
  };

  static String? Function(String?) password(AppLocalizations l) => (v) {
    if (v == null || v.isEmpty) return l.fieldRequired;
    return v.length < AppConstants.minPasswordLength
        ? l.passwordTooShort(AppConstants.minPasswordLength)
        : null;
  };

  /// Luhn check for card numbers.
  static bool luhn(String number) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 12) return false;
    var sum = 0;
    var alt = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var n = int.parse(digits[i]);
      if (alt) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alt = !alt;
    }
    return sum % 10 == 0;
  }

  static String? Function(String?) cardNumber(AppLocalizations l) => (v) {
    if (v == null || v.trim().isEmpty) return l.fieldRequired;
    return luhn(v) ? null : l.invalidCardNumber;
  };

  /// MM/YY that is not in the past.
  static String? Function(String?) expiry(
    AppLocalizations l, {
    DateTime? now,
  }) => (v) {
    if (v == null || v.trim().isEmpty) return l.fieldRequired;
    final m = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(v.trim());
    if (m == null) return l.invalidExpiry;
    final month = int.parse(m.group(1)!);
    final year = 2000 + int.parse(m.group(2)!);
    if (month < 1 || month > 12) return l.invalidExpiry;
    final n = now ?? DateTime.now();
    final endOfMonth = DateTime(year, month + 1);
    return endOfMonth.isAfter(DateTime(n.year, n.month))
        ? null
        : l.invalidExpiry;
  };

  static String? Function(String?) cvc(AppLocalizations l) => (v) {
    if (v == null || v.isEmpty) return l.fieldRequired;
    return RegExp(r'^\d{3,4}$').hasMatch(v) ? null : l.invalidCvc;
  };
}
