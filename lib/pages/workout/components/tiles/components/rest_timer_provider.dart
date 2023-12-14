import 'dart:async';

import 'package:flutter/foundation.dart';

class RestTimerProvider with ChangeNotifier {
  bool _isRestTimerEnabled = false;
  int _restTimerDuration = 120;
  int _currentDuration = 0;
  Timer? _timer;

  bool get isRestTimerEnabled => _isRestTimerEnabled;
  int get restTimerDuration => _restTimerDuration;
  int get currentRestTimerDuration => _currentDuration;

  void toggleRestTimer(bool value) {
    _isRestTimerEnabled = value;
    notifyListeners();
  }

  void setRestTimerDuration(int duration) {
    _restTimerDuration = duration;
    notifyListeners();
  }

  // method to start the rest timer
  void startRestTimer() {
    if (_isRestTimerEnabled) {
      print('Rest Timer started!');
      _currentDuration = _restTimerDuration;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentDuration <= 0) {
          stopRestTimer();
        } else {
          _currentDuration--;
          print('duration:$_currentDuration');
          notifyListeners();
        }
      });
      notifyListeners();
    }
  }

  //method to stop the rest timer
  void stopRestTimer() {
    _timer?.cancel();
    _timer = null;
    _currentDuration = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
