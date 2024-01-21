import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/models/exercise.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
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
      await Future.delayed(Duration(milliseconds: 10));
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

class TimerActiveScreen extends StatelessWidget {
  final List<Exercise> exerciseData;

  const TimerActiveScreen({
    super.key,
    required this.exerciseData,
  });

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    bool isSheetOpen = false;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == notification.maxExtent) {
          if (!isSheetOpen) {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              builder: (context) {
                isSheetOpen = true;
                return GestureDetector(
                  onTap: () {
                    // Do nothing on tap to prevent closing when the bottom sheet is open
                  },
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.95,
                    maxChildSize: 1.0,
                    minChildSize: 0.2,
                    builder: (context, controller) {
                      return Container(
                        color: const Color(0xFF1A1A1A),
                        child: StartNewWorkout(
                          exerciseData: exerciseData,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          // Prevent the sheet from being dragged down when reaching the maximum extent
          return false;
        }

        // If the sheet is closed, reset the flag
        isSheetOpen = false;

        return true;
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.1,
        maxChildSize: 0.15,
        minChildSize: 0.01,
        builder: (context, controller) {
          return Container(
            color: const Color(0xFF1A1A1A),
            child: ListView(
              controller: controller,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: const Color(0xFF1A1A1A),
                      elevation: 0.0, // Remove the default shadow
                      automaticallyImplyLeading:
                          false, // Disable the back button
                      title: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(left: 150.0),
                              width: 50.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(left: 110.0),
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                'Timer: ${TimerProvider.formatTimerDuration(timerProvider.currentDuration)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: Container(
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
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
