import 'package:darklet/src/onboarding/view/onboarding.dart';
import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

ColorManager color = ColorManager();

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToBoarding(context);
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Darklet',
              style: FontStyles().randomTextStylePoppins(
                  color: color.primaryColor, size: 48, weight: FontWeight.w900),
            ),
          )
        ],
      ),
    );
  }

  Future<void> navigateToBoarding(context) async {
    Future.delayed(const Duration(seconds: 3), () {
      pushReplacementRoute(context, const OnboardingScreenOne());
    });
  }
}
