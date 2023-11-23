import 'dart:async';
import 'package:flutter/foundation.dart';

class RestTimerProvider with ChangeNotifier {
  final _restTimerController = StreamController<int>();
  late Timer _restTimer;
  late int _restDuration=60;
  bool _isTimerRunning = false;


  Stream<int> get restTimerStream => _restTimerController.stream;
  int get currentDuration => _restDuration;
  bool get isTimerRunning => _isTimerRunning;

  void startRestTimer(int duration) {
    print("Start Rest Timer: $duration");
    _restDuration = duration;
    _isTimerRunning = true;
    _restTimer = Timer.periodic(Duration(seconds: 1), (timer)
    {
      print("Timer Tick");
      print("_restDuration: $_restDuration");
      if (_restDuration > 0) {
        _restDuration--;
        _restTimerController.add(_restDuration);
        if (_restDuration == 0) {
          _isTimerRunning = false; // Set the timer state when it's done
        }

    }else {
         stopRestTimer();
        // Add any necessary logic when rest timer is done.
      }
    });
  }

  void stopRestTimer() {
    _restTimer.cancel();
    _isTimerRunning = false;
  }

  void resetRestTimer(int duration) {
    _restTimerController.add(duration);
    stopRestTimer();
    startRestTimer(duration);
  }


}
