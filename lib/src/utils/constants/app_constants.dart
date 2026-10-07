/// Non-visual constants (limits, regexes, durations).
class AppConstants {
  AppConstants._();

  static final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static const minPasswordLength = 6;
  static const splashDuration = Duration(milliseconds: 1600);
  static const searchDebounce = Duration(milliseconds: 400);
  static const priceFilterMax = 2000.0;
}
