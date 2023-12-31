import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomTimerProvider with ChangeNotifier {
  int _customTimerDuration = 120;
  int _customCurrentDuration = 0;
  int _customTimerMinutes = 0;
  int _customTimerSeconds = 0;
  Timer? _timer;
  bool _isRestTimerRunning = false;
  bool _isDialogShown = false;
  bool _isDialogOpen = false;

  bool get isRestTimerRunning => _isRestTimerRunning;
  int get customTimerDuration => _customTimerDuration;
  int get customCurrentTimerDuration => _customCurrentDuration;
  int get customTimerMinutes => _customTimerMinutes;
  int get customTimerSeconds => _customTimerSeconds;
  int get customCurrentDuration => _customCurrentDuration;
  bool get isDialogShown => _isDialogShown;
  bool get isDialogOpen => _isDialogOpen;


  CustomTimerProvider(BuildContext context) {
    _loadCustomTimerState(context);
  }



  Future<void> _loadCustomTimerState(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRestTimerRunning = prefs.getBool('isRestTimerRunning') ?? false;
    _customCurrentDuration = prefs.getInt('restTimerCurrentDuration') ?? 0;
    _isDialogShown = prefs.getBool('isDialogShown') ?? false;
    _customTimerMinutes = prefs.getInt('customTimerMinutes') ?? 0;
    _customTimerSeconds = prefs.getInt('customTimerSeconds') ?? 0;

    if (_isRestTimerRunning && _customCurrentDuration > 0) {
      startCustomTimer(context);
    }
  }



  Future<void> _saveCustomTimerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRestTimerRunning', _isRestTimerRunning);
    prefs.setInt('restTimerCurrentDuration', _customCurrentDuration);
    prefs.setBool('isDialogShown', _isDialogShown);
    prefs.setInt('customTimerMinutes', _customTimerMinutes);
    prefs.setInt('customTimerSeconds', _customTimerSeconds);
  }

  void showRestDialog() {//check if the user is opening the rest timer details dialog
    _isDialogOpen = true;
    notifyListeners();
  }

  void closeRestDialog() {
    _isDialogOpen = false;
    notifyListeners();
  }

  void setCustomTimerMinutes(int minutes) {
    _customTimerMinutes = minutes;
    notifyListeners();
  }

  void setCustomTimerSeconds(int seconds) {
    _customTimerSeconds = seconds;
    notifyListeners();
  }


  void setCustomTimerDuration(int duration) {
    _customTimerDuration = duration;
    notifyListeners();
  }

  void startCustomTimer(BuildContext context) {
    if (!_isDialogShown) {
      if (_isRestTimerRunning && _customCurrentDuration > 0) {
        // Continue from the remaining time
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_customCurrentDuration <= 0) {
            stopCustomTimer();
            _isDialogShown = false;
            if (isDialogOpen == true) {
              Navigator.of(context).pop();
            }
            _showCustomTimeEndedNotification(context);
          } else {
            notifyListeners();
            _customCurrentDuration--;
            _isRestTimerRunning = true;
          }
          _saveCustomTimerState();
        });
      } else {
        // Check if the user has chosen a time
        if (_customTimerMinutes == 0 && _customTimerSeconds == 0) {
          // Use the default time of 2 minutes
          _customTimerMinutes = 2;
          _customTimerSeconds = 0;
        }

        _customCurrentDuration = _customTimerMinutes * 60 + _customTimerSeconds;

        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_customCurrentDuration <= 0) {
            stopCustomTimer();
            _isDialogShown = false;
            if (isDialogOpen == true) {
              Navigator.of(context).pop();
            }
            _showCustomTimeEndedNotification(context);
          } else {
            notifyListeners();
            _customCurrentDuration--;
            _isRestTimerRunning = true;
          }
          _saveCustomTimerState();
        });
      }
    }
  }

  void stopCustomTimer() {
    _timer?.cancel();
    _timer = null;
    _customCurrentDuration = 0;
    notifyListeners();
    _isRestTimerRunning = false;
    // Save the rest timer state when it's stopped
    _saveCustomTimerState();
  }

  void _showCustomTimeEndedNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          surfaceTintColor: Colors.transparent,
          title: const Center(
            child: Text(
              'Custom Rest Time Ended',
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

  void resetCustomTimer(int newDuration, BuildContext context) {
    stopCustomTimer();
    _customTimerDuration = newDuration;
    _customTimerMinutes = newDuration ~/ 60;
    _customTimerSeconds = newDuration % 60;
    notifyListeners();
    // Save the rest timer state when it's reset
    _saveCustomTimerState();
    startCustomTimer(context);
  }

  void adjustCustomTime(int seconds) {
    _customCurrentDuration += seconds;
    if (_customCurrentDuration < 0) {
      _customCurrentDuration = 1;
    }
    _customTimerDuration = _customCurrentDuration; // update the rest timer duration after pressing 10s buttons
    notifyListeners();
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}


