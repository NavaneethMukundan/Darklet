# Darklet - Flutter E-commerce App Template

A complete shopping app: browse, search & filter, wishlist, cart, checkout, payments,
orders with tracking, reviews, profile, notifications - in light **and** dark themes,
**English and Arabic (RTL)**. Runs fully offline in **Mock mode** out of the box; switch
one flag to use **Firebase** (Auth, Firestore, Storage, FCM) and **Stripe**.

## Features
- Onboarding, email/password + Google sign-in, forgot / change password
- Home (flash sale with countdown, categories, recently viewed), categories, product details with gallery
- Search with category / brand / price filters and sorting, infinite scroll, pull-to-refresh
- Wishlist, cart (stepper, swipe to remove + undo), product variants (storage / colour), promo codes, checkout (address, delivery option, payment)
- Address book, card payment with success / failure states, cash on delivery
- Order history, tracking timeline, cancel and buy again, reviews (read + write), wallet of saved cards
- Guest browsing, search history, offline banner
- Edit profile with avatar, notifications inbox, settings (theme + language)
- Skeleton loading, empty and error states everywhere; hero animations; haptics; tablet grid layouts

## Requirements
Flutter 3.41+ (Dart 3.11+), Android Studio / Xcode. Firebase and Stripe are optional.

## Quick start (Mock mode)
```bash
flutter pub get
flutter run
```
Promo codes to try: `DARK10`, `SAVE20` (orders over $100), `FREESHIP`.
Sign in with `demo@darklet.app` / `demo1234` (tap the hint on the login screen).
Test card for payments: `4242 4242 4242 4242`, any future date, any CVC.
`4000 0000 0000 0002` simulates a declined card.

## Switch to Firebase
`lib/src/config/config.dart` has the single switch (`useMock`). Follow
[docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md), then `flutter run --dart-define=USE_MOCK=false`.

## Documentation
| Guide | |
|---|---|
| [Setup](docs/SETUP.md) | install, run, build, tests |
| [Firebase](docs/FIREBASE_SETUP.md) | connect your own project, rules, seeding, push |
| [Stripe](docs/STRIPE_SETUP.md) | test and live keys |
| [Rebrand](docs/REBRAND.md) | name, bundle id, logo, colours, fonts |
| [Structure](docs/FOLDER_STRUCTURE.md) | how the code is organised |
| [Own REST API](docs/REST_API.md) | replace the repositories |
| [Add a language](docs/ADD_LANGUAGE.md) | |
| [FAQ](docs/FAQ.md) | |
| [Listing copy & packaging](docs/LISTING.md) | for selling the template |
| [Third-party licenses](docs/THIRD_PARTY_LICENSES.md) | |

See [CHANGELOG.md](CHANGELOG.md) and [LICENSE](LICENSE).
