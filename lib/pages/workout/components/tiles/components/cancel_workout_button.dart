import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/workout/workout_screen.dart';

class CancelWorkoutButton extends StatelessWidget {
  const CancelWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    void cancelWorkout(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
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
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const WorkoutScreen(),
                      ),
                    );
                    objectBox.clearCurrentWorkoutSession();
                  },
                  child: const Text(
                    'Cancel Workout',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                )
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
