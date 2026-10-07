import 'package:darklet/l10n/app_localizations_en.dart';
import 'package:darklet/src/utils/helpers/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l = AppLocalizationsEn();

  test('email', () {
    final v = Validators.email(l);
    expect(v(''), isNotNull);
    expect(v('nope'), l.invalidEmail);
    expect(v('a@b.co'), isNull);
  });

  test('password length', () {
    final v = Validators.password(l);
    expect(v('123'), isNotNull);
    expect(v('123456'), isNull);
  });

  test('luhn card numbers', () {
    expect(Validators.luhn('4242 4242 4242 4242'), isTrue);
    expect(Validators.luhn('4242 4242 4242 4243'), isFalse);
    expect(Validators.luhn('123'), isFalse);
  });

  test('expiry rejects past dates and bad formats', () {
    final v = Validators.expiry(l, now: DateTime(2026, 10, 6));
    expect(v('09/26'), isNotNull); // already over
    expect(v('10/26'), isNull); // current month is still valid
    expect(v('13/30'), isNotNull);
    expect(v('1230'), isNotNull);
    expect(v('12/30'), isNull);
  });

  test('cvc', () {
    final v = Validators.cvc(l);
    expect(v('12'), isNotNull);
    expect(v('123'), isNull);
    expect(v('1234'), isNull);
  });
}
