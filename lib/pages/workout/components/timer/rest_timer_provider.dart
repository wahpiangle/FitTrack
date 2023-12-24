import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerProvider with ChangeNotifier {
  bool _isRestTimerEnabled = false;
  int _restTimerDuration = 120;
  int _currentDuration = 0;
  int _restTimerMinutes = 2;
  int _restTimerSeconds = 0;
  Timer? _timer;
  bool _isRestTimerRunning = false;

  bool get isRestTimerRunning => _isRestTimerRunning;
  bool get isRestTimerEnabled => _isRestTimerEnabled;
  int get restTimerDuration => _restTimerDuration;
  int get currentRestTimerDuration => _currentDuration;
  int get restTimerMinutes => _restTimerMinutes;
  int get restTimerSeconds => _restTimerSeconds;
  int get currentDuration => _currentDuration; // Add this getter

  void setRestTimerMinutes(int minutes) {
    _restTimerMinutes = minutes;
    notifyListeners();
  }

  void setRestTimerSeconds(int seconds) {
    _restTimerSeconds = seconds;
    notifyListeners();
  }

  void toggleRestTimer(bool value) {
    _isRestTimerEnabled = value;
    notifyListeners();
  }

  void setRestTimerDuration(int duration) {
    _restTimerDuration = duration;
    notifyListeners();
  }

  void startRestTimer(BuildContext context) {
    if (_isRestTimerEnabled) {
      _currentDuration = _restTimerMinutes * 60 + _restTimerSeconds;

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentDuration <= 0) {
          stopRestTimer();
          _showRestTimeEndedNotification(context);
        } else {
          notifyListeners();
          _currentDuration--;
          _isRestTimerRunning = true;
        }
      });
    }
  }

  void stopRestTimer() {
    _timer?.cancel();
    _timer = null;
    _currentDuration = 0;
    notifyListeners();
    _isRestTimerRunning = false;
  }

  void _showRestTimeEndedNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          surfaceTintColor: Colors.transparent,
          title: const Center(
            child: Text(
              'Rest Time Ended',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            'Your rest time has ended!',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF333333),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void resetRestTimer(int newDuration, BuildContext context) {
    stopRestTimer();
    _restTimerDuration = newDuration;
    _restTimerMinutes = newDuration ~/ 60;
    _restTimerSeconds = newDuration % 60;
    notifyListeners();
    startRestTimer(context);
  }

  void adjustRestTime(int seconds) {
    _currentDuration += seconds;
    if (_currentDuration < 0) {
      _currentDuration = 0;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
