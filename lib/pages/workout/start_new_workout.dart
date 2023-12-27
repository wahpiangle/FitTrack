import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/history/congratulation_screen.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'components/timer/resttimer_details_dialog.dart';
import 'package:group_project/services/firebase/workoutSession/firebase_workouts_service.dart';


class StartNewWorkout extends StatefulWidget {
  final List<Exercise> exerciseData;

  const StartNewWorkout({super.key, required this.exerciseData});

  void showTimerDetailsDialog(
      BuildContext context, RestTimerProvider restTimerProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestTimerDetailsDialog(
          restTimerProvider: restTimerProvider,
        );
      },
    );
  }

  @override
  State<StartNewWorkout> createState() => _StartNewWorkoutState();
}

class _StartNewWorkoutState extends State<StartNewWorkout>
    with TickerProviderStateMixin {
  bool _isTimerRunning = false;
  late List<Exercise> exerciseData;
  bool _isSetTimeVisible = true;

  List<Widget> setBorders = [];

  @override
  void initState() {
    super.initState();
    exerciseData = widget.exerciseData;
  }

  void selectExercise(Exercise selectedExercise) {
    objectBox.currentWorkoutSessionService
        .addExerciseToCurrentWorkoutSession(selectedExercise);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    if (!_isTimerRunning) {
      timerProvider.startTimer();
      setState(() {
        _isTimerRunning = true;
      });
    }
  }

  void _delete(BuildContext context) {
    final restTimerProvider =
    Provider.of<RestTimerProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);

    showDialog(
        context: context,
        builder: (BuildContext ctx) {
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
                  // Stop the rest timer and general workout timer
                  restTimerProvider.stopRestTimer();
                  timerProvider.stopTimer();
                  timerProvider.resetTimer();
                  // Close the dialog
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  WorkoutSession savedWorkout =
                  objectBox.saveCurrentWorkoutSession();
                  FirebaseWorkoutsService.createWorkoutSession(savedWorkout);
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const CongratulationScreen();
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
                      transitionDuration: const Duration(
                          milliseconds: 500), // Set to 0.5 seconds
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
        });
  }

  void removeSet(int exerciseSetId) {
    setState(() {
      objectBox.removeSetFromExercise(exerciseSetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final restTimerProvider = Provider.of<RestTimerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    bool everySetCompleted = objectBox
                        .currentWorkoutSessionService
                        .getCurrentWorkoutSession()
                        .exercisesSetsInfo
                        .every((exercisesSetsInfo) {
                      return exercisesSetsInfo.exerciseSets
                          .every((exerciseSet) {
                        return exerciseSet.isCompleted;
                      });
                    });
                    bool isNotEmpty = objectBox.currentWorkoutSessionService
                        .getCurrentWorkoutSession()
                        .exercisesSetsInfo
                        .isNotEmpty;
                    if (isNotEmpty) {
                      if (everySetCompleted) {
                        _delete(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please complete all sets",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Color(0xFF1A1A1A),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please add at least one exercise",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Color(0xFF1A1A1A),
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Finish",
                      style: TextStyle(
                        color: Color(0xFFE1F0CF),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        title: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: GestureDetector(
            onTap: () {
              if (restTimerProvider.isRestTimerRunning) {
                showTimerDetailsDialog(restTimerProvider);
              }
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: 40,
                    child: LinearProgressIndicator(
                      value: restTimerProvider.currentRestTimerDuration > 0
                          ? restTimerProvider.currentRestTimerDuration /
                          restTimerProvider.restTimerDuration
                          : 0.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF678F37),),
                      backgroundColor: Colors.grey[700],
                      minHeight: 40, // thickness of the progress bar
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                ),
                if (restTimerProvider.isRestTimerEnabled &&
                    restTimerProvider.isRestTimerRunning)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      width: 90,//length longer as is icon + text
                      child: LinearProgressIndicator(
                        value: restTimerProvider.currentRestTimerDuration > 0
                            ? restTimerProvider.currentRestTimerDuration /
                            restTimerProvider.restTimerDuration
                            : 0.0,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF678F37),),
                        backgroundColor: Colors.grey[600],
                        minHeight: 40, // thickness of the progress bar
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                  ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: restTimerProvider.isRestTimerEnabled &&
                      restTimerProvider.isRestTimerRunning
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.white, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          " ${RestTimerProvider.formatDuration(restTimerProvider.currentRestTimerDuration)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () async {
                      // await _showScrollTimePicker(context, restTimerProvider);
                      setState(() {
                        _isSetTimeVisible = !_isSetTimeVisible;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColours.primary,
      body: StreamBuilder<CurrentWorkoutSession>(
        stream:
        objectBox.currentWorkoutSessionService.watchCurrentWorkoutSession(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ExerciseTile(
                    exerciseData: exerciseData,
                    exercisesSetsInfo:
                    snapshot.data!.exercisesSetsInfo.toList(),
                    selectExercise: selectExercise,
                    removeSet: removeSet,
                    timerProvider: timerProvider,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }


  Future<void> showTimerDetailsDialog(RestTimerProvider restTimerProvider) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestTimerDetailsDialog(
          restTimerProvider: restTimerProvider,
        );
      },
    );
  }

}