import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App language, persisted locally. Add a language by adding its code to
/// [supported] and an `app_<code>.arb` file (see docs/ADD_LANGUAGE.md).
class LocaleController extends ChangeNotifier {
  static const _key = 'locale';
  static const supported = [Locale('en'), Locale('ar')];

  /// Native names shown in the language picker.
  static const names = {'en': 'English', 'ar': 'العربية'};

  final SharedPreferences? _prefs;
  Locale _locale;

  LocaleController(this._prefs, {Locale? initial})
    : _locale = initial ?? _read(_prefs) {
    FontStyles.isArabic = _locale.languageCode == 'ar';
  }

  static Locale _read(SharedPreferences? p) {
    final code = p?.getString(_key);
    return supported.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => supported.first,
    );
  }

  Locale get locale => _locale;
  bool get isRtl => _locale.languageCode == 'ar';

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    FontStyles.isArabic = locale.languageCode == 'ar';
    notifyListeners();
    await _prefs?.setString(_key, locale.languageCode);
  }
}
