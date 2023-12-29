import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/history/congratulation_screen.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';
import 'package:group_project/services/firebase/workoutSession/firebase_workouts_service.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:group_project/pages/workout/components/timer/rest_timer_provider.dart';
import 'components/timer/rest_time_picker.dart';
import 'components/timer/resttimer_details_dialog.dart';


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
  late AnimationController _controller;
  bool _isTimerRunning = false;
  late List<Exercise> exerciseData;
  bool _isSetTimeVisible = true;
  TextEditingController weightsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  List<Widget> setBorders = [];


  @override
  void initState() {
    super.initState();
    exerciseData = widget.exerciseData;

    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    //starts the timer when user first enter the start new workout screen

    if (!_isTimerRunning) {
      timerProvider.startTimer();
      setState(() {
        _isTimerRunning = true;
      });
    }
  }

  Widget createSetBorder(int weight, int reps) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text("Weight: $weight"),
          const SizedBox(width: 10),
          Text("Reps: $reps"),
        ],
      ),
    );
  }

  Widget buildSetBordersList() {
    return ListView(
      children: setBorders,
    );
  }

  void selectExercise(Exercise selectedExercise) {
    objectBox.currentWorkoutSessionService
        .addExerciseToCurrentWorkoutSession(selectedExercise);

  }
    @override
    void dispose() {
      weightsController.dispose();
      repsController.dispose();
      super.dispose();
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
          elevation: 0.0,
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
                          color: AppColours.secondary,
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
                          AppColours.secondaryDark,
                        ),
                        backgroundColor: Colors.grey[800],
                        minHeight: 40,
                        // thickness of the progress bar
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                  ),
                  if (restTimerProvider.isRestTimerEnabled &&
                      restTimerProvider.isRestTimerRunning)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: 90, //length longer as is icon + text
                        child: LinearProgressIndicator(
                          value: restTimerProvider.currentRestTimerDuration > 0
                              ? restTimerProvider.currentRestTimerDuration /
                              restTimerProvider.restTimerDuration
                              : 0.0,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColours.secondaryDark,
                          ),
                          backgroundColor: Colors.grey[800],
                          minHeight: 40,
                          // thickness of the progress bar
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
                            " ${RestTimerProvider.formatDuration(
                                restTimerProvider.currentRestTimerDuration)}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: GestureDetector(
                      onTap: () async {
                         await _showScrollTimePicker(context, restTimerProvider);
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
          stream: objectBox.currentWorkoutSessionService
              .watchCurrentWorkoutSession(),
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

    Future<void> showTimerDetailsDialog(
        RestTimerProvider restTimerProvider) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RestTimerDetailsDialog(
            restTimerProvider: restTimerProvider,
          );
        },
      );
    }


  Future<void> _showScrollTimePicker(
      BuildContext context, RestTimerProvider restTimerProvider) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColours.primaryBright,
          content: SizedBox(
            height: 500,
            width:500,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(), // Add spacer to center the title
                    Text(
                      'Rest Timer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(), // Add spacer to center the title
                    IconButton(
                      icon: const Icon(Icons.help, color: Colors.white),
                      onPressed: () {
                        // Handle question mark icon press
                        // You can show a tooltip or navigate to a help screen
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30), // Adjust spacing
                Container(
                  height: 295,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150), // Half of height or width for a perfect circle
                    border: Border.all(color: AppColours.secondary, width: 5),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: AppColours.secondary,
                      child: RestTimerCustom(restTimerProvider: restTimerProvider),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Adjust spacing
                Container(
                  height: 50, // Set a specific height for the ElevatedButton
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Rounded corners
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      restTimerProvider.resetRestTimer(
                        restTimerProvider.restTimerMinutes * 60 +
                            restTimerProvider.restTimerSeconds,
                        context,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Start Rest Timer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}