# Stripe setup

The app uses Stripe's PaymentSheet. Card data never touches your code or server.

1. Create a Stripe account, copy the **test** publishable key (`pk_test_...`).
2. Deploy the PaymentIntent function in `firebase/functions` (or any backend that returns `{ "clientSecret": "..." }`):
   ```bash
   firebase functions:secrets:set STRIPE_SECRET_KEY   # paste sk_test_..., never commit it
   firebase deploy --only functions
   ```
3. Run with:
   ```bash
   flutter run --dart-define=USE_MOCK=false \
     --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx \
     --dart-define=PAYMENT_BACKEND_URL=https://<region>-<project>.cloudfunctions.net/createPaymentIntent
   ```
4. Test with card `4242 4242 4242 4242`.

## Going live
Replace the keys with `pk_live_...` / `sk_live_...` **only in your CI / build command and Firebase secrets**.
Keys are never stored in the repository. Verify payments server-side (Stripe webhooks) before marking orders paid in production.
