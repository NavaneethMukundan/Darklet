# Changelog

## 1.2.0
- App icon and native splash screen (generated from `assets/branding/`).
- Bigger demo catalogue: 28 products across 5 categories (new Wearables) and 140 reviews.
- Guest cart and wishlist are merged into the account on sign in.

## 1.1.0
- Order cancel (while placed / confirmed) and "Buy again".
- Wallet screen: list, add, delete and default card; saved-card selection at checkout.
- Promo codes (percent, fixed amount, free shipping) with discount in totals and orders.
- Guest browsing: cart and wishlist work without an account; sign-in prompt at checkout / reviews.
- Product variants (storage, colour, memory...) with price differences, separate cart lines.
- Search history and suggestions; offline banner.
- Security: orders created/cancelled by Cloud Functions that recompute prices, validate coupons and verify Stripe payments; Firestore rules deny client order writes.

## 1.0.0
- Complete architecture rewrite: repositories (Mock / Firebase), one Provider per feature,
  central theme, named routes, `AppConfig` switch.
- New screens: cart, checkout, address book, payment (success / failure), order success,
  order history, order details + tracking, search with filters & sorting, product reviews,
  edit profile, change password, notifications, settings.
- Light / dark / system themes and English + Arabic (RTL), both persisted.
- Firebase Auth (email, Google, password reset), Firestore, Storage, FCM; Stripe PaymentSheet.
- Shimmer loading, empty and error states, hero animations, pull-to-refresh, pagination,
  recently viewed, tablet layouts.
- Unit and widget tests.
- Removed all unlicensed artwork and personal data; bundled fonts (no runtime font download);
  bundle id changed to `com.darklet.app`.
