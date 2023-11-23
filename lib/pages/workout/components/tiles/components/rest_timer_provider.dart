import 'dart:async';
import 'package:flutter/material.dart';


class RestTimerProvider with ChangeNotifier {
  final _restTimerController = StreamController<int>();
  late Timer _restTimer = Timer(Duration.zero, () {});
  late int _restDuration = 60;
  bool _isTimerRunning = false;
  bool _isPaused = false;


  Stream<int> get restTimerStream => _restTimerController.stream;
  int get currentDuration => _restDuration;
  bool get isTimerRunning => _isTimerRunning;
  bool get isPaused => _isPaused;


  void startRestTimer(int duration,BuildContext context) {
      print("Start Rest Timer: $duration");
      _restDuration = duration;
      _isTimerRunning = true;
      _restTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        print("Timer Tick");
        print("_restDuration: $_restDuration");
        if (!_isPaused) {
          if (_restDuration > 0) {
            _restDuration--;
            _restTimerController.add(_restDuration);
            if (_restDuration == 0) {
              _isTimerRunning = false;
              showRestTimerPopup(context);
            }
          } else {
            stopRestTimer();
          }
        }
      });
      notifyListeners();

  }



  void pauseTimer() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeTimer() {
    _isPaused = false;
    notifyListeners();
  }

  void stopRestTimer() {
    _restTimer.cancel();
    _isTimerRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  void resetRestTimer(int duration,BuildContext context) {
    _restTimerController.add(duration);
    stopRestTimer();
    startRestTimer(duration, context);
  }

  void showRestTimerPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A), // Set background color to grey
          title: const Row(
            children: [
              Icon(Icons.emoji_events_sharp, color: Color(0xFFE1F0CF)), // Trophy emoji
              SizedBox(width: 8),
              Text(
                'Rest Timer Ended',
                style: TextStyle(color: Color(0xFFE1F0CF)),
              ),
            ],
          ),
          content: const Text(
            'Your rest time is over. Get back to work!',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style:TextStyle(color: Color(0xFFE1F0CF)),
              ),
            ),
          ],
        );
      },
    );
  }



}
