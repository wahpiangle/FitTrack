import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/rest_timer_provider.dart';



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
  Stream<CurrentWorkoutSession>? _currentWorkoutSessionStream;
  late CurrentWorkoutSession currentWorkoutSession;
  int _restTimerDuration = 60;//default rest timer value


  List<Widget> setBorders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the RestTimerProvider using Provider.of
    //_restTimerProvider = Provider.of<RestTimerProvider>(context);
  }

  @override
  @override
  void initState() {
    super.initState();
    currentWorkoutSession = CurrentWorkoutSession();
    _currentWorkoutSessionStream = objectBox.watchCurrentWorkoutSession();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });

    // _restTimerProvider.restTimerStream.listen((restDuration) {
    //   // Update UI with restDuration (e.g., display it in a Text widget)
    //   setState(() {
    //     // Update UI with restDuration
    //   });
    // });

    // Retrieve the current workout session when the state is initialized
    _updateCurrentWorkoutSession();
  }

  Future<void> _updateCurrentWorkoutSession() async {
    final workoutSession = objectBox.getCurrentWorkoutSession();
    setState(() {
      currentWorkoutSession = workoutSession;
    });

    // // Start the timer if the workout session has started and exercises are added
    // if (currentWorkoutSession.startTime != 0 &&
    //     currentWorkoutSession.exercisesSetsInfo.isNotEmpty) {
    //   Provider.of<TimerProvider>(context, listen: false).startTimer();
    // }
  }

  void selectExercise(Exercise selectedExercise) {
    objectBox.addExerciseToCurrentWorkoutSession(selectedExercise);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final restTimerProvider = Provider.of<RestTimerProvider>(context, listen: false);

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
                  onTap: () {},
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
          stream: _currentWorkoutSessionStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              currentWorkoutSession = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    ExerciseTile(
                      exerciseData: widget.exerciseData,
                      selectedExercises:
                      snapshot.data!.exercisesSetsInfo.toList(),
                      selectExercise: selectExercise,
                      timerProvider: timerProvider,
                    ),
                    Row(
                      children: [
                      Text(
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
                              restTimerProvider.startRestTimer();
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
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Rest Time (hh:mm:ss)',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (value) {
                          final duration = parseDuration(value);
                          restTimerProvider.setRestTimerDuration(duration);
                        },
                      ),
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           // objectBox.test();
          },
          child: const Icon(Icons.add),
        ),
      );
  }

  String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }

  int parseDuration(String input) {
    try {
      // Parse the input in the format of hh:mm:ss and return the total seconds
      // Replace this with your actual parsing logic
      List<String> parts = input.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      return hours * 3600 + minutes * 60 + seconds;
    } catch (e) {
      // Handle parsing errors, return a default value
      return 0;
    }
  }

}