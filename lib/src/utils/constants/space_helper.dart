import 'package:flutter/material.dart';

const kHeight10 = SizedBox(height: 10);
const kHeight15 = SizedBox(height: 15);
const kHeight20 = SizedBox(height: 20);
const kHeight25 = SizedBox(height: 25);
const kHeight30 = SizedBox(height: 30);
const kHeight40 = SizedBox(height: 40);
const kHeight5 = SizedBox(height: 5);
const kHeight50 = SizedBox(height: 50);

const Kshrink = SizedBox.shrink();

const kWidth10 = SizedBox(width: 10);
const kWidth15 = SizedBox(width: 15);
const kWidth20 = SizedBox(width: 20);
const kWidth30 = SizedBox(width: 30);
const kWidth40 = SizedBox(width: 40);
const kWidth5 = SizedBox(width: 5);
const kWidth50 = SizedBox(width: 50);

class ScreenUtil {
  static double screenWidth = 0;
  static double screenHeight = 0;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static double setFontSize(double size) {
    return screenWidth * (size / 375);
  }
}
