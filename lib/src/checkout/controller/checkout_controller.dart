import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/address.dart';
import 'package:darklet/src/models/coupon.dart';
import 'package:darklet/src/models/order.dart';
import 'package:darklet/src/repositories/coupon_repository.dart';
import 'package:flutter/foundation.dart';

/// Holds the choices made during checkout and computes totals.
class CheckoutController extends ChangeNotifier {
  final CouponRepository? _coupons;
  CheckoutController([this._coupons]);

  Coupon? coupon;
  bool couponBusy = false;
  Address? address;
  DeliveryOption delivery = DeliveryOption.standard;
  PaymentMethod paymentMethod = PaymentMethod.card;
  String? cardId;

  /// Delivery cost for a given [subtotal] (Standard ships free over the
  /// threshold in `AppConfig`).
  double deliveryFee(double subtotal) {
    if (coupon?.isFreeShipping ?? false) return 0;
    if (delivery.id == DeliveryOption.standard.id &&
        subtotal >= AppConfig.freeShippingThreshold) {
      return 0;
    }
    return delivery.price;
  }

  /// Amount taken off [subtotal] by the applied coupon.
  double discount(double subtotal) => coupon?.discountFor(subtotal) ?? 0;

  double total(double subtotal) =>
      subtotal - discount(subtotal) + deliveryFee(subtotal);

  /// Validates and applies [code]. Returns `null` on success.
  Future<CouponException?> applyCoupon(String code, double subtotal) async {
    final repo = _coupons;
    if (repo == null) return const CouponException(CouponError.notFound);
    couponBusy = true;
    notifyListeners();
    try {
      coupon = await repo.validate(code, subtotal);
      return null;
    } on CouponException catch (e) {
      return e;
    } catch (_) {
      return const CouponException(CouponError.notFound);
    } finally {
      couponBusy = false;
      notifyListeners();
    }
  }

  void removeCoupon() {
    coupon = null;
    notifyListeners();
  }

  void selectAddress(Address a) {
    address = a;
    notifyListeners();
  }

  void selectDelivery(DeliveryOption o) {
    delivery = o;
    notifyListeners();
  }

  void selectPayment(PaymentMethod m) {
    paymentMethod = m;
    notifyListeners();
  }

  void selectCard(String? id) {
    cardId = id;
    notifyListeners();
  }

  void reset() {
    coupon = null;
    cardId = null;
    address = null;
    delivery = DeliveryOption.standard;
    paymentMethod = PaymentMethod.card;
    notifyListeners();
  }
}
