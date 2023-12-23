import 'dart:async';
import 'dart:math';
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
  late RestTimerProvider restTimerProvider;



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
    restTimerProvider = Provider.of<RestTimerProvider>(context);
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
        backgroundColor: const Color(0xFF1A1A1A),
        title: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: restTimerProvider.isRestTimerEnabled && restTimerProvider.isRestTimerRunning
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: GestureDetector(
              onTap: () {
                _showRestTimerAdjustment(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      " ${TimerProvider.formatDuration(restTimerProvider.currentRestTimerDuration)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            secondChild: GestureDetector(
              onTap: () async {
                await _showScrollTimePicker(context, restTimerProvider);
                setState(() {
                  _isSetTimeVisible = !_isSetTimeVisible;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      " ${_formatTime(restTimerProvider.restTimerMinutes, restTimerProvider.restTimerSeconds)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

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


  Future<void> _showScrollTimePicker(BuildContext context, RestTimerProvider restTimerProvider) async {
    // Save the current rest timer values before showing the picker
    int initialAppBarMinutes = restTimerProvider.restTimerMinutes;
    int initialAppBarSeconds = restTimerProvider.restTimerSeconds;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        // Pass the current rest timer values to the picker
        return Container(
          height: 200,
          color: Colors.black,
          child: RestTimePicker(
            restTimerProvider: restTimerProvider,
            initialMinutes: initialAppBarMinutes,
            initialSeconds: initialAppBarSeconds,
          ),
        );
      },
    );

    // Check if the values have changed after closing the picker
    if (initialAppBarMinutes != restTimerProvider.restTimerMinutes ||
        initialAppBarSeconds != restTimerProvider.restTimerSeconds) {
      // Values have changed, update the app bar rest timer
      restTimerProvider.setRestTimerDuration(
          restTimerProvider.restTimerMinutes * 60 + restTimerProvider.restTimerSeconds);
    }
  }




  void _showPlusMinusSkip(BuildContext context, int minutes, int seconds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _PlusMinusSkipDialog(
          restTimerProvider: restTimerProvider,
          formatTime: _formatTime,
          initialRestTimerDuration: restTimerProvider.restTimerDuration,
          restTimerStream: restTimerProvider.restTimerStream,
          initialMinutes: minutes, // Pass current minutes
          initialSeconds: seconds, // Pass current seconds
        );
      },
    );
  }



// Usage in _showRestTimerAdjustment
  void _showRestTimerAdjustment(BuildContext context) {
    if (restTimerProvider.isRestTimerRunning) {
      // Show plus/minus/skip bottom sheet
      _showPlusMinusSkip(context, restTimerProvider.restTimerMinutes, restTimerProvider.restTimerSeconds);

    } else {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Adjust Rest Timer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Reduce rest time by 10 seconds
                        restTimerProvider.setRestTimerDuration(
                          restTimerProvider.restTimerDuration - 10,
                        );
                      },
                      icon: Icon(Icons.remove, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Skip rest timer
                        restTimerProvider.stopRestTimer();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Skip'),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        // Add 10 seconds to rest time
                        restTimerProvider.setRestTimerDuration(
                          restTimerProvider.restTimerDuration + 10,
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                RestTimePicker(
                  restTimerProvider: restTimerProvider,
                  initialMinutes: restTimerProvider.restTimerMinutes,
                  initialSeconds: restTimerProvider.restTimerSeconds,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Start the rest timer when the adjustment is done
                    restTimerProvider.startRestTimer(context);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        },
      );
    }
  }



}




class _PlusMinusSkipDialog extends StatefulWidget {
  final RestTimerProvider restTimerProvider;
  final String Function(int minutes, int seconds) formatTime;
  final int initialRestTimerDuration;
  final Stream<int> restTimerStream; // Add this line
  final int initialMinutes;
  final int initialSeconds;

  const _PlusMinusSkipDialog({
    Key? key,
    required this.restTimerProvider,
    required this.formatTime,
    required this.initialRestTimerDuration,
    required this.restTimerStream,
    required this.initialMinutes,
    required this.initialSeconds,

  }) : super(key: key);

  @override
  _PlusMinusSkipDialogState createState() => _PlusMinusSkipDialogState();
}


class _PlusMinusSkipDialogState extends State<_PlusMinusSkipDialog> {
  late Timer timer;
  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();

    // Use the initial rest timer duration
    minutes = widget.initialMinutes;
    seconds = widget.initialSeconds;

    // Set up a Timer to update the UI every second
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime(); // Call the method to update time
    });

    // Use a StreamBuilder to listen to changes in the rest timer duration
    widget.restTimerStream.listen((restTimerDuration) {
      setState(() {
        minutes = restTimerDuration ~/ 60;
        seconds = restTimerDuration % 60;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the Timer when the dialog is disposed
    timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      if (seconds > 0) {
        seconds--;
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
        } else {
          // If both minutes and seconds are zero, cancel the timer
          timer.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rest Timer Controls',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // Reduce rest time by 10 seconds
                    setState(() {
                      // Calculate the remaining time in seconds
                      int remainingTimeInSeconds =
                      max(0, widget.restTimerProvider.restTimerDuration - 10);

                      // Update the rest timer duration in the provider
                      widget.restTimerProvider
                          .setRestTimerDuration(remainingTimeInSeconds);

                      // Print the updated time
                      _updateTime();
                    });
                  },
                  icon: Icon(Icons.remove, color: Colors.black),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Skip rest timer
                    widget.restTimerProvider.stopRestTimer();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Skip'),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // Add 10 seconds to rest time
                    setState(() {
                      seconds += 10;
                      if (seconds >= 60) {
                        minutes++;
                        seconds -= 60;
                      }
                      widget.restTimerProvider.setRestTimerDuration(
                        minutes * 60 + seconds,
                      );
                    });
                  },
                  icon: Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              " ${widget.formatTime(minutes, seconds)}", // Use widget to access the formatTime method
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}