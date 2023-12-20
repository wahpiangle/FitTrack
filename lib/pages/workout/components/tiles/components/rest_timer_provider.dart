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


  // method to start the rest timer
  void startRestTimer(BuildContext context) {
    if (_isRestTimerEnabled) {
      _currentDuration = _restTimerMinutes * 60 + _restTimerSeconds;

      // Cancel the existing timer if it's already running
      _timer?.cancel();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentDuration <= 0) {
          stopRestTimer();

          // Show the pop-up notification
          _showRestTimeEndedNotification(context);
        } else {

          // Update the UI by calling notifyListeners
          notifyListeners();

          // Decrement the duration
          _currentDuration--;
          _isRestTimerRunning = true; // Set the rest timer as running
        }
      });
    }
  }


  //method to stop the rest timer
  void stopRestTimer() {
    _timer?.cancel();
    _timer = null;
    _currentDuration = 0;
    notifyListeners();
    _isRestTimerRunning = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showRestTimeEndedNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Rest Time Ended',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Your rest time has ended!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
