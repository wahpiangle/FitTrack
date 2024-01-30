import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/workout_screen.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'dart:async';

class NewWorkoutBottomSheet {
  static Future<bool> show(
      BuildContext context, List<Exercise> exerciseData) async {
    bool isTimerActive =
        Provider.of<TimerProvider>(context, listen: false).isTimerRunning;

    // Check if the timer is active and the bottom sheet is not open
    if (isTimerActive && !_isBottomSheetOpen(context)) {
      // Close the active timer sheet
      _closeTimerScreen(context);
      // Wait for a short duration to allow the timer sheet to close
      await Future.delayed(const Duration(milliseconds: 10));
      // Show the new workout bottom sheet
      return _showNewWorkoutBottomSheet(context, exerciseData);
    } else {
      Completer<bool> bottomSheetCompleter = Completer<bool>();

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              // Do nothing on tap to prevent closing when the bottom sheet is open
              bottomSheetCompleter.complete(false);
            },
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.95,
              maxChildSize: 1.0,
              minChildSize: 0.2,
              builder: (context, controller) {
                return StartNewWorkout(
                  exerciseData: exerciseData,
                );
              },
            ),
          );
        },
      );
      bottomSheetCompleter.complete(true);

      return bottomSheetCompleter.future;
    }
  }

  static void _closeTimerScreen(BuildContext context) {
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  static Future<bool> _showNewWorkoutBottomSheet(
      BuildContext context, List<Exercise> exerciseData) async {
    Completer<bool> bottomSheetCompleter = Completer<bool>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            bottomSheetCompleter.complete(false);
          },
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.95,
            maxChildSize: 1.0,
            minChildSize: 0.2,
            builder: (context, controller) {
              // Call the static method from _WorkoutScreenState
              WorkoutScreenState.showTimerBottomSheet(context, exerciseData);
              return StartNewWorkout(
                exerciseData: exerciseData,
              );
            },
          ),
        );
      },
    );

    bottomSheetCompleter.complete(true);

    return bottomSheetCompleter.future;
  }

  static bool _isBottomSheetOpen(BuildContext context) {
    return Scaffold.of(context).isDrawerOpen ||
        Scaffold.of(context).isEndDrawerOpen ||
        Navigator.of(context).canPop();
  }
}
