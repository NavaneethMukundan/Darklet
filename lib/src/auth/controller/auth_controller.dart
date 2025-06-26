import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool obscureText = true;

  void isObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
