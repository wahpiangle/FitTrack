import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_time_picker.dart';



class StartNewWorkout extends StatefulWidget {
  static final GlobalKey<_StartNewWorkoutState> startNewWorkoutKey =
  GlobalKey<_StartNewWorkoutState>();
  final List<Exercise> exerciseData;

  const StartNewWorkout({super.key, required this.exerciseData});

  @override
  State<StartNewWorkout> createState() => _StartNewWorkoutState();
}

class _StartNewWorkoutState extends State<StartNewWorkout>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTimerRunning = false;
  late List<Exercise> exerciseData;
  TextEditingController weightsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  bool _isSetTimeVisible = true;



  List<Widget> setBorders = [];

  @override
  void initState() {
    super.initState();
    exerciseData = widget.exerciseData;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });
  }



  void selectExercise(Exercise selectedExercise) {
    objectBox.currentWorkoutSessionService
        .addExerciseToCurrentWorkoutSession(selectedExercise);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
   // final restTimerProvider = Provider.of<RestTimerProvider>(context, listen: false);

    if (!_isTimerRunning) {
      timerProvider.startTimer();
      // timerProvider.startExerciseTimer(selectedExercise.id);
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

  @override
  void dispose() {
    _controller.dispose();
    weightsController.dispose();
    repsController.dispose();
    super.dispose();

  }



  void _delete(BuildContext context) {
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
                  // Close the dialog
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  objectBox.saveCurrentWorkoutSession();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
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
                    return exercisesSetsInfo.exerciseSets.every((exerciseSet) {
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
        ],

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<TimerProvider>(
              builder: (context, timerProvider, child) {
                return Text(
                  "Timer: ${formatDuration(timerProvider.currentDuration)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
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
                  Row(
                    children: [
                      const Text(
                        'Rest Timer',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                      Switch(
                        value: restTimerProvider.isRestTimerEnabled,
                        onChanged: (value) {
                          if (value) {
                            // Start rest timer
                            restTimerProvider.startRestTimer(context);
                          } else {
                            // Stop rest timer
                            restTimerProvider.stopRestTimer();
                          }
                          restTimerProvider.toggleRestTimer(value);
                        },
                      ),
                    ],
                  ),
                  if (restTimerProvider.isRestTimerEnabled)
                    const SizedBox(width: 10),

                  if (restTimerProvider.isRestTimerEnabled)
                    GestureDetector(
                      onTap: () async {
                        await _showScrollTimePicker(context, restTimerProvider);
                        setState(() {
                          _isSetTimeVisible = !_isSetTimeVisible;
                        });
                      },
                      child:AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: restTimerProvider.isRestTimerEnabled && restTimerProvider.isRestTimerRunning
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Text(
                          "Rest Timer: ${formatDuration(restTimerProvider.currentRestTimerDuration)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        secondChild: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              "Set Time: ${_formatTime(restTimerProvider.restTimerMinutes, restTimerProvider.restTimerSeconds)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),


                    ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //objectBox.test();
        },
        child: const Icon(Icons.add),
      ),
    );
  }



  String _formatTime(int minutes, int seconds) {
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String formatDuration(int seconds) {
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  Future<void> _showScrollTimePicker(BuildContext context, RestTimerProvider restTimerProvider) async {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black, // Set the background color
      builder: (BuildContext context) {
        return Container(
          height: 200, // Set the desired height of the bottom sheet
          color: Colors.black, // Set the background color
          child: RestTimePicker(restTimerProvider: restTimerProvider),
        );
      },
    );
  }




}


