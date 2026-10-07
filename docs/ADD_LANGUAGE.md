# Adding a language (example: French)

1. Copy `lib/l10n/app_en.arb` to `lib/l10n/app_fr.arb`, set `"@@locale": "fr"` and translate the values.
2. Add `Locale('fr')` and its native name to `LocaleController.supported` / `names`
   (`lib/src/settings/controller/locale_controller.dart`).
3. For a right-to-left language also add its code to the RTL check (`isRtl`). The UI uses
   directional widgets (`EdgeInsetsDirectional`, `AlignmentDirectional`) so layouts mirror automatically.
4. For non-Latin scripts bundle a font that has the glyphs and pick it in `FontStyles.family`.
5. `flutter gen-l10n` (or just `flutter run`).
