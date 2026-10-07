import 'package:shared_preferences/shared_preferences.dart';

/// Recent search terms, newest first, persisted locally.
class SearchHistory {
  static const _key = 'search_history';
  static const maxItems = 8;

  final SharedPreferences? _prefs;
  SearchHistory(this._prefs);

  List<String> get items => _prefs?.getStringList(_key) ?? const [];

  Future<List<String>> add(String term) async {
    final t = term.trim();
    if (t.length < 2) return items;
    final list = [
      t,
      ...items.where((e) => e.toLowerCase() != t.toLowerCase()),
    ].take(maxItems).toList();
    await _prefs?.setStringList(_key, list);
    return list;
  }

  Future<void> clear() async => _prefs?.remove(_key);
}
