# Connect your own REST API

Screens never talk to a backend directly - they use the interfaces in `lib/src/repositories/`.

1. Implement `ProductRepository`, `AuthRepository`, `OrderRepository` and `UserDataRepository`
   (e.g. `RestProductRepository` using `package:http`). The models have `fromJson` / `toJson`
   that match the JSON in `assets/mock/` - a good starting contract for your API.
2. Add a factory in `lib/src/app_dependencies.dart`:
   ```dart
   factory AppDependencies.rest(SharedPreferences prefs) => AppDependencies(
     prefs: prefs,
     auth: RestAuthRepository(baseUrl),
     products: RestProductRepository(baseUrl),
     orders: RestOrderRepository(baseUrl),
     userData: RestUserDataRepository(baseUrl),
     payment: const MockPaymentService(),
   );
   ```
3. Return it from `AppDependencies.create()`.
Throw `AuthException` with an `AuthError` code so the UI shows localised messages.
