import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light / dark / system theme, persisted locally.
class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  static const _key = 'theme_mode';
  final SharedPreferences? _prefs;

  ThemeMode _mode;

  ThemeController(this._prefs, {ThemeMode? initial})
    : _mode = initial ?? _read(_prefs) {
    WidgetsBinding.instance.addObserver(this);
    _syncColors();
  }

  static ThemeMode _read(SharedPreferences? p) {
    final name = p?.getString(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  ThemeMode get mode => _mode;

  bool get isDark => switch (_mode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark,
  };

  void _syncColors() => ColorManager.isDark = isDark;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    _syncColors();
    notifyListeners();
    await _prefs?.setString(_key, mode.name);
  }

  @override
  void didChangePlatformBrightness() {
    if (_mode == ThemeMode.system) {
      _syncColors();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
