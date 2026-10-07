import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/onboarding/widget/onboard_widget.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Three-page intro. Remembers that it was shown.
class OnboardingScreen extends StatefulWidget {
  static const seenKey = 'onboarding_seen';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.read<AppDependencies>().prefs.setBool(
      OnboardingScreen.seenKey,
      true,
    );
    if (mounted) context.pushAndClear(AppRoutes.login);
  }

  void _next() {
    if (_page == 2) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pages = [
      (Icons.person_add_alt_1_rounded, l.onboardTitle1, l.onboardBody1),
      (Icons.search_rounded, l.onboardTitle2, l.onboardBody2),
      (Icons.local_shipping_rounded, l.onboardTitle3, l.onboardBody3),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _finish,
                child: Text(l.skip, style: TextStyle(color: color.kGrey)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => OnboardingPage(
                  icon: pages[i].$1,
                  title: pages[i].$2,
                  subtitle: pages[i].$3,
                ),
              ),
            ),
            OnboardingFooter(
              currentIndex: _page,
              count: pages.length,
              label: _page == pages.length - 1 ? l.getStarted : l.next,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}
