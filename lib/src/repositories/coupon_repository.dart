import 'package:darklet/src/models/coupon.dart';

enum CouponError { notFound, minSubtotal }

class CouponException implements Exception {
  final CouponError error;
  final double? minSubtotal;
  const CouponException(this.error, [this.minSubtotal]);
}

/// Looks up promo codes. Throws [CouponException] when a code can't be used.
abstract class CouponRepository {
  Future<Coupon> validate(String code, double subtotal);
}

/// Shared rule check for the mock and Firestore implementations.
Coupon checkCoupon(Coupon? coupon, double subtotal) {
  if (coupon == null) throw const CouponException(CouponError.notFound);
  if (subtotal < coupon.minSubtotal) {
    throw CouponException(CouponError.minSubtotal, coupon.minSubtotal);
  }
  return coupon;
}
