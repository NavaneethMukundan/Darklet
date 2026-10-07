import 'package:flutter/material.dart';

const kHeight5 = SizedBox(height: 5);
const kHeight10 = SizedBox(height: 10);
const kHeight15 = SizedBox(height: 15);
const kHeight20 = SizedBox(height: 20);
const kHeight25 = SizedBox(height: 25);
const kHeight30 = SizedBox(height: 30);
const kHeight40 = SizedBox(height: 40);
const kHeight50 = SizedBox(height: 50);
const kHeight60 = SizedBox(height: 60);

const kShrink = SizedBox.shrink();

const kWidth5 = SizedBox(width: 5);
const kWidth10 = SizedBox(width: 10);
const kWidth15 = SizedBox(width: 15);
const kWidth20 = SizedBox(width: 20);
const kWidth30 = SizedBox(width: 30);
const kWidth40 = SizedBox(width: 40);
const kWidth50 = SizedBox(width: 50);

/// Responsive helpers (phones vs tablets).
class Responsive {
  Responsive._();

  static const double tabletBreakpoint = 700;
  static const double maxContentWidth = 900;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Number of product-grid columns for the available width.
  static int gridColumns(double width) {
    if (width >= 1100) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }
}
