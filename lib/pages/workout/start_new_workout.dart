import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/pages/workout/choose_exercise.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/current_workout_session.dart';
import 'package:group_project/pages/workout/workout_screen.dart';

class StartNewWorkout extends StatefulWidget {
  final List<Exercise> exerciseData;

  StartNewWorkout({required this.exerciseData});

  @override
  _StartNewWorkoutState createState() =>
      _StartNewWorkoutState(exerciseData: exerciseData);
}

class _StartNewWorkoutState extends State<StartNewWorkout>
    with TickerProviderStateMixin {
  late Timer _timer;
  int _seconds = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTimerRunning = false;
  TextEditingController _workoutNoteController = TextEditingController();
  final List<Exercise> exerciseData;
  List<Exercise> selectedExercises = [];
  TextEditingController weightsController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  _StartNewWorkoutState({required this.exerciseData});

  CurrentWorkoutSession _currentWorkoutSession = CurrentWorkoutSession();
  List<Widget> setBorders = [];

  List<Widget> createSetBorders(
      List<Widget> currentSetBorders,
      TextEditingController weightsController,
      TextEditingController repsController) {
    // Create a new set border widget based on the weight and reps provided.
    // You can customize this function to create the desired set border widget.
    final newSetBorder = Container(
      // Define the appearance of the set border widget.
      // You can customize this to your needs.
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white, // Border color
          width: 2.0, // Border width
        ),
        borderRadius: BorderRadius.circular(10), // Border radius
      ),
      margin: const EdgeInsets.all(10), // Margin around the border
      padding: const EdgeInsets.all(10), // Padding inside the border
      child: Row(
        children: [
          Text("Weight: ${weightsController.text}"), // Display weight
          const SizedBox(width: 10),
          Text("Reps: ${repsController.text}"), // Display reps
        ],
      ),
    );

    currentSetBorders.add(newSetBorder);

    return currentSetBorders;
  }

  @override
  void initState() {
    super.initState();
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
          _seconds++;
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
    setState(() {
      selectedExercises.add(selectedExercise);
    });
  }

  void removeExercise(Exercise selectedExercise) {
    setState(() {
      selectedExercises.remove(selectedExercise);
    });
  }

  void _addSets() {
    if (selectedExercises.isNotEmpty) {
      int weight = int.tryParse(weightsController.text) ?? 0;
      int reps = int.tryParse(repsController.text) ?? 0;

      ExerciseSet newExerciseSet = ExerciseSet(weight: weight, reps: reps);

      int exerciseIndex = _currentWorkoutSession.exercises!.indexWhere(
          (exerciseData) =>
              exerciseData.keys.first.name == selectedExercises.first.name);

      if (exerciseIndex >= 0) {
        // If the exercise is found, add the set to it
        final exerciseData = _currentWorkoutSession.exercises![exerciseIndex];
        final exercise = exerciseData.keys.first;
        exerciseData[exercise]!.add(newExerciseSet);

        // Add the newly created set border to the widget tree
        setState(() {
          setBorders = createSetBorders([], weightsController, repsController);
        });
      }

      // Optionally, you can clear the text controllers
      weightsController.clear();
      repsController.clear();
    }
  }

  Widget createSetBorder(int weight, int reps) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0, // Border width
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

  Widget _buildSelectedExercise() {
    if (selectedExercises.isNotEmpty) {
      double screenWidth = MediaQuery.of(context).size.width;
      return SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // selectedExercise!.name,
              "Exercise Name",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE1F0CF),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weight",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: screenWidth *
                          0.2, // Adjust the width as a fraction of the screen width
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: weightsController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reps",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: screenWidth *
                          0.15, // Adjust the width as a fraction of the screen width
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: repsController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF333333)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              onPressed: _addSets,
              child: const Center(
                child: Text(
                  "Add Sets",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    if (_isTimerRunning) {
      _timer.cancel();
    }
    _controller.dispose();
    _workoutNoteController.dispose();
    weightsController.dispose();
    setsController.dispose();
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
          // Center this

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
            // TODO: Rest Timer
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'New Workout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _workoutNoteController,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                //TODO: Handle the workout note
              },
              decoration: InputDecoration(
                hintText: 'Add a workout note',
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                fillColor: const Color(0xFF333333),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSelectedExercise(),
            const SizedBox(height: 10),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(15)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF1A1A1A)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseExercise(
                      exercises: exerciseData,
                      selectedExercises: selectedExercises,
                      selectExercise: selectExercise,
                      removeExercise: removeExercise,
                    ),
                  ),
                );
              },
              child: const SizedBox(
                child: Center(
                  child: Text(
                    "ADD EXERCISE",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFE1F0CF),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF1A1A1A)),
              ),
              onPressed: () {
                // Navigate back to the Home screen when the button is pressed
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WorkoutScreen(),
                ));
              },
              child: const Text(
                "CANCEL WORKOUT",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
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
