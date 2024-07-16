import 'package:flutter/material.dart';

class ThememodeController extends ChangeNotifier {
  bool isDark = false;

  bool get nightmode {
    return isDark;
  }

  void changeMode() {
    isDark = !isDark;
    notifyListeners();
  }
}
