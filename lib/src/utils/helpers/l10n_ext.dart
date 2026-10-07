import 'package:darklet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
