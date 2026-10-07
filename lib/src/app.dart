import 'package:darklet/l10n/app_localizations.dart';
import 'package:darklet/src/app_dependencies.dart';
import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/models/app_notification.dart';
import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/notifications/controller/notification_controller.dart';
import 'package:darklet/src/services/connectivity_controller.dart';
import 'package:darklet/src/services/push_service.dart';
import 'package:darklet/src/utils/widgets/offline_banner.dart';
import 'package:darklet/src/settings/controller/locale_controller.dart';
import 'package:darklet/src/settings/controller/theme_controller.dart';
import 'package:darklet/src/utils/constants/app_routes.dart';
import 'package:darklet/src/utils/resource/provider_notifier.dart';
import 'package:darklet/src/utils/router/app_router.dart';
import 'package:darklet/src/utils/themes/app_theme.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  final AppDependencies deps;
  const MyApp({super.key, required this.deps});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeController _theme = ThemeController(widget.deps.prefs);
  late final LocaleController _locale = LocaleController(widget.deps.prefs);
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final ConnectivityController _connectivity = ConnectivityController();
  late final PushService? _push = AppConfig.useMock
      ? null
      : PushService(widget.deps.prefs);

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuildEverything);
    _locale.addListener(_rebuildEverything);
  }

  /// Colours and fonts are read from global style helpers, so widgets that
  /// don't depend on an InheritedWidget would keep their old look after a
  /// theme/language switch. Marking the tree dirty repaints them all.
  void _rebuildEverything() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      void visit(Element e) {
        e.markNeedsBuild();
        e.visitChildren(visit);
      }

      WidgetsBinding.instance.rootElement?.visitChildren(visit);
    });
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuildEverything);
    _locale.removeListener(_rebuildEverything);
    _theme.dispose();
    _locale.dispose();
    _connectivity.dispose();
    _push?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _theme),
        ChangeNotifierProvider.value(value: _locale),
        ChangeNotifierProvider.value(value: _connectivity),
        Provider<PushService?>.value(value: _push),
        ...buildProviders(widget.deps),
      ],
      child: Consumer2<ThemeController, LocaleController>(
        builder: (context, theme, locale, _) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: ColorManager.isDark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: ColorManager.isDark
                  ? Brightness.dark
                  : Brightness.light,
            ),
            child: MaterialApp(
              title: AppConfig.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.build(dark: theme.isDark),
              locale: locale.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => _PushBridge(
                navigatorKey: _navigatorKey,
                messengerKey: _messengerKey,
                child: OfflineBanner(child: child ?? const SizedBox.shrink()),
              ),
              navigatorKey: _navigatorKey,
              scaffoldMessengerKey: _messengerKey,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
            ),
          );
        },
      ),
    );
  }
}

/// Connects push notifications (live mode only): feeds pushes into the inbox
/// and keeps the topic subscription in step with the signed-in user.
class _PushBridge extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  const _PushBridge({
    required this.child,
    required this.navigatorKey,
    required this.messengerKey,
  });

  @override
  State<_PushBridge> createState() => _PushBridgeState();
}

class _PushBridgeState extends State<_PushBridge> {
  PushService? _push;
  AuthController? _auth;

  @override
  void initState() {
    super.initState();
    _push = context.read<PushService?>();
    if (_push == null) return;
    final inbox = context.read<NotificationController>();
    _push!.start();
    _push!.notifications.listen((n) {
      inbox.add(n);
      _showBanner(n);
    });
    _auth = context.read<AuthController>()..addListener(_sync);
    _sync();
  }

  /// Android and iOS don't draw a system banner for pushes that arrive while
  /// the app is open, so show one inside the app.
  void _showBanner(AppNotification n) {
    final messenger = widget.messengerKey.currentState;
    final ctx = widget.navigatorKey.currentContext;
    if (messenger == null || ctx == null) return;
    final l = AppLocalizations.of(ctx);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                n.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (n.body.isNotEmpty) Text(n.body),
            ],
          ),
          action: SnackBarAction(
            label: l.view,
            onPressed: () => widget.navigatorKey.currentState?.pushNamed(
              AppRoutes.notifications,
            ),
          ),
        ),
      );
  }

  void _sync() => _push?.setUser(_auth?.userId);

  @override
  void dispose() {
    _auth?.removeListener(_sync);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
