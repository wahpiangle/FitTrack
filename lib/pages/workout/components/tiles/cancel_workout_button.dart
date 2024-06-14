import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:provider/provider.dart';

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
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'Are you sure you want to discard the current workout?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              AppColours.secondary),
                        ),
                        child: const Text(
                          'Resume',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          objectBox.currentWorkoutSessionService
                              .cancelWorkout();
                          timerProvider.stopTimer();
                          timerProvider.resetTimer();

                          Provider.of<RestTimerProvider>(context, listen: false)
                              .stopRestTimer();
                          Provider.of<CustomTimerProvider>(context,
                                  listen: false)
                              .stopCustomTimer();
                        },
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.red),
                        ),
                        child: const Text(
                          'Discard Workout',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    }

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0xFF1A1A1A)),
      ),
      onPressed: () {
        cancelWorkout(context);
      },
      child: const Center(
        child: Text(
          "CANCEL WORKOUT",
          style: TextStyle(
            fontSize: 14,
            color: Colors.red,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
