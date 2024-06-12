import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/complete_workout/congratulation_screen.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:group_project/services/firebase/firebase_workouts_service.dart';
import 'package:provider/provider.dart';

import '../providers/custom_timer_provider.dart';

class FinishWorkoutDialog extends StatelessWidget {
  const FinishWorkoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final customTimerProvider =
        Provider.of<CustomTimerProvider>(context, listen: false);
    final restTimerProvider =
        Provider.of<RestTimerProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Finish Workout',
        style: TextStyle(
          color: AppColours.secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Are you sure that you want to finish your current workout?',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  WorkoutSession savedWorkout = objectBox
                      .currentWorkoutSessionService
                      .saveCurrentWorkoutSession(
                          timeInSeconds: timerProvider.currentDuration);
                  restTimerProvider.stopRestTimer();
                  customTimerProvider.stopCustomTimer();
                  timerProvider.stopTimer();
                  timerProvider.resetTimer();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  FirebaseWorkoutsService.createWorkoutSession(savedWorkout);
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return CongratulationScreen(
                          workoutSession: savedWorkout,
                        );
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = 0.0;
                        const end = 1.0;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return ScaleTransition(
                          scale: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppColours.secondary),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  overlayColor: WidgetStateProperty.all<Color>(
                    Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Finish Workout',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
