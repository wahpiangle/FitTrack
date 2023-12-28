import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/models/exercise.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'dart:async';

class NewWorkoutBottomSheet {
  static Future<bool> show(BuildContext context, List<Exercise> exerciseData) async {
    bool isTimerActive = Provider.of<TimerProvider>(context, listen: false).isTimerRunning;

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
                return Container(
                    child: StartNewWorkout(
                      exerciseData: exerciseData,
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

  // Helper function to close the TimerActiveScreen
  static void _closeTimerScreen(BuildContext context) {
    Navigator.popUntil(
      context,
          (route) => route.isFirst, // Pop until the first route (main screen)
    );
  }

  // Helper function to show the NewWorkoutBottomSheet
  static Future<bool> _showNewWorkoutBottomSheet(BuildContext context, List<Exercise> exerciseData) async {
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
              return Container(
                  child: StartNewWorkout(
                    exerciseData: exerciseData,
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

  // Helper function to check if the bottom sheet is open
  static bool _isBottomSheetOpen(BuildContext context) {
    return Scaffold.of(context).isDrawerOpen ||
        Scaffold.of(context).isEndDrawerOpen ||
        Navigator.of(context).canPop();
  }

}

class TimerActiveScreen extends StatelessWidget {
  final List<Exercise> exerciseData;

  TimerActiveScreen({required this.exerciseData});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    bool isSheetOpen = false; // Track if the new workout sheet is open

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == notification.maxExtent) {
          // Check if the new workout sheet is already open
          if (!isSheetOpen) {
            // The sheet is dragged up to the maxChildSize, close the current sheet and reopen NewWorkoutBottomSheet
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              builder: (context) {
                isSheetOpen = true; // Set the flag to indicate that the new workout sheet is open
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
                          color: const Color(0xFF1A1A1A), // Background color
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
        maxChildSize: 0.15, // Change maxChildSize to 1.0
        minChildSize: 0.01,
        builder: (context, controller) {
          return Container(
              color: const Color(0xFF1A1A1A), // Background color
              child: ListView(
                controller: controller,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: const Color(0xFF1A1A1A),
                        elevation: 0.0, // Remove the default shadow
                        automaticallyImplyLeading: false, // Disable the back button
                        title: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:15),
                              Container(
                                margin: EdgeInsets.only(left: 150.0),
                                width: 50.0,
                                height: 5.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              SizedBox(height:10),
                              Container(
                                margin: EdgeInsets.only(left: 110.0),
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  'Timer: ${TimerProvider.formatTimerDuration(timerProvider.currentDuration)}',
                                  style: TextStyle(
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
                        // The rest of your body content
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
