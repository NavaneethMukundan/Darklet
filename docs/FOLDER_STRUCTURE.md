# Folder structure

```
lib/
  main.dart                  entry point: builds AppDependencies, runs MyApp
  l10n/                      app_en.arb, app_ar.arb (+ generated localizations)
  src/
    app.dart                 MaterialApp, theme + locale wiring
    app_dependencies.dart    chooses Mock or Firebase repositories
    config/config.dart       the one place for switches and settings
    models/                  plain data classes (Product, Order, Address ...)
    repositories/            abstract interfaces + payment_service
      mock/                  JSON assets + SharedPreferences implementations
      firebase/              Auth, Firestore, Storage implementations
    services/                Stripe payments, FCM push
    <feature>/               auth, home, category, products, search, reviews, cart,
                             checkout, address, orders, notifications, profile,
                             settings, onboarding, wishlist
      controller/            ChangeNotifier (one Provider per feature)
      view/                  screens
      widget/                feature-only widgets
    utils/
      constants/             routes, constants, spacing
      router/app_router.dart named routes + context.push helpers
      themes/                colours, typography, ThemeData
      widgets/               shared UI (buttons, cards, skeletons, states...)
      helpers/               formatting, validators, mappers
assets/mock/                 demo catalogue JSON
assets/fonts/                Poppins (Latin), Tajawal (Arabic)
firebase/                    Firestore + Storage rules, Cloud Functions
tools/                       seed script, ARB generator
test/                        unit/ and widget/ tests
```
Data flow: `View -> Controller (Provider) -> Repository interface -> Mock | Firebase`.
User-scoped controllers (cart, wishlist, addresses, orders, notifications) re-bind automatically when the signed-in user changes.
