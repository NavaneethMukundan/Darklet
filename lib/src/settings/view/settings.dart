import 'package:darklet/src/config/config.dart';
import 'package:darklet/src/settings/controller/locale_controller.dart';
import 'package:darklet/src/settings/controller/theme_controller.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/helpers/l10n_ext.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:darklet/src/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = context.watch<ThemeController>();
    final locale = context.watch<LocaleController>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppTopBar(title: l.settings),
        body: ContentWidth(
          maxWidth: 640,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              _Heading(l.appearance),
              _Card(
                child: RadioGroup<ThemeMode>(
                  groupValue: theme.mode,
                  onChanged: (v) => theme.setMode(v!),
                  child: Column(
                    children: [
                      for (final (mode, label, icon) in [
                        (
                          ThemeMode.system,
                          l.themeSystem,
                          Icons.brightness_auto_rounded,
                        ),
                        (
                          ThemeMode.light,
                          l.themeLight,
                          Icons.light_mode_outlined,
                        ),
                        (ThemeMode.dark, l.themeDark, Icons.dark_mode_outlined),
                      ])
                        RadioListTile<ThemeMode>(
                          value: mode,
                          activeColor: color.primaryDarkColor,
                          title: Text(label, style: ts(15)),
                          secondary: Icon(icon, color: color.kBlack),
                        ),
                    ],
                  ),
                ),
              ),
              kHeight20,
              _Heading(l.language),
              _Card(
                child: RadioGroup<String>(
                  groupValue: locale.locale.languageCode,
                  onChanged: (code) => locale.setLocale(Locale(code!)),
                  child: Column(
                    children: [
                      for (final loc in LocaleController.supported)
                        RadioListTile<String>(
                          value: loc.languageCode,
                          activeColor: color.primaryDarkColor,
                          title: Text(
                            LocaleController.names[loc.languageCode] ??
                                loc.languageCode,
                            style: ts(15),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              kHeight20,
              _Heading(l.about),
              _Card(
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline_rounded,
                    color: color.kBlack,
                  ),
                  title: Text(
                    AppConfig.appName,
                    style: ts(15, w: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${l.version} 1.0.0 • ${AppConfig.useMock ? l.demoMode : l.liveMode}',
                    style: ts(12, w: FontWeight.w400, c: color.kGrey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 4),
    child: Text(text, style: ts(17, w: FontWeight.w600)),
  );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: color.kWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.kLightGrey.withValues(alpha: 0.4)),
    ),
    child: child,
  );
}
