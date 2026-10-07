# Rebrand

| What | Where |
|---|---|
| App name (in-app) | `AppConfig.appName` in `lib/src/config/config.dart`, plus the home header text in `lib/src/home/view/home.dart` |
| Display name | Android: `android:label` in `AndroidManifest.xml` · iOS: `CFBundleDisplayName` in `ios/Runner/Info.plist` |
| Bundle / application id | see below |
| Colours | `lib/src/utils/themes/colors/colors.dart` (light + dark values in one place) |
| Fonts | files in `assets/fonts/`, families in `pubspec.yaml`, switched in `lib/src/utils/themes/styles/font_style.dart` |
| Currency | `AppConfig.currencySymbol` |
| Logo / launcher icon / splash | replace the PNGs in `assets/branding/` (`app_icon.png` 1024px, `app_icon_foreground.png` for Android adaptive icons, `splash_logo.png`), then run `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`. In-app splash wordmark: `splash_screen.dart` |
| Onboarding / promo text | `lib/l10n/app_*.arb` |

## Changing the bundle id (default `com.darklet.app`)
```bash
OLD=com.darklet.app; NEW=com.yourcompany.shop
grep -rIl "$OLD" android ios macos linux | grep -v build/ | xargs sed -i '' "s/$OLD/$NEW/g"   # use sed -i on Linux
mkdir -p android/app/src/main/kotlin/com/yourcompany/shop
git mv android/app/src/main/kotlin/com/darklet/app/MainActivity.kt android/app/src/main/kotlin/com/yourcompany/shop/
```
Then re-run `flutterfire configure` with the new id if you use Firebase.
