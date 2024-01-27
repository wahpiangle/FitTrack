import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/workout_template.dart';
import 'package:group_project/pages/workout/components/start_new_workout_bottom_sheet.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class OngoingExerciseDialog extends StatelessWidget {
  final void Function() handleResumeWorkout;
  final bool? startFromTemplate;
  final WorkoutTemplate? workoutTemplateData;

  const OngoingExerciseDialog({
    super.key,
    required this.handleResumeWorkout,
    this.startFromTemplate,
    this.workoutTemplateData,
  });

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final restTimerProvider = Provider.of<RestTimerProvider>(context);
    final customTimerProvider = Provider.of<CustomTimerProvider>(context);

    List<Exercise> exerciseData = objectBox.exerciseService.getAllExercises();
    return AlertDialog(
      title: const Text(
        'Existing Workout',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColours.primary,
      surfaceTintColor: Colors.transparent,
      content: const Text(
        'Finish or pause the current workout before starting a new one.',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              objectBox.currentWorkoutSessionService.cancelWorkout();

              timerProvider.resetTimer();
              timerProvider.stopTimer();
              restTimerProvider.stopRestTimer();
              customTimerProvider.stopCustomTimer();
              if (startFromTemplate == true) {
                objectBox.currentWorkoutSessionService
                    .startCurrentWorkoutFromTemplate(workoutTemplateData!);
              }
              NewWorkoutBottomSheet.show(context, exerciseData);
            },
            child: const Text('Start a New Workout',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          child: TextButton(
            onPressed: () async {
              if (startFromTemplate == true) {
                Navigator.of(context).pop();
              }
              handleResumeWorkout();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            child: const Text('Resume Workout',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 5),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }
}