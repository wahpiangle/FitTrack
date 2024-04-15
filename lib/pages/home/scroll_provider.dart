import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  bool _isScrollDisabled = false;

  bool get isScrollDisabled => _isScrollDisabled;

  void disableScroll() {
    _isScrollDisabled = true;
    notifyListeners();
  }

  void enableScroll() {
    _isScrollDisabled = false;
    notifyListeners();
  }
}
