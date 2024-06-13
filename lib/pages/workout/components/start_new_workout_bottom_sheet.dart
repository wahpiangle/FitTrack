import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/models/exercise.dart';

class NewWorkoutBottomSheet {
  static void show(BuildContext context, List<Exercise> exerciseData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.95,
          maxChildSize: 1.0,
          minChildSize: 0.3,
          shouldCloseOnMinExtent: false,
          builder: (context, controller) {
            return StartNewWorkout(
              exerciseData: exerciseData,
            );
          },
        );
      },
    );
  }
}
