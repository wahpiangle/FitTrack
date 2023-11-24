import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/workout/components/tiles/exercise_tile.dart';

class StartNewWorkout extends StatefulWidget {
  final List<Exercise> exerciseData;

  const StartNewWorkout({super.key, required this.exerciseData});

  @override
  State<StartNewWorkout> createState() => _StartNewWorkoutState();
}

class _StartNewWorkoutState extends State<StartNewWorkout>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTimerRunning = false;
  late List<Exercise> exerciseData;
  TextEditingController weightsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  Stream<CurrentWorkoutSession>? _currentWorkoutSessionStream;

  List<Widget> setBorders = [];

  @override
  void initState() {
    super.initState();
    exerciseData = widget.exerciseData;
    _currentWorkoutSessionStream = objectBox.watchCurrentWorkoutSession();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _controller.reset();
          _controller.forward();
        });
      });
      _isTimerRunning = true;
    }
  }

  void _stopTimer() {
    if (_isTimerRunning) {
      _timer.cancel();
      _isTimerRunning = false;
    }
  }

  void selectExercise(Exercise selectedExercise) {
    objectBox.currentWorkoutSessionService
        .addExerciseToCurrentWorkoutSession(selectedExercise);
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
    if (_isTimerRunning) {
      _timer.cancel();
    }
    _controller.dispose();
    weightsController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Timer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ExerciseTile(
                    exerciseData: exerciseData,
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
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$remainingSeconds";
  }
}
