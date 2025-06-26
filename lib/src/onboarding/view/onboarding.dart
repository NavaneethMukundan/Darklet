import 'package:darklet/src/auth/view/login.dart';
import 'package:darklet/src/onboarding/widget/onboard_widget.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:flutter/material.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: OnboardingWidget(
              image: AssetStore().onb1,
              title: 'Start by creating\nan account',
              subtitle:
                  'Discover a smarter way to shop, sell, and connect.\nLet’s get started by signing in to your account.',
              currentIndex: 1,
              onNext: () {
                pushReplacementRoute(context, const OnboardingScreenTwo());
              })),
    );
  }
}

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: OnboardingWidget(
              image: AssetStore().onb3,
              title: 'You’re All Set!',
              subtitle:
                  'Your order is placed and on its way.\nSit back, relax — we’ll handle the rest.',
              currentIndex: 3,
              onNext: () {
                pushReplacementRoute(context, const LoginScreen());
              })),
    );
  }
}

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: OnboardingWidget(
              image: AssetStore().onb2,
              title: 'Tell Us What\nYou’re Looking For',
              subtitle:
                  'Buying or selling? We got you.\nChoose what you need and explore.',
              currentIndex: 2,
              onNext: () {
                pushReplacementRoute(context, const OnboardingScreenThree());
              })),
    );
  }
}
