import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class Messenger {
  static pop(
      {required String msg,
      required BuildContext context,
      Color? color,
      Color? textColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: FontStyles().randomTextStylePoppins(
              size: 15,
              weight: FontWeight.w500,
              color: textColor ?? ColorManager().kWhite),
        ),
        backgroundColor: color ?? ColorManager().primaryColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          textColor: textColor ?? ColorManager().kWhite,
          label: 'close',
          onPressed: () {},
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
