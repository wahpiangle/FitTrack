import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/models/exercise.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';
import 'dart:async';

class NewWorkoutBottomSheet {
  static Future<bool> show(BuildContext context, List<Exercise> exerciseData) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.95,
          maxChildSize: 1.0,
          minChildSize: 0.2,
          builder: (context, controller) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              child: Container(
                child: StartNewWorkout(
                  exerciseData: exerciseData,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
