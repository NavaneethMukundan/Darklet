import 'package:darklet/src/app.dart';
import 'package:darklet/src/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

Future<void> _pump(WidgetTester t, [int ms = 400, int times = 3]) async {
  for (var i = 0; i < times; i++) {
    await t.pump(Duration(milliseconds: ms));
  }
}

void main() {
  testWidgets('onboarding -> login -> home -> add to cart -> theme switch', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(840, 1800);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    final deps = await testDeps();
    await tester.pumpWidget(MyApp(deps: deps));

    // Splash then onboarding.
    await _pump(tester, 800, 4);
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await _pump(tester);

    // Login with the demo account.
    expect(find.text('Welcome back'), findsOneWidget);
    await tester.tap(find.textContaining('Demo account'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await _pump(tester, 400, 4);

    // Home.
    expect(find.text('Flash sales'), findsOneWidget);
    expect(find.textContaining('Hello, John'), findsOneWidget);

    // The first flash-sale phone has options (storage / colour), so the quick
    // add button opens its details; add it to the cart from there.
    await tester.tap(find.byIcon(Icons.tune_rounded).first);
    await _pump(tester, 300, 3);
    expect(find.text('Storage: '), findsNothing);
    expect(find.textContaining('Storage'), findsWidgets);
    await tester.tap(find.textContaining('Add to cart'));
    await _pump(tester, 300, 2);
    expect(find.text('View cart'), findsOneWidget);
    await tester.pageBack();
    await _pump(tester, 300, 3);

    // Profile tab -> dark mode.
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await _pump(tester, 300, 2);
    expect(find.text('John Doe'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await _pump(tester, 300, 3);
    expect(deps.prefs.getString('theme_mode'), 'dark');
    expect(AppConfig.appName, 'Darklet');
  });

  testWidgets('shows Arabic with RTL layout', (tester) async {
    tester.view.physicalSize = const Size(840, 1800);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    final deps = await testDeps({'locale': 'ar', 'onboarding_seen': true});
    await tester.pumpWidget(MyApp(deps: deps));
    await _pump(tester, 800, 4);
    expect(find.text('مرحبًا بعودتك'), findsOneWidget);
    final dir = Directionality.of(tester.element(find.text('مرحبًا بعودتك')));
    expect(dir, TextDirection.rtl);
  });
}
