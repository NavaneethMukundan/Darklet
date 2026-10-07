import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/onboarding/view/onboarding.dart';
import 'package:darklet/src/utils/constants/app_constants.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final auth = context.read<AuthController>();
    final prefs = context.read<AppDependencies>().prefs;
    await Future.wait([
      auth.init(),
      Future<void>.delayed(AppConstants.splashDuration),
    ]);
    if (!mounted) return;
    final seen = prefs.getBool(OnboardingScreen.seenKey) ?? false;
    final route = auth.isLoggedIn || auth.isGuest
        ? AppRoutes.home
        : (seen ? AppRoutes.login : AppRoutes.onboarding);
    context.pushAndClear(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1D),
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.8, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (_, v, child) => Opacity(
            opacity: v.clamp(0, 1),
            child: Transform.scale(scale: v, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Same artwork as the native splash, so the hand-off is seamless.
              Image.asset(
                'assets/branding/splash_logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 8),
              Text(
                AppConfig.appName,
                style: FontStyles().randomTextStylePoppins(
                  color: color.primaryColor,
                  size: 34,
                  weight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
