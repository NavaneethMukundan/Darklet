import 'package:flutter/material.dart';

/// Single source of truth for colours. Rebrand by editing the values below.
///
/// Getters switch on [ColorManager.isDark], which `ThemeController` keeps in
/// sync with the active theme.
class ColorManager {
  static bool isDark = false;

  static const Color _brand = Color(0XFFBBE96D);

  Color get primaryColor => _brand;
  Color get primaryDarkColor =>
      isDark ? const Color(0XFF9BD93C) : const Color(0XFF6CAC00);
  Color get secondaryColor =>
      isDark ? const Color(0XFF2E3B14) : const Color(0xFFD6F3A2);

  /// Text/icon colour that sits on top of [primaryColor].
  Color get onPrimary => const Color(0xff1E1E1E);

  Color get background => isDark ? const Color(0XFF121315) : Colors.white;

  /// Cards, sheets, inputs.
  Color get kWhite => isDark ? const Color(0XFF1F2123) : Colors.white;
  Color get kWhiteSecondary =>
      isDark ? const Color(0XFF2A2C2F) : const Color(0XFFF1F1F1);

  /// Primary text colour (near-black in light, near-white in dark).
  Color get kBlack =>
      isDark ? const Color(0XFFF2F2F2) : const Color(0xff1E1E1E);
  Color get kBlackSecondary =>
      isDark ? const Color(0XFFC8C8C8) : const Color(0XFF555555);
  Color get kGrey => isDark ? const Color(0XFFA0A0A0) : const Color(0xFF606060);

  /// Borders and dividers.
  Color get kLightGrey =>
      isDark ? const Color(0XFF45484C) : const Color(0XFFC4C4C4);

  Color get kTransparent => Colors.transparent;
  Color get error => isDark ? const Color(0XFFEF5350) : const Color(0XFFD32F2F);
  Color get success =>
      isDark ? const Color(0XFF66BB6A) : const Color(0XFF2E7D32);
  Color get star => const Color(0XFFFFB300);
}

final ColorManager color = ColorManager();
