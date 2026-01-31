import 'package:darklet/src/auth/view/register.dart';
import 'package:darklet/src/auth/widget/input_field.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color.primaryColor,
      body: Stack(
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: Image.asset(
              AssetStore().authGraphics,
            ),
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
                  )),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    kHeight30,
                    Text(
                      'Welcome back',
                      style: FontStyles().randomTextStylePoppins(
                          size: 34,
                          color: color.kBlack,
                          weight: FontWeight.bold),
                    ),
                    Text(
                      'Enter your details below',
                      style: FontStyles().randomTextStylePoppins(
                          size: 16,
                          color: color.kGrey,
                          weight: FontWeight.w400),
                    ),
                    kHeight40,
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: InputFieldWidget(
                        isObscureText: false,
                        hintText: 'Email Address',
                      ),
                    ),
                    kHeight15,
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: InputFieldWidget(
                        isObscureText: true,
                        hintText: 'Password',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot your password ?',
                              style: FontStyles().randomTextStylePoppins(
                                  size: 16,
                                  weight: FontWeight.w400,
                                  color: color.kGrey),
                            )),
                      ),
                    ),
                    kHeight5,
                    Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: GestureDetector(
                        onTap: () {
                          pushReplacementRoute(context, BottomNavigation());
                        },
                        child: Container(
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: color.kBlack,
                              borderRadius: BorderRadius.circular(18)),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: FontStyles().randomTextStylePoppins(
                                  size: 20,
                                  weight: FontWeight.w600,
                                  color: color.kWhite),
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
                            pushReplacementRoute(
                                context, const RegisterScreen());
                          },
                          child: Text(
                            'Dont have an account ?',
                            style: FontStyles().randomTextStylePoppins(
                                size: 16,
                                weight: FontWeight.w400,
                                color: color.kGrey),
                          )),
                    ),
                    kHeight25
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
