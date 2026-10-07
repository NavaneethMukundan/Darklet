import 'package:darklet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Icon shown for a category id. Add your own ids here.
IconData categoryIcon(String id) => switch (id) {
  'phones' => Icons.smartphone_rounded,
  'consoles' => Icons.sports_esports_rounded,
  'laptops' => Icons.laptop_mac_rounded,
  'audio' => Icons.headphones_rounded,
  'wearables' => Icons.watch_rounded,
  _ => Icons.category_rounded,
};

/// Localised category name; falls back to the name from the data source.
String categoryLabel(AppLocalizations l, String id, String fallback) =>
    switch (id) {
      'phones' => l.catPhones,
      'consoles' => l.catConsoles,
      'laptops' => l.catLaptops,
      'audio' => l.catAudio,
      'wearables' => l.catWearables,
      _ => fallback,
    };
