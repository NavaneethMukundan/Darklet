import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darklet/src/models/coupon.dart';
import 'package:darklet/src/repositories/coupon_repository.dart';

/// Coupons live in `coupons/{CODE}` (readable by signed-in users). The server
/// re-validates the code when the order is placed (see firebase/functions).
class FirebaseCouponRepository implements CouponRepository {
  final FirebaseFirestore _db;
  FirebaseCouponRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<Coupon> validate(String code, double subtotal) async {
    final id = code.trim().toUpperCase();
    final doc = await _db.collection('coupons').doc(id).get();
    final c = doc.exists ? Coupon.fromJson({...doc.data()!, 'code': id}) : null;
    return checkCoupon(c, subtotal);
  }
}
