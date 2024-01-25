import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/components/start_new_workout_bottom_sheet.dart';


class TimerManager {
  static final TimerManager _instance = TimerManager._internal();

  factory TimerManager() {
    return _instance;
  }

  TimerManager._internal();

  bool isTimerActiveScreenOpen = false;

  void showTimerBottomSheet(BuildContext context, List<Exercise> exerciseData) {
    if (!isTimerActiveScreenOpen) {
      isTimerActiveScreenOpen = true;
      showBottomSheet(
        context: context,
        builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
      ).closed.then((value) {
        isTimerActiveScreenOpen = false;
      });
    }
  }

  void closeTimerBottomSheet(BuildContext context) {
    if (isTimerActiveScreenOpen) {
      Navigator.pop(context);
      isTimerActiveScreenOpen = false;
    }
  }
}
