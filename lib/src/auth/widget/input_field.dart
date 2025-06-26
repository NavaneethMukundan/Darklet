import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputFieldWidget extends StatelessWidget {
  final bool isObscureText;
  final String hintText;
  const InputFieldWidget(
      {super.key, required this.isObscureText, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(builder: (context, auth, child) {
      return TextFormField(
        obscureText: isObscureText == false ? false : auth.obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: FontStyles().randomTextStylePoppins(
              size: 16, weight: FontWeight.w400, color: color.kGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide(color: color.kLightGrey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide(color: color.kLightGrey, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide(color: color.kLightGrey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide(color: color.kLightGrey, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
          suffixIcon: isObscureText == false
              ? const SizedBox()
              : IconButton(
                  icon: Icon(
                    auth.obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    auth.isObscureText();
                  },
                ),
        ),
      );
    });
  }
}
