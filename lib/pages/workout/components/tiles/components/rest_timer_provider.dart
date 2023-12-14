import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';


class RestTimerProvider with ChangeNotifier {
  bool _isRestTimerEnabled = false;
  int _restTimerDuration = 120; // default rest timer value in seconds

  bool get isRestTimerEnabled => _isRestTimerEnabled;
  int get restTimerDuration => _restTimerDuration;

  void toggleRestTimer(bool value) {
    _isRestTimerEnabled = value;
    notifyListeners();
  }

  void setRestTimerDuration(int duration) {
    _restTimerDuration = duration;
    notifyListeners();
  }

  void startRestTimer(TimerProvider timerProvider) {
    if (_isRestTimerEnabled) {
      timerProvider.startRestTimer();
    }
  }

  void stopRestTimer(TimerProvider timerProvider) {
    if (_isRestTimerEnabled) {
      timerProvider.stopRestTimer();
    }
  }
}
