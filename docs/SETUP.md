# Setup

```bash
flutter pub get
flutter gen-l10n        # only after editing lib/l10n/*.arb (flutter run does it automatically)
flutter run             # Mock mode, no accounts needed
flutter test            # unit + widget tests
flutter analyze
flutter build apk --release
```

Mock mode stores everything (accounts, cart, wishlist, orders, reviews) in SharedPreferences,
so data survives restarts. Clear the app's storage to reset the demo.

Build-time options (`--dart-define=NAME=value`):

| Name | Default | Meaning |
|---|---|---|
| `USE_MOCK` | `true` | `false` = Firebase backend |
| `STRIPE_PUBLISHABLE_KEY` | empty | enables Stripe (with the URL below) |
| `PAYMENT_BACKEND_URL` | empty | endpoint returning `{clientSecret}` |

Without Stripe keys, card payments use the mock gateway even in Firebase mode.

Platform notes: Android needs JDK 17; iOS 15+ (Stripe). The Android Gradle setup
(AGP 8.9, Kotlin 2.3, AppCompat) is already configured for Firebase + Stripe.
