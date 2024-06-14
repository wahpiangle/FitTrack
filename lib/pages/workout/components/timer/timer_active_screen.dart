import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:provider/provider.dart';

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
        if (notification.extent == notification.maxExtent && !isSheetOpen) {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            builder: (context) {
              isSheetOpen = true;
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.95,
                maxChildSize: 1.0,
                minChildSize: 0.3,
                builder: (context, controller) {
                  return Container(
                    color: const Color(0xFF1A1A1A),
                    child: StartNewWorkout(
                      exerciseData: exerciseData,
                    ),
                  );
                },
              );
            },
          );
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
        maxChildSize: 0.2,
        minChildSize: 0.1,
        builder: (context, controller) {
          return Container(
            color: AppColours.primary,
            child: ListView(
              controller: controller,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColours.primary,
                      elevation: 0.0,
                      automaticallyImplyLeading: false,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50.0,
                            height: 5.0,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            objectBox.currentWorkoutSessionService
                                .getCurrentWorkoutSessionTitle(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            TimerProvider.formatTimerDuration(
                                timerProvider.currentDuration),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
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
}
