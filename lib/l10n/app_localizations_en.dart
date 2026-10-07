// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Darklet';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get remove => 'Remove';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';

  @override
  String get tryAgain => 'Try again';

  @override
  String get reset => 'Reset';

  @override
  String get all => 'All';

  @override
  String get or => 'or';

  @override
  String get free => 'Free';

  @override
  String get change => 'Change';

  @override
  String get viewAll => 'View all';

  @override
  String get viewCart => 'View cart';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgainMessage => 'Please check your connection and try again.';

  @override
  String get noResults => 'No results found';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String passwordTooShort(int n) {
    return 'Password must be at least $n characters';
  }

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get onboardTitle1 => 'Start by creating\nan account';

  @override
  String get onboardBody1 =>
      'Discover a smarter way to shop.\nSign in to get started.';

  @override
  String get onboardTitle2 => 'Find what you\nare looking for';

  @override
  String get onboardBody2 =>
      'Browse phones, consoles, laptops and audio.\nFilter and sort in seconds.';

  @override
  String get onboardTitle3 => 'You\'re all set!';

  @override
  String get onboardBody3 =>
      'Your order is placed and on its way.\nSit back, relax - we\'ll handle the rest.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get enterDetails => 'Enter your details below';

  @override
  String get email => 'Email address';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle => 'Join Darklet in a few seconds';

  @override
  String get fullName => 'Full name';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'We\'ll email you a link to reset your password';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get resetLinkSent =>
      'If the account exists, a reset link is on its way.';

  @override
  String demoHint(String email, String password) {
    return 'Demo account: $email / $password\nTap to fill';
  }

  @override
  String get errInvalidCredentials => 'Incorrect email or password';

  @override
  String get errEmailInUse => 'An account with this email already exists';

  @override
  String get errWeakPassword => 'That password is too weak';

  @override
  String get errUserNotFound => 'No account found';

  @override
  String get errRequiresRecentLogin => 'Please sign in again to continue';

  @override
  String get errCancelled => 'Sign-in was cancelled';

  @override
  String get errNetwork => 'Network error. Check your connection.';

  @override
  String get navHome => 'Home';

  @override
  String get navCategories => 'Categories';

  @override
  String get navWishlist => 'Wishlist';

  @override
  String get navProfile => 'Profile';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get promoTitle => 'Up to 30% off';

  @override
  String get promoSubtitle => 'Flash sale on phones, laptops and audio';

  @override
  String get categories => 'Categories';

  @override
  String get flashSales => 'Flash sales';

  @override
  String get recentlyViewed => 'Recently viewed';

  @override
  String get categoryTitleA => 'Cate';

  @override
  String get categoryTitleB => 'gory';

  @override
  String get catPhones => 'Phones';

  @override
  String get catConsoles => 'Consoles';

  @override
  String get catLaptops => 'Laptops';

  @override
  String get catAudio => 'Audio';

  @override
  String get catWearables => 'Wearables';

  @override
  String categorySection(String name) {
    return '$name section';
  }

  @override
  String sectionTitle(String name) {
    return '$name section';
  }

  @override
  String get wishlistTitleA => 'Wish';

  @override
  String get wishlistTitleB => 'list';

  @override
  String get searchWishlist => 'Search your wishlist';

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptyMessage =>
      'Tap the heart on any product to save it here.';

  @override
  String get startShopping => 'Start shopping';

  @override
  String get addToWishlist => 'Add to wishlist';

  @override
  String get removeFromWishlist => 'Remove from wishlist';

  @override
  String get filters => 'Filters';

  @override
  String get category => 'Category';

  @override
  String get brand => 'Brand';

  @override
  String get priceRange => 'Price range';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortPriceLow => 'Price: low to high';

  @override
  String get sortPriceHigh => 'Price: high to low';

  @override
  String get sortTopRated => 'Top rated';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get noProductsTitle => 'No products found';

  @override
  String get noProductsMessage => 'Try changing your search or filters.';

  @override
  String resultsCount(int count, String more) {
    return '$count results$more';
  }

  @override
  String get details => 'Details';

  @override
  String get description => 'Description';

  @override
  String get specifications => 'Specifications';

  @override
  String get inStock => 'In stock';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String onlyLeft(int count) {
    return 'Only $count left';
  }

  @override
  String get addToCart => 'Add to cart';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews',
    );
    return '$_temp0';
  }

  @override
  String seeReviews(int count) {
    return 'See all reviews ($count)';
  }

  @override
  String get reviews => 'Reviews';

  @override
  String get writeReview => 'Write a review';

  @override
  String get noReviewsTitle => 'No reviews yet';

  @override
  String get noReviewsMessage => 'Be the first to share your thoughts.';

  @override
  String get yourRating => 'Your rating';

  @override
  String get yourReview => 'Your review';

  @override
  String get reviewHint => 'What did you like or dislike?';

  @override
  String get ratingRequired => 'Please select a rating';

  @override
  String get submitReview => 'Submit review';

  @override
  String get reviewThanks => 'Thanks for your review!';

  @override
  String starsCount(int n) {
    return '$n stars';
  }

  @override
  String get cartTitle => 'My cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyMessage => 'Looks like you haven\'t added anything yet.';

  @override
  String get itemRemoved => 'Item removed';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shippingAtCheckout => 'Shipping is calculated at checkout';

  @override
  String get checkout => 'Checkout';

  @override
  String get items => 'Items';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get deliveryOption => 'Delivery option';

  @override
  String get deliveryStandard => 'Standard delivery';

  @override
  String get deliveryExpress => 'Express delivery';

  @override
  String get deliveryPickup => 'Store pickup';

  @override
  String etaDays(int min, int max) {
    return '$min-$max business days';
  }

  @override
  String get etaPickup => 'Ready within 24 hours';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get payCard => 'Credit / debit card';

  @override
  String get payCardSubtitle => 'Visa, Mastercard and more';

  @override
  String get payCardSecure => 'Pay securely with Stripe';

  @override
  String get payCod => 'Cash on delivery';

  @override
  String get payCodSubtitle => 'Pay when your order arrives';

  @override
  String get addCard => 'Add card';

  @override
  String get addNewCard => 'Add new card';

  @override
  String get saveCard => 'Save card';

  @override
  String get changeCard => 'Use another card';

  @override
  String get cvcConfirm => 'Security code (CVC)';

  @override
  String get noCardsTitle => 'No saved cards';

  @override
  String get noCardsMessage =>
      'Add a card to pay with. You can add more cards any time.';

  @override
  String get addCardFirst => 'Please add a card to continue';

  @override
  String expiresOn(String date) {
    return 'Expires $date';
  }

  @override
  String get cardSaveNote =>
      'We only keep the last 4 digits. Your CVC is never stored.';

  @override
  String get guest => 'Guest';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get signInRequiredTitle => 'Sign in to continue';

  @override
  String get signInRequiredMessage =>
      'Create a free account or sign in to checkout, review products and track orders. Your cart is kept.';

  @override
  String get guestProfileMessage =>
      'Sign in to manage orders, addresses and cards';

  @override
  String get notNow => 'Not now';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get keepOrder => 'Keep order';

  @override
  String get cancelOrderConfirm =>
      'Are you sure you want to cancel this order? This can\'t be undone.';

  @override
  String get orderCancelled => 'Order cancelled';

  @override
  String get cancelFailed => 'This order can\'t be cancelled any more';

  @override
  String get buyAgain => 'Buy again';

  @override
  String itemsAddedToCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items added to your cart',
      one: '1 item added to your cart',
    );
    return '$_temp0';
  }

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get deleteCard => 'Delete card';

  @override
  String deleteCardConfirm(String last4) {
    return 'Remove the card ending in $last4?';
  }

  @override
  String get cardsEmptyMessage => 'Add a card to pay faster at checkout.';

  @override
  String get promoCode => 'Promo code';

  @override
  String get enterPromoCode => 'Enter promo code';

  @override
  String get apply => 'Apply';

  @override
  String get discount => 'Discount';

  @override
  String couponApplied(String code) {
    return '$code applied';
  }

  @override
  String get couponNotFound => 'This code isn\'t valid';

  @override
  String couponMinSubtotal(String amount) {
    return 'Spend at least $amount to use this code';
  }

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get popularSearches => 'Popular searches';

  @override
  String get offlineBanner => 'No internet connection';

  @override
  String get backOnline => 'Back online';

  @override
  String get pushAskTitle => 'Get order updates?';

  @override
  String get pushAskMessage =>
      'We\'ll notify you when your order is confirmed, shipped and delivered.';

  @override
  String get enableNotifications => 'Turn on notifications';

  @override
  String get orderSummary => 'Order summary';

  @override
  String get delivery => 'Delivery';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Place order';

  @override
  String get continueToPayment => 'Continue to payment';

  @override
  String get selectAddressFirst => 'Please add a delivery address first';

  @override
  String get payment => 'Payment';

  @override
  String get cardNumber => 'Card number';

  @override
  String get cardHolder => 'Name on card';

  @override
  String get expiry => 'Expiry date';

  @override
  String get invalidCardNumber => 'Enter a valid card number';

  @override
  String get invalidExpiry => 'Enter a valid expiry (MM/YY)';

  @override
  String get invalidCvc => 'Invalid CVC';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get processingPayment => 'Processing your payment...';

  @override
  String get paymentFailedTitle => 'Payment failed';

  @override
  String get paymentDeclined =>
      'Your card was declined. Please try another card.';

  @override
  String get paymentFailedGeneric =>
      'We couldn\'t process your payment. You were not charged.';

  @override
  String get changePaymentMethod => 'Change payment method';

  @override
  String get testCardHint =>
      'Test mode: use 4242 4242 4242 4242. Card 4000 0000 0000 0002 is declined.';

  @override
  String get stripeSheetHint =>
      'You\'ll enter your card details in a secure Stripe sheet.';

  @override
  String get orderPlacedTitle => 'Order placed!';

  @override
  String get orderPlacedMessage =>
      'Thank you for your purchase. We\'ll notify you as your order progresses.';

  @override
  String orderNumber(String id) {
    return 'Order $id';
  }

  @override
  String get trackOrder => 'Track order';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get notifOrderPlacedTitle => 'Order placed';

  @override
  String notifOrderPlacedBody(String id) {
    return 'Your order $id was placed successfully.';
  }

  @override
  String get myOrders => 'My orders';

  @override
  String get ordersEmptyTitle => 'No orders yet';

  @override
  String get ordersEmptyMessage =>
      'When you place an order it will show up here.';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get orderTracking => 'Order tracking';

  @override
  String get orderCancelledMessage => 'This order was cancelled.';

  @override
  String get statusPlaced => 'Order placed';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusOutForDelivery => 'Out for delivery';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get myAddresses => 'My addresses';

  @override
  String get selectAddress => 'Select address';

  @override
  String get addAddress => 'Add address';

  @override
  String get editAddress => 'Edit address';

  @override
  String get saveAddress => 'Save address';

  @override
  String get deleteAddress => 'Delete address';

  @override
  String get deleteAddressConfirm =>
      'This address will be removed from your address book.';

  @override
  String get addressesEmptyTitle => 'No saved addresses';

  @override
  String get addressesEmptyMessage => 'Add an address to speed up checkout.';

  @override
  String get addressLabel => 'Label';

  @override
  String get addressLabelHint => 'Home, Work...';

  @override
  String get phone => 'Phone number';

  @override
  String get streetAddress => 'Street address';

  @override
  String get city => 'City';

  @override
  String get stateRegion => 'State / Region';

  @override
  String get zipCode => 'ZIP / Postal code';

  @override
  String get country => 'Country';

  @override
  String get setAsDefault => 'Set as default';

  @override
  String get defaultLabel => 'Default';

  @override
  String get addressPrivacy =>
      'Your address is only used to deliver your orders.';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get updatePassword => 'Update password';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyMessage =>
      'Order updates and offers will appear here.';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get liveMode => 'Live mode';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutConfirm => 'Are you sure you want to log out?';
}
