import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  bool _isScrollDisabled = false;
  bool _isHorizontalScrollDisabled = false;

  bool get isScrollDisabled => _isScrollDisabled;

  bool get isHorizontalScrollDisabled => _isHorizontalScrollDisabled;

  void disableScroll() {
    _isScrollDisabled = true;
    notifyListeners();
  }

  void enableScroll() {
    _isScrollDisabled = false;
    notifyListeners();
  }

  void disableHorizontalScroll() {
    _isHorizontalScrollDisabled = true;
    notifyListeners();
  }

  void enableHorizontalScroll() {
    _isHorizontalScrollDisabled = false;
    notifyListeners();
  }
}