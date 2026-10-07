import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

/// Builds the Material [ThemeData] for the current [ColorManager.isDark].
class AppTheme {
  AppTheme._();

  static ThemeData build({required bool dark}) {
    final c = ColorManager();
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.primaryColor,
          brightness: dark ? Brightness.dark : Brightness.light,
        ).copyWith(
          primary: c.primaryDarkColor,
          onPrimary: dark ? c.onPrimary : Colors.white,
          surface: c.background,
          error: c.error,
        );
    OutlineInputBorder border(Color col) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: col, width: 1),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      fontFamily: FontStyles.family,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      dividerColor: c.kLightGrey.withValues(alpha: 0.4),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.kBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: ts(18, w: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.kWhite,
        hintStyle: ts(14, w: FontWeight.w400, c: c.kGrey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: border(c.kLightGrey),
        enabledBorder: border(c.kLightGrey),
        focusedBorder: border(c.primaryDarkColor),
        errorBorder: border(c.error),
        focusedErrorBorder: border(c.error),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? c.kWhiteSecondary : const Color(0xff1E1E1E),
        contentTextStyle: ts(14, c: Colors.white),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: c.kWhite),
      dialogTheme: DialogThemeData(backgroundColor: c.kWhite),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onPrimary : c.kGrey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? c.primaryColor : c.kLightGrey,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.primaryDarkColor,
      ),
    );
  }
}
