import 'package:flutter/material.dart';
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
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Are you sure that you want to finish workout?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            WorkoutSession savedWorkout = objectBox.currentWorkoutSessionService
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
          child: const Text(
            'Finish Workout',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
