import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/State/timer_sheet_manager.dart';
import 'package:group_project/pages/workout/components/timer/components/ongoing_exercise_dialog.dart';
import 'package:group_project/pages/workout/components/timer/providers/custom_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/providers/rest_timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/timer_active_screen.dart';
import 'package:group_project/pages/workout/workout_templates/workout_templates.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/start_new_workout_bottom_sheet.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => WorkoutScreenState();
}

class WorkoutScreenState extends State<WorkoutScreen> {
  List<Exercise> exerciseData = objectBox.exerciseService.getAllExercises();
  static bool isTimerActiveScreenOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey bottomSheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initTimers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTimerActive(context);
    });
  }

  void initTimers() {
    final restTimerProvider =
    Provider.of<RestTimerProvider>(context, listen: false);
    final customTimerProvider =
    Provider.of<CustomTimerProvider>(context, listen: false);

    if (!restTimerProvider.isRestTimerRunning) {
      restTimerProvider.loadRestTimerState(context);
    }

    if (!customTimerProvider.isRestTimerRunning) {
      customTimerProvider.loadCustomTimerState(context);
    }
  }

  Future<void> _startNewWorkout(BuildContext context) async {
    TimerProvider timerProvider =
    Provider.of<TimerProvider>(context, listen: false);

    void handleResumeWorkout() async {
      Navigator.of(context).pop();
      bool isBottomSheetClosed =
      await NewWorkoutBottomSheet.show(context, exerciseData);

      if (isBottomSheetClosed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleTimerActive(context);
        });
      }
    }

    if (timerProvider.isTimerRunning) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return OngoingExerciseDialog(
            handleResumeWorkout: handleResumeWorkout,
          );
        },
      );
    } else {
      objectBox.currentWorkoutSessionService.createCurrentWorkoutSession();

      bool isBottomSheetClosed =
      await NewWorkoutBottomSheet.show(context, exerciseData);

      if (isBottomSheetClosed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleTimerActive(context);
        });
      }
    }
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider? timerProvider =
    Provider.of<TimerProvider>(context, listen: false);

    void handleTimerStateChanged() {
      if (timerProvider.isTimerRunning &&
          !TimerManager().isTimerActiveScreenOpen) {
        TimerManager().showTimerBottomSheet(context, exerciseData);
      } else if (!timerProvider.isTimerRunning &&
          TimerManager().isTimerActiveScreenOpen) {
        TimerManager().closeTimerBottomSheet(context);
      }
    }

    void listener() {
      if (mounted) {
        handleTimerStateChanged();
      } else {
        timerProvider.removeListener(listener);
      }
    }

    timerProvider.addListener(listener);
  }

  static void showTimerBottomSheet(
      BuildContext context, List<Exercise> exerciseData) {
    showBottomSheet(
      context: context,
      builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
    ).closed.then((value) {
      isTimerActiveScreenOpen = false;
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          objectBox.test();
        },
        backgroundColor: const Color(0xFFC1C1C1),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}