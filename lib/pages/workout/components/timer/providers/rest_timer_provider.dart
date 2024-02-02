import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/timer/components/rest_ended_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:group_project/main.dart';

class RestTimerProvider with ChangeNotifier {
  bool _isRestTimerEnabled = true;
  int _restTimerDuration = 120;
  int _currentDuration = 0;
  int _restTimerMinutes = 0;
  int _restTimerSeconds = 0;
  Timer? _timer;
  bool _isRestTimerRunning = false;
  bool _isDialogShown = false;
  bool _isDialogOpen = false;
  int selectedTimeInterval = 10;

  bool get isRestTimerRunning => _isRestTimerRunning;
  bool get isRestTimerEnabled => _isRestTimerEnabled;
  int get restTimerDuration => _restTimerDuration;
  int get currentRestTimerDuration => _currentDuration;
  int get restTimerMinutes => _restTimerMinutes;
  int get restTimerSeconds => _restTimerSeconds;
  bool get isDialogShown => _isDialogShown;
  bool get isDialogOpen => _isDialogOpen;

  void loadRestTimerState(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      _isRestTimerRunning = prefs.getBool('isRestTimerRunning') ?? false;
      _currentDuration = prefs.getInt('restTimerCurrentDuration') ?? 0;
      _isDialogShown = prefs.getBool('isDialogShown') ?? false;
      _isDialogOpen = prefs.getBool('isDialogOpen') ?? false;
      _restTimerMinutes = prefs.getInt('restTimerMinutes') ?? 0;
      _restTimerSeconds = prefs.getInt('restTimerSeconds') ?? 0;
      selectedTimeInterval = prefs.getInt('selectedRestTimeInterval') ?? 10;
      notifyListeners();
      if (_currentDuration > 0) {
        startRestTimer(context);
      }
    });
  }

  Future<void> _saveRestTimerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRestTimerRunning', _isRestTimerRunning);
    prefs.setInt('restTimerCurrentDuration', _currentDuration);
    prefs.setBool('isDialogShown', _isDialogShown);
    prefs.setBool('isDialogOpen', _isDialogOpen);
    prefs.setInt('restTimerMinutes', _restTimerMinutes);
    prefs.setInt('restTimerSeconds', _restTimerSeconds);
    prefs.setInt('selectedRestTimeInterval', selectedTimeInterval);
  }


  void setSelectedTimeInterval(int interval) {
    selectedTimeInterval = interval;
  }

  void notifySelectedIntervalChanged() {
    notifyListeners();
    _saveRestTimerState();
  }


  void showRestDialog() {
    //check if the user is opening the rest timer details dialog
    _isDialogOpen = true;
    notifyListeners();
  }

  void closeRestDialog() {
    _isDialogOpen = false;
    notifyListeners();
  }

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
    if (_isRestTimerEnabled && !_isDialogShown) {
      if (_isRestTimerRunning && _currentDuration > 0) {
        // Continue from the remaining time after hot restart
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_currentDuration <= 0) {
            stopRestTimer();
            _isDialogShown = false;
            if (isDialogOpen == true) {
              Navigator.of(context).pop();
            }
            showRestTimeEndedNotification();
          } else {
            notifyListeners();
            _currentDuration--;
            _isRestTimerRunning = true;
          }
          _saveRestTimerState();
        });
      } else {
        if (_restTimerMinutes == 0 && _restTimerSeconds == 0) {
          // default time of 2 minutes
          _restTimerMinutes = 2;
          _restTimerSeconds = 0;
        }

        _currentDuration = _restTimerMinutes * 60 + _restTimerSeconds;
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_currentDuration <= 0) {
            stopRestTimer();
            _isDialogShown = false;
            if (isDialogOpen == true) {
              Navigator.of(context).pop();
            }
            showRestTimeEndedNotification();
          } else {
            notifyListeners();
            _currentDuration--;
            _isRestTimerRunning = true;
          }
          _saveRestTimerState();
        });
      }
    }
  }

  void stopRestTimer() {
    _timer?.cancel();
    _timer = null;
    _currentDuration = 0;
    notifyListeners();
    _isRestTimerRunning = false;
    _saveRestTimerState(); //so that when set is unchecked after hot restart, it will also being updated
  }

  void showRestTimeEndedNotification() {
    navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const RestEndedDialog();
        },
      ),
    );
  }

  void resetRestTimer(int newDuration, BuildContext context) {
    stopRestTimer();
    _restTimerDuration = newDuration;
    _restTimerMinutes = newDuration ~/ 60;
    _restTimerSeconds = newDuration % 60;
    notifyListeners();
    // Save the rest timer state when it's reset
    _saveRestTimerState();
    startRestTimer(context);
  }

  void adjustRestTime(int seconds) {
    _currentDuration += seconds;
    if (_currentDuration < 0) {
      _currentDuration = 1;
    }
    _restTimerDuration = _currentDuration; // update the rest timer duration after pressing 10s buttons
    notifyListeners();
  }

  void updateRestTimerDuration(int minutes, int seconds) {
    _restTimerDuration = minutes * 60 + seconds;
    notifyListeners();
    _saveRestTimerState();
  }//update rest duration after user choose it in settings

  static String formatDuration(int seconds) {
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
