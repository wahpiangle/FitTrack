import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/workout_templates/workout_templates.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/start_new_workout_bottom_sheet.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<Exercise> exerciseData = objectBox.getAllExercises();
  bool isBottomSheetVisible = false;
  bool isTimerActiveScreenOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _startNewWorkout(BuildContext context) async {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    if (timerProvider.isTimerRunning) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Existing Workout',
                style: TextStyle(color: Colors.white)),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
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
                    Navigator.of(ctx).pop();
                    _resetWorkout();
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
                    Navigator.of(ctx).pop();

                    bool isBottomSheetClosed =
                        await NewWorkoutBottomSheet.show(context, exerciseData);

                    if (isBottomSheetClosed) {
                      _handleTimerActive(context);
                    }


                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black26),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black26),
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
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Close',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    objectBox.currentWorkoutSessionService.createCurrentWorkoutSession();

    bool isBottomSheetClosed =
        await NewWorkoutBottomSheet.show(context, exerciseData);

    if (isBottomSheetClosed) {
      _handleTimerActive(context);
    }
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    if (isTimerActiveScreenOpen) {
      return;
    }

    timerProvider.addListener(() {
      if (timerProvider.isTimerRunning && !isTimerActiveScreenOpen) {
        isTimerActiveScreenOpen = true;
        showBottomSheet(
          context: context,
          builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
        ).closed.then((value) {
          isTimerActiveScreenOpen = false;
        });
      }
    });

    if (timerProvider.isTimerRunning && !isTimerActiveScreenOpen) {
      isTimerActiveScreenOpen = true;
      showBottomSheet(
        context: context,
        builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
      ).closed.then((value) {
        isTimerActiveScreenOpen = false;
      });
    }
  }

  void _resetWorkout() {
    objectBox.currentWorkoutSessionService.cancelWorkout();

    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.resetTimer();
    timerProvider.stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        color: const Color(0xFF1A1A1A),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: TextButton(
                    onPressed: () {
                      _startNewWorkout(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFC1C1C1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    child: const Text(
                      "Start An Empty Workout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const WorkoutTemplates(),
            ],
          ),
        ),
      ),
    );
  }
}
