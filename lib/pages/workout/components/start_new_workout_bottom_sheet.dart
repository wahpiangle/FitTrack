import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/models/exercise.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';// Adjust the import based on your project structure
import 'dart:async'; // Import the async package

class NewWorkoutBottomSheet {
  static Future<bool> show(BuildContext context, List<Exercise> exerciseData) async {
    bool isTimerActive = Provider.of<TimerProvider>(context, listen: false).isTimerRunning;

    if (isTimerActive) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
          fullscreenDialog: true,
        ),
      );
      return false;
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
              initialChildSize: 0.9,
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
            ),
          );
        },
      );

      // If the bottom sheet is closed, complete the Completer with true
      bottomSheetCompleter.complete(true);

      // Return the Future<bool> from the Completer
      return bottomSheetCompleter.future;
    }
  }
}


class TimerActiveScreen extends StatelessWidget {
  final List<Exercise> exerciseData;

  TimerActiveScreen({required this.exerciseData});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == notification.minExtent) {
          // The sheet is dragged down to the minChildSize, close the TimerActiveScreen
          Navigator.pop(context);
        }
        return true;
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.1,
        maxChildSize: 1.0,
        minChildSize: 0.01,
        builder: (context, controller) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            child: Container(
              color: const Color(0xFF1A1A1A), // Background color
              child: ListView(
                controller: controller,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: const Color(0xFF1A1A1A),
                        title: Text(
                          'Timer Active',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      body: Container(
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void show(BuildContext context, List<Exercise> exerciseData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TimerActiveScreen(exerciseData: exerciseData);
      },
    );
  }
}