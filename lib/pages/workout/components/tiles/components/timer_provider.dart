import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  Map<int, Timer?> _exerciseTimers = {};

  Timer? _timer;
  int _currentDuration = 0;
  bool _isTimerRunning = false;
  bool _isSetCompleted = false;
  int _restTimeInSeconds = 60; // Default rest time
  int get restTimeInSeconds => _restTimeInSeconds;

  set restTimeInSeconds(int value) {
    _restTimeInSeconds = value;
    notifyListeners();
  }
  TimerProvider() {
    // startTimer();
  }

  bool get isSetCompleted => _isSetCompleted;

  set isSetCompleted(bool value) {
    _isSetCompleted = value;
    notifyListeners();
  }

  void resetTimer() {
    _currentDuration = 0;
    notifyListeners();
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
    _timer?.cancel();
    _isTimerRunning = false; // Set the flag to false when the timer stops
  }

  void startExerciseTimer(int exerciseId) {
    if (!_exerciseTimers.containsKey(exerciseId)) {
      _exerciseTimers[exerciseId] = Timer.periodic(const Duration(seconds: 1), (timer) {
        // handle exercise timer logic here
        notifyListeners();
      });
    }
  }

  void stopExerciseTimer(int exerciseId) {
    _exerciseTimers[exerciseId]?.cancel();
    _exerciseTimers.remove(exerciseId);
    notifyListeners();
  }

  // New method to start the rest timer
  void startRestTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentDuration >= _restTimeInSeconds) {
          stopTimer();
          // Handle rest timer completion, e.g., start next exercise
        } else {
          _currentDuration++;
          notifyListeners();
        }
      });
      _isTimerRunning = true;
    }
  }
  // New method to stop the rest timer
  void stopRestTimer() {
    stopTimer();
  }

  void cancelRestTimer() {
    stopTimer();
    resetTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}