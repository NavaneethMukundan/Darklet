// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Darklet';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get remove => 'إزالة';

  @override
  String get undo => 'تراجع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get all => 'الكل';

  @override
  String get or => 'أو';

  @override
  String get free => 'مجاني';

  @override
  String get change => 'تغيير';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get viewCart => 'عرض السلة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get tryAgainMessage => 'يرجى التحقق من الاتصال والمحاولة مرة أخرى.';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String passwordTooShort(int n) {
    return 'يجب ألا تقل كلمة المرور عن $n أحرف';
  }

  @override
  String get passwordsDontMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get onboardTitle1 => 'ابدأ بإنشاء\nحساب';

  @override
  String get onboardBody1 => 'اكتشف طريقة أذكى للتسوق.\nسجّل الدخول للبدء.';

  @override
  String get onboardTitle2 => 'اعثر على ما\nتبحث عنه';

  @override
  String get onboardBody2 =>
      'تصفح الهواتف وأجهزة الألعاب والحواسيب والصوتيات.\nصفّ وافرز في ثوانٍ.';

  @override
  String get onboardTitle3 => 'كل شيء جاهز!';

  @override
  String get onboardBody3 =>
      'تم تقديم طلبك وهو في الطريق.\nاسترح، ونحن نتولى الباقي.';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get enterDetails => 'أدخل بياناتك أدناه';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get continueWithGoogle => 'المتابعة عبر Google';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم إلى Darklet في ثوانٍ';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'سنرسل إليك رابطًا لإعادة تعيين كلمة المرور';

  @override
  String get sendResetLink => 'إرسال رابط الاستعادة';

  @override
  String get resetLinkSent =>
      'إذا كان الحساب موجودًا فسيصلك رابط الاستعادة قريبًا.';

  @override
  String demoHint(String email, String password) {
    return 'حساب تجريبي: $email / $password\nاضغط للتعبئة';
  }

  @override
  String get errInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get errEmailInUse => 'يوجد حساب بهذا البريد الإلكتروني بالفعل';

  @override
  String get errWeakPassword => 'كلمة المرور ضعيفة جدًا';

  @override
  String get errUserNotFound => 'لم يتم العثور على حساب';

  @override
  String get errRequiresRecentLogin => 'يرجى تسجيل الدخول مرة أخرى للمتابعة';

  @override
  String get errCancelled => 'تم إلغاء تسجيل الدخول';

  @override
  String get errNetwork => 'خطأ في الشبكة. تحقق من اتصالك.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCategories => 'الفئات';

  @override
  String get navWishlist => 'المفضلة';

  @override
  String get navProfile => 'حسابي';

  @override
  String hello(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get welcomeTo => 'مرحبًا بك في';

  @override
  String get searchProducts => 'ابحث عن المنتجات...';

  @override
  String get promoTitle => 'خصم يصل إلى 30%';

  @override
  String get promoSubtitle => 'تخفيضات على الهواتف والحواسيب والصوتيات';

  @override
  String get categories => 'الفئات';

  @override
  String get flashSales => 'عروض سريعة';

  @override
  String get recentlyViewed => 'شوهدت مؤخرًا';

  @override
  String get categoryTitleA => '';

  @override
  String get categoryTitleB => 'الفئات';

  @override
  String get catPhones => 'الهواتف';

  @override
  String get catConsoles => 'أجهزة الألعاب';

  @override
  String get catLaptops => 'الحواسيب';

  @override
  String get catAudio => 'الصوتيات';

  @override
  String get catWearables => 'الأجهزة القابلة للارتداء';

  @override
  String categorySection(String name) {
    return 'قسم $name';
  }

  @override
  String sectionTitle(String name) {
    return 'قسم $name';
  }

  @override
  String get wishlistTitleA => '';

  @override
  String get wishlistTitleB => 'المفضلة';

  @override
  String get searchWishlist => 'ابحث في المفضلة';

  @override
  String get wishlistEmptyTitle => 'قائمة المفضلة فارغة';

  @override
  String get wishlistEmptyMessage => 'اضغط على القلب في أي منتج لحفظه هنا.';

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get addToWishlist => 'أضف إلى المفضلة';

  @override
  String get removeFromWishlist => 'أزل من المفضلة';

  @override
  String get filters => 'التصفية';

  @override
  String get category => 'الفئة';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortRelevance => 'الأكثر صلة';

  @override
  String get sortPriceLow => 'السعر: من الأقل للأعلى';

  @override
  String get sortPriceHigh => 'السعر: من الأعلى للأقل';

  @override
  String get sortTopRated => 'الأعلى تقييمًا';

  @override
  String get applyFilters => 'تطبيق التصفية';

  @override
  String get noProductsTitle => 'لا توجد منتجات';

  @override
  String get noProductsMessage => 'جرّب تغيير البحث أو التصفية.';

  @override
  String resultsCount(int count, String more) {
    return '$count نتيجة$more';
  }

  @override
  String get details => 'التفاصيل';

  @override
  String get description => 'الوصف';

  @override
  String get specifications => 'المواصفات';

  @override
  String get inStock => 'متوفر';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String onlyLeft(int count) {
    return 'متبقي $count فقط';
  }

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get addedToCart => 'تمت الإضافة إلى السلة';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مراجعة',
      many: '$count مراجعة',
      few: '$count مراجعات',
      two: 'مراجعتان',
      one: 'مراجعة واحدة',
      zero: 'لا مراجعات',
    );
    return '$_temp0';
  }

  @override
  String seeReviews(int count) {
    return 'عرض كل المراجعات ($count)';
  }

  @override
  String get reviews => 'المراجعات';

  @override
  String get writeReview => 'اكتب مراجعة';

  @override
  String get noReviewsTitle => 'لا توجد مراجعات بعد';

  @override
  String get noReviewsMessage => 'كن أول من يشارك رأيه.';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get yourReview => 'مراجعتك';

  @override
  String get reviewHint => 'ما الذي أعجبك أو لم يعجبك؟';

  @override
  String get ratingRequired => 'يرجى اختيار تقييم';

  @override
  String get submitReview => 'إرسال المراجعة';

  @override
  String get reviewThanks => 'شكرًا على مراجعتك!';

  @override
  String starsCount(int n) {
    return '$n نجوم';
  }

  @override
  String get cartTitle => 'سلتي';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptyMessage => 'يبدو أنك لم تضف أي شيء بعد.';

  @override
  String get itemRemoved => 'تمت إزالة المنتج';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا عناصر',
    );
    return '$_temp0';
  }

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shippingAtCheckout => 'يتم احتساب الشحن عند إتمام الشراء';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get items => 'المنتجات';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get deliveryOption => 'خيار التوصيل';

  @override
  String get deliveryStandard => 'توصيل عادي';

  @override
  String get deliveryExpress => 'توصيل سريع';

  @override
  String get deliveryPickup => 'الاستلام من المتجر';

  @override
  String etaDays(int min, int max) {
    return '$min-$max أيام عمل';
  }

  @override
  String get etaPickup => 'جاهز خلال 24 ساعة';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get payCard => 'بطاقة ائتمان / خصم';

  @override
  String get payCardSubtitle => 'فيزا وماستركارد وغيرها';

  @override
  String get payCardSecure => 'ادفع بأمان عبر Stripe';

  @override
  String get payCod => 'الدفع عند الاستلام';

  @override
  String get payCodSubtitle => 'ادفع عند وصول طلبك';

  @override
  String get addCard => 'إضافة بطاقة';

  @override
  String get addNewCard => 'إضافة بطاقة جديدة';

  @override
  String get saveCard => 'حفظ البطاقة';

  @override
  String get changeCard => 'استخدام بطاقة أخرى';

  @override
  String get cvcConfirm => 'رمز الأمان (CVC)';

  @override
  String get noCardsTitle => 'لا توجد بطاقات محفوظة';

  @override
  String get noCardsMessage =>
      'أضف بطاقة للدفع بها. يمكنك إضافة بطاقات أخرى في أي وقت.';

  @override
  String get addCardFirst => 'يرجى إضافة بطاقة للمتابعة';

  @override
  String expiresOn(String date) {
    return 'تنتهي في $date';
  }

  @override
  String get cardSaveNote =>
      'نحتفظ بآخر 4 أرقام فقط. لا يتم حفظ رمز CVC أبدًا.';

  @override
  String get guest => 'زائر';

  @override
  String get continueAsGuest => 'المتابعة كزائر';

  @override
  String get signInRequiredTitle => 'سجّل الدخول للمتابعة';

  @override
  String get signInRequiredMessage =>
      'أنشئ حسابًا مجانيًا أو سجّل الدخول لإتمام الشراء وتقييم المنتجات وتتبع الطلبات. سلتك محفوظة.';

  @override
  String get guestProfileMessage =>
      'سجّل الدخول لإدارة الطلبات والعناوين والبطاقات';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get keepOrder => 'الاحتفاظ بالطلب';

  @override
  String get cancelOrderConfirm =>
      'هل أنت متأكد من إلغاء هذا الطلب؟ لا يمكن التراجع عن ذلك.';

  @override
  String get orderCancelled => 'تم إلغاء الطلب';

  @override
  String get cancelFailed => 'لا يمكن إلغاء هذا الطلب بعد الآن';

  @override
  String get buyAgain => 'اشترِ مرة أخرى';

  @override
  String itemsAddedToCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إضافة $count عنصر إلى سلتك',
      many: 'تمت إضافة $count عنصرًا إلى سلتك',
      few: 'تمت إضافة $count عناصر إلى سلتك',
      two: 'تمت إضافة عنصرين إلى سلتك',
      one: 'تمت إضافة عنصر واحد إلى سلتك',
    );
    return '$_temp0';
  }

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get deleteCard => 'حذف البطاقة';

  @override
  String deleteCardConfirm(String last4) {
    return 'هل تريد إزالة البطاقة التي تنتهي بـ $last4؟';
  }

  @override
  String get cardsEmptyMessage => 'أضف بطاقة لتدفع بشكل أسرع عند إتمام الشراء.';

  @override
  String get promoCode => 'رمز الخصم';

  @override
  String get enterPromoCode => 'أدخل رمز الخصم';

  @override
  String get apply => 'تطبيق';

  @override
  String get discount => 'الخصم';

  @override
  String couponApplied(String code) {
    return 'تم تطبيق $code';
  }

  @override
  String get couponNotFound => 'هذا الرمز غير صالح';

  @override
  String couponMinSubtotal(String amount) {
    return 'أنفق $amount على الأقل لاستخدام هذا الرمز';
  }

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get popularSearches => 'عمليات بحث شائعة';

  @override
  String get offlineBanner => 'لا يوجد اتصال بالإنترنت';

  @override
  String get backOnline => 'عاد الاتصال';

  @override
  String get pushAskTitle => 'هل تريد تلقي تحديثات الطلب؟';

  @override
  String get pushAskMessage => 'سنخبرك عند تأكيد طلبك وشحنه وتسليمه.';

  @override
  String get enableNotifications => 'تفعيل الإشعارات';

  @override
  String get view => 'عرض';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get delivery => 'التوصيل';

  @override
  String get total => 'الإجمالي';

  @override
  String get placeOrder => 'تأكيد الطلب';

  @override
  String get continueToPayment => 'المتابعة للدفع';

  @override
  String get selectAddressFirst => 'يرجى إضافة عنوان توصيل أولًا';

  @override
  String get payment => 'الدفع';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get cardHolder => 'الاسم على البطاقة';

  @override
  String get expiry => 'تاريخ الانتهاء';

  @override
  String get invalidCardNumber => 'أدخل رقم بطاقة صالحًا';

  @override
  String get invalidExpiry => 'أدخل تاريخ انتهاء صالحًا (شهر/سنة)';

  @override
  String get invalidCvc => 'رمز CVC غير صالح';

  @override
  String payAmount(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get processingPayment => 'جارٍ معالجة الدفع...';

  @override
  String get paymentFailedTitle => 'فشلت عملية الدفع';

  @override
  String get paymentDeclined => 'تم رفض بطاقتك. يرجى تجربة بطاقة أخرى.';

  @override
  String get paymentFailedGeneric => 'تعذرت معالجة الدفع. لم يتم خصم أي مبلغ.';

  @override
  String get changePaymentMethod => 'تغيير طريقة الدفع';

  @override
  String get testCardHint =>
      'وضع الاختبار: استخدم 4242 4242 4242 4242. البطاقة 4000 0000 0000 0002 يتم رفضها.';

  @override
  String get stripeSheetHint => 'ستُدخل بيانات بطاقتك في نافذة Stripe الآمنة.';

  @override
  String get orderPlacedTitle => 'تم تأكيد الطلب!';

  @override
  String get orderPlacedMessage =>
      'شكرًا على طلبك. سنخبرك عند كل تحديث لحالة الطلب.';

  @override
  String orderNumber(String id) {
    return 'الطلب $id';
  }

  @override
  String get trackOrder => 'تتبع الطلب';

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get notifOrderPlacedTitle => 'تم تأكيد الطلب';

  @override
  String notifOrderPlacedBody(String id) {
    return 'تم تأكيد طلبك $id بنجاح.';
  }

  @override
  String get myOrders => 'طلباتي';

  @override
  String get ordersEmptyTitle => 'لا توجد طلبات بعد';

  @override
  String get ordersEmptyMessage => 'ستظهر طلباتك هنا بعد تقديمها.';

  @override
  String get orderNotFound => 'الطلب غير موجود';

  @override
  String get orderTracking => 'تتبع الطلب';

  @override
  String get orderCancelledMessage => 'تم إلغاء هذا الطلب.';

  @override
  String get statusPlaced => 'تم تقديم الطلب';

  @override
  String get statusConfirmed => 'تم التأكيد';

  @override
  String get statusShipped => 'تم الشحن';

  @override
  String get statusOutForDelivery => 'في الطريق إليك';

  @override
  String get statusDelivered => 'تم التسليم';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get myAddresses => 'عناويني';

  @override
  String get selectAddress => 'اختر العنوان';

  @override
  String get addAddress => 'إضافة عنوان';

  @override
  String get editAddress => 'تعديل العنوان';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get deleteAddress => 'حذف العنوان';

  @override
  String get deleteAddressConfirm => 'سيتم حذف هذا العنوان من دفتر العناوين.';

  @override
  String get addressesEmptyTitle => 'لا توجد عناوين محفوظة';

  @override
  String get addressesEmptyMessage => 'أضف عنوانًا لتسريع إتمام الشراء.';

  @override
  String get addressLabel => 'التسمية';

  @override
  String get addressLabelHint => 'المنزل، العمل...';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get streetAddress => 'عنوان الشارع';

  @override
  String get city => 'المدينة';

  @override
  String get stateRegion => 'الولاية / المنطقة';

  @override
  String get zipCode => 'الرمز البريدي';

  @override
  String get country => 'الدولة';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get defaultLabel => 'افتراضي';

  @override
  String get addressPrivacy => 'يُستخدم عنوانك فقط لتوصيل طلباتك.';

  @override
  String get account => 'الحساب';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get updatePassword => 'تحديث كلمة المرور';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تعليم الكل كمقروء';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsEmptyMessage => 'ستظهر هنا تحديثات الطلبات والعروض.';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get demoMode => 'الوضع التجريبي';

  @override
  String get liveMode => 'الوضع المباشر';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get logOutConfirm => 'هل أنت متأكد من تسجيل الخروج؟';
}
