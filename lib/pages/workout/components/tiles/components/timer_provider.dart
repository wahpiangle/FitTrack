import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  late Timer _timer;
  int _currentDuration = 0;
  bool _isTimerRunning = false;

  TimerProvider() {
    // startTimer();
  }

  int get currentDuration => _currentDuration;

  void startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _currentDuration++;
        notifyListeners(); // Notify listeners on every tick
      });
      _isTimerRunning = true; // Set the flag to true when the timer starts
    }
  }

  void stopTimer() {
    _timer.cancel();
    _isTimerRunning = false; // Set the flag to false when the timer stops
  }


  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}