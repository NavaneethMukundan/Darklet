import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';

/// Typography. Poppins for Latin scripts, Tajawal for Arabic.
class FontStyles {
  /// Set by `LocaleController`.
  static bool isArabic = false;

  static String get family => isArabic ? 'Tajawal' : 'Poppins';

  TextStyle randomTextStylePoppins({
    double? size,
    FontWeight? weight,
    Color? color,
    bool? isItalic,
    bool? isUnderLined,
  }) {
    final c = color ?? ColorManager().kGrey;
    return TextStyle(
      fontFamily: family,
      fontSize: size ?? 15,
      fontWeight: weight ?? FontWeight.w500,
      color: c,
      fontStyle: isItalic == true ? FontStyle.italic : null,
      decoration: isUnderLined == true ? TextDecoration.underline : null,
      decorationColor: c,
    );
  }

  TextStyle randomTextStyle({double? size, FontWeight? weight, Color? color}) =>
      randomTextStylePoppins(size: size, weight: weight, color: color);
}

/// Short text-style helper: `ts(16, w: FontWeight.w600)`.
TextStyle ts(double size, {FontWeight w = FontWeight.w500, Color? c}) =>
    FontStyles().randomTextStylePoppins(
      size: size,
      weight: w,
      color: c ?? color.kBlack,
    );
