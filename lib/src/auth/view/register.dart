import 'package:darklet/src/auth/view/login.dart';
import 'package:darklet/src/auth/widget/input_field.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.primaryColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Image.asset(
            AssetStore().authGraphics,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.kWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      kHeight30,
                      Text(
                        'Get started free.',
                        style: FontStyles().randomTextStylePoppins(
                          size: 34,
                          color: color.kBlack,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Free forever. No credit card needed.',
                        style: FontStyles().randomTextStylePoppins(
                          size: 16,
                          color: color.kGrey,
                          weight: FontWeight.w400,
                        ),
                      ),
                      kHeight30,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InputFieldWidget(
                          isObscureText: false,
                          hintText: 'Name',
                        ),
                      ),
                      kHeight15,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InputFieldWidget(
                          isObscureText: false,
                          hintText: 'Email Address',
                        ),
                      ),
                      kHeight15,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InputFieldWidget(
                          isObscureText: true,
                          hintText: 'Password',
                        ),
                      ),
                      kHeight15,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: InputFieldWidget(
                          isObscureText: true,
                          hintText: 'Confirm Password',
                        ),
                      ),
                      kHeight30,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Container(
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.kBlack,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: FontStyles().randomTextStylePoppins(
                                size: 20,
                                weight: FontWeight.w600,
                                color: color.kWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                      kHeight5,
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextButton(
                          onPressed: () {
                            pushReplacementRoute(context, const LoginScreen());
                          },
                          child: Text(
                            'Already have an account ? ',
                            style: FontStyles().randomTextStylePoppins(
                              size: 16,
                              weight: FontWeight.w400,
                              color: color.kGrey,
                            ),
                          ),
                        ),
                      ),
                      kHeight25,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
