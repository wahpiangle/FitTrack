import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'package:provider/provider.dart';

import '../../timer/custom_timer_provider.dart';

class CancelWorkoutButton extends StatelessWidget {
  final TimerProvider timerProvider;

  const CancelWorkoutButton({super.key, required this.timerProvider});

  @override
  Widget build(BuildContext context) {
    void cancelWorkout(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              surfaceTintColor: Colors.transparent,
              title: const Text(
                'Discard Workout?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: const Text(
                'Are you sure you want to discard the current workout?',
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
                    'Resume',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    objectBox.currentWorkoutSessionService.cancelWorkout();
                    timerProvider.stopTimer(); // Stop the general workout timer
                    timerProvider.resetTimer(); //reset the general workout timer

                    // Stop the rest timer
                    Provider.of<RestTimerProvider>(context, listen: false)
                        .stopRestTimer();
                    // Stop the custom timer
                    Provider.of<CustomTimerProvider>(context, listen: false)
                        .stopCustomTimer();
                  },
                  child: const Text(
                    'Discard Workout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF1A1A1A)),
      ),
      onPressed: () {
        cancelWorkout(context);
      },
      child: const Center(
        child: Text(
          "CANCEL WORKOUT",
          style: TextStyle(
            fontSize: 18,
            color: Colors.red,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
