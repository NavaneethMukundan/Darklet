import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool obscureText = true;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }

  void isObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
