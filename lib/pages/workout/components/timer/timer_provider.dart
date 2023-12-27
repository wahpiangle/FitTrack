import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _currentDuration = 0;
  bool _isTimerRunning = false;

  int get currentDuration => _currentDuration;

  TimerProvider() {
    _loadTimerValue();
  }

  void resetTimer() {
    _currentDuration = 0;
    _saveTimerValue();
    notifyListeners();
  }

  void startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _currentDuration++;
        _saveTimerValue();
        notifyListeners();
      });
      _isTimerRunning = true;
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _isTimerRunning = false;
  }

  Future<void> _loadTimerValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentDuration = prefs.getInt('timerValue') ?? 0;
    startTimer(); // Start the timer again after loading the value
  }

  Future<void> _saveTimerValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('timerValue', _currentDuration);
  }

  static String formatDuration(int seconds) {
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
