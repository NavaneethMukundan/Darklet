import 'dart:convert';

import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/coupon.dart';
import 'package:darklet/src/repositories/coupon_repository.dart';
import 'package:flutter/services.dart';

/// Coupons from `assets/mock/coupons.json`.
class MockCouponRepository implements CouponRepository {
  final AssetBundle bundle;
  final Duration latency;
  MockCouponRepository({AssetBundle? bundle, Duration? latency})
    : bundle = bundle ?? rootBundle,
      latency = latency ?? AppConfig.mockLatency;

  @override
  Future<Coupon> validate(String code, double subtotal) async {
    await Future<void>.delayed(latency);
    final list =
        jsonDecode(await bundle.loadString('assets/mock/coupons.json')) as List;
    final wanted = code.trim().toUpperCase();
    final match = list
        .map((e) => Coupon.fromJson(Map<String, dynamic>.from(e)))
        .where((c) => c.code == wanted)
        .firstOrNull;
    return checkCoupon(match, subtotal);
  }
}
