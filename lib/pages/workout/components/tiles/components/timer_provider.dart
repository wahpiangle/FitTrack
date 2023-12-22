import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _currentDuration = 0;
  bool _isTimerRunning = false;

  int get currentDuration => _currentDuration;

  void resetTimer() {
    _currentDuration = 0;
    notifyListeners();
  }

  void startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _currentDuration++;
        notifyListeners();
      });
      _isTimerRunning = true;
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
