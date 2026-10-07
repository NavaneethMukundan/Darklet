# Firebase setup

1. Create a project at <https://console.firebase.google.com>.
2. Enable **Authentication** (Email/Password and Google), **Firestore**, **Storage**, **Cloud Messaging**.
3. Register the apps with the CLI (it replaces `google-services.json` / `GoogleService-Info.plist`):
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=<your-project-id> --android-package-name=<your.bundle.id> --ios-bundle-id=<your.bundle.id>
   ```
   Do **not** commit these files in the zip you distribute.
4. Google sign-in: add your SHA-1/SHA-256 in Firebase, and on iOS add the `REVERSED_CLIENT_ID` URL scheme (see the `google_sign_in` package docs).
5. Deploy the rules: `cd firebase && firebase deploy --only firestore:rules,storage`.
6. Seed demo data: see the header of `tools/seed/seed.js`.
7. Run: `flutter run --dart-define=USE_MOCK=false`.

## Cloud Functions are required for orders
Orders are created and cancelled **only** by the `placeOrder` / `cancelOrder` functions in `firebase/functions`
(`cd firebase && firebase deploy --only functions`). The functions recompute every price from Firestore
(including option price differences and promo codes), verify card payments with Stripe and update stock,
so a tampered app cannot change prices. Firestore rules deny all client writes to `orders`.
For development without Stripe set the env var `ALLOW_MOCK_PAYMENTS=true` on the functions (never in production).

Guests can browse: `products`, `categories` and `reviews` are publicly readable, and guest cart / wishlist stay on the device.

## Data model
`categories/{id}`, `products/{id}`, `reviews/{id}` (field `productId`), `users/{uid}` (+ `meta/addresses`, `meta/notifications`),
`carts/{uid}`, `wishlists/{uid}`, `coupons/{CODE}` (`type`: percent | amount | freeShipping, `value`, `minSubtotal`), `orders/{id}` (field `userId`). Products may have `options` (e.g. Storage / Color with `priceDelta`) - see `assets/mock/products.json`; `users/{uid}/meta/cards` stores card brand + last 4 only. Rules in `firebase/firestore.rules`:
users can read/write only their own cart, wishlist, addresses and orders.

## Push notifications (FCM)
The app shows foreground pushes in the notifications inbox. `firebase/functions/index.js` contains
`onOrderStatusChange`, which sends a push when an order's `status` changes. iOS also needs an APNs key
uploaded in Firebase and the Push Notifications capability in Xcode.

Change an order's status from the console or your back office: set `status` and append to `events`
(`{status, at}`) - the tracking timeline in the app updates.
