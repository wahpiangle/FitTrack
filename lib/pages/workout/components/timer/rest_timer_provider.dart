import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/components/timer/custom_timer_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class RestTimerProvider with ChangeNotifier {
  bool _isRestTimerEnabled = true; //rest timer toggle button default value is true
  int _restTimerDuration = 120;
  int _currentDuration = 0;
  int _restTimerMinutes = 0;
  int _restTimerSeconds = 0;
  Timer? _timer;
  bool _isRestTimerRunning = false;
  bool _isDialogShown = false;
  bool _isDialogOpen = false;

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
        if(_currentDuration>0) {
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
  }

  void showRestDialog() {//check if the user is opening the rest timer details dialog
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
      if (_restTimerMinutes == 0 && _restTimerSeconds == 0) {
        // Use the default time of 2 minutes
        _restTimerMinutes = 2;
        _restTimerSeconds = 0;
      }
      if (_isRestTimerRunning && _currentDuration > 0) {
        // Continue from the remaining time
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_currentDuration <= 0) {
            stopRestTimer();
            _isDialogShown = false;
            if (isDialogOpen == true) {
              Navigator.of(context).pop();
            }
            _showRestTimeEndedNotification(context);
          } else {
            notifyListeners();
            _currentDuration--;
            _isRestTimerRunning = true;
            print("restTimerProvider.isRestTimerRunning ohoho: ${isRestTimerRunning}");
          }
          _saveRestTimerState();
          print("restTimerProvider.isRestTimerRunning oho: ${isRestTimerRunning}");

        });
      } else {
        // Check if the user has chosen a time
        if (_restTimerMinutes == 0 && _restTimerSeconds == 0) {
          // Use the default time of 2 minutes
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
            _showRestTimeEndedNotification(context);
            print("restTimerProvider.isRestTimerRunning ha: ${isRestTimerRunning}");

          } else {
            notifyListeners();
            _currentDuration--;
            _isRestTimerRunning = true;
            print("restTimerProvider.isRestTimerRunning ble: ${isRestTimerRunning}");

          }
          _saveRestTimerState();
          print("restTimerProvider.isRestTimerRunning haha: ${isRestTimerRunning}");

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
    _saveRestTimerState();//so that when set is unchecked after hot restart, it will also being updated
  }

  void _showRestTimeEndedNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
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
                  Navigator.of(ctx).pop();
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


