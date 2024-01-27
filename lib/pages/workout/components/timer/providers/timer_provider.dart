import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _currentDuration = 0;
  bool _isTimerRunning = false;

  int get currentDuration => _currentDuration;
  bool get isTimerRunning => _isTimerRunning;

  TimerProvider() {
    loadTimerValue();
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
    _saveTimerValue();
  }

  void loadTimerValue() {
    SharedPreferences.getInstance().then((prefs) {
      _currentDuration = prefs.getInt('TimerCurrentDuration') ?? 0;
      if (_currentDuration > 0) {
        startTimer();
      }
    });
  }

  Future<void> _saveTimerValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('TimerCurrentDuration', _currentDuration);
  }

  static String formatTimerDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
