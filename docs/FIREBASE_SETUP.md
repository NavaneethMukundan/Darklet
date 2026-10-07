# Firebase setup

1. Create a project at <https://console.firebase.google.com>.
2. Enable **Authentication** (Email/Password and Google), **Firestore**, **Storage**, **Cloud Messaging**.
3. Generate the Firebase config (it overwrites the placeholder `lib/firebase_options.dart`):
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=<your-project-id> --platforms=android,ios \
     --android-package-name=<your.bundle.id> --ios-bundle-id=<your.bundle.id> \
     --out=lib/firebase_options.dart
   ```
   If it also edits `android/` Gradle files or adds `google-services.json` / `GoogleService-Info.plist`, you can
   discard those - the app initialises Firebase from `firebase_options.dart`. Do not distribute your generated options file.
4. Google sign-in:
   - Android: add your debug **and** release SHA-1 / SHA-256 fingerprints to the Android app in Firebase
     (`keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`, or
     `firebase apps:android:sha:create <appId> <sha>`).
   - Copy the **Web client ID** (Authentication -> Sign-in method -> Google -> Web SDK configuration) into
     `googleServerClientId` in `lib/firebase_options.dart`.
   - iOS: put `REVERSED_CLIENT_ID` (from `GoogleService-Info.plist`) in the URL scheme in `ios/Runner/Info.plist`.
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
Signed-in users are subscribed to the topic `user_<uid>` silently. The permission prompt is *not* shown at launch: the app explains the benefit and asks right after the user's first order (`PushPermissionPrompt`). Android 13+ needs the `POST_NOTIFICATIONS` permission (already in the manifest).
The app shows foreground pushes in the notifications inbox. `firebase/functions/index.js` contains
`onOrderStatusChange`, which sends a push when an order's `status` changes. iOS also needs an APNs key
uploaded in Firebase and the Push Notifications capability in Xcode.

Change an order's status from the console or your back office: set `status` and append to `events`
(`{status, at}`) - the tracking timeline in the app updates.
