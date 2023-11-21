import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';

class StartNewWorkout extends StatefulWidget {
  static final GlobalKey<_StartNewWorkoutState> startNewWorkoutKey =
  GlobalKey<_StartNewWorkoutState>();
  final List<Exercise> exerciseData;

  const StartNewWorkout({Key? key, required this.exerciseData})
      : super(key: key);

  @override
  State<StartNewWorkout> createState() => _StartNewWorkoutState();
}

class _StartNewWorkoutState extends State<StartNewWorkout>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController weightsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  Stream<CurrentWorkoutSession>? _currentWorkoutSessionStream;
  late CurrentWorkoutSession currentWorkoutSession;
  bool _isTimerRunning = false;

  List<Widget> setBorders = [];

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

    // Retrieve the current workout session when the state is initialized
    _updateCurrentWorkoutSession();
  }

  Future<void> _updateCurrentWorkoutSession() async {
    final workoutSession = await objectBox.getCurrentWorkoutSession();
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
    if (!_isTimerRunning && currentWorkoutSession.exercisesSetsInfo.isNotEmpty) {
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
    Provider.of<TimerProvider>(context, listen: false).stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
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
                  style: TextStyle(
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
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          objectBox.test();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }
}