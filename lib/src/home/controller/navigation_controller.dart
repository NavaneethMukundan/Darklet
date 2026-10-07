import 'package:flutter/foundation.dart';

/// Selected tab of the bottom navigation bar.
class NavigationController extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void select(int i) {
    if (i == _index) return;
    _index = i;
    notifyListeners();
  }

  void reset() => _index = 0;
}
