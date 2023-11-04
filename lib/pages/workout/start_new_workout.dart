import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/workout/choose_exercise.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/constants/data/exercises_data.dart';
import 'package:group_project/models/exercise_set.dart';
import 'package:group_project/models/current_workout_session.dart';

class StartNewWorkout extends StatefulWidget {
  final List<Exercise> exerciseData;

  StartNewWorkout({required this.exerciseData});

  @override
  _StartNewWorkoutState createState() => _StartNewWorkoutState(exerciseData: exerciseData);
}

class _StartNewWorkoutState extends State<StartNewWorkout> with TickerProviderStateMixin {
  late Timer _timer;
  int _seconds = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTimerRunning = false;
  TextEditingController _workoutNoteController = TextEditingController();
  final List<Exercise> exerciseData;
  Exercise? selectedExercise; // Store the selected exercise
  bool isAddExerciseVisible = true;
  bool isAddSetsVisible = false; // Initially, "Add Sets" button is hidden.
  TextEditingController setIdController = TextEditingController();
  TextEditingController weightsController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  _StartNewWorkoutState({required this.exerciseData});

  CurrentWorkoutSession _currentWorkoutSession = CurrentWorkoutSession();
  List<Widget> setBorders = [];


  List<Widget> createSetBorders(List<Widget> currentSetBorders, TextEditingController weightsController, TextEditingController repsController) {
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
      margin: EdgeInsets.all(10), // Margin around the border
      padding: EdgeInsets.all(10), // Padding inside the border
      child: Row(
        children: [
          Text("Weight: ${weightsController.text}"), // Display weight
          SizedBox(width: 10),
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
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

  Future<void> _navigateToChooseExercise() async {
    // Navigate to the ChooseExercise screen and wait for the result (selected exercise)
    final exercise = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseExercise(exercises: exerciseData),
      ),
    );

    // Check if an exercise was selected and handle it
    if (exercise != null) {
      // Handle the selected exercise (e.g., add it to the list of selected exercises)
      setState(() {
        selectedExercise = exercise;
        isAddExerciseVisible = false; // Hide the "Add Exercise" button
        isAddSetsVisible = true; // Show the "Add Sets" button
      });
    }
  }

  void _addSets() {
    // Check if an exercise is selected
    if (selectedExercise != null) {
      int weight = int.tryParse(weightsController.text) ?? 0;
      int reps = int.tryParse(repsController.text) ?? 0;

      // Validate the input if needed

      // Create a new ExerciseSet object
      ExerciseSet newExerciseSet = ExerciseSet(weight: weight, reps: reps);

      // Find the index of the selected exercise in the list of exercises
      int exerciseIndex = _currentWorkoutSession.exercises?.indexWhere((exerciseData) {
        return exerciseData.keys.first == selectedExercise;
      }) ?? -1;

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

// Create and return a new set border widget
  Widget createSetBorder(int weight, int reps) {
    return Container(
      // Define the appearance of the set border widget.
      // You can customize this to your needs.
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white, // Border color
          width: 2.0, // Border width
        ),
        borderRadius: BorderRadius.circular(10), // Border radius
      ),
      margin: EdgeInsets.all(10), // Margin around the border
      padding: EdgeInsets.all(10), // Padding inside the border
      child: Row(
        children: [
          Text("Weight: $weight"), // Display weight
          SizedBox(width: 10),
          Text("Reps: $reps"), // Display reps
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
    if (selectedExercise != null) {
      double screenWidth = MediaQuery.of(context).size.width;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedExercise!.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set ID:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.2, // Adjust the width as a fraction of the screen width
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: setIdController,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
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
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Weights",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.2, // Adjust the width as a fraction of the screen width
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: weightsController,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
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
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sets",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.15, // Adjust the width as a fraction of the screen width
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: setsController,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
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
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reps",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.15, // Adjust the width as a fraction of the screen width
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: repsController,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
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
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }




  @override
  void dispose() {
    if (_isTimerRunning) {
      _timer.cancel();
    }
    _controller.dispose();
    _workoutNoteController.dispose();
    setIdController.dispose();
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
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Workout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text(
              "Finish",
              style: TextStyle(
                color: Color(0xFFE1F0CF),
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      backgroundColor: Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Text(
                _formatTime(_seconds),
                style: TextStyle(
                  fontSize: 90,
                  fontFamily: 'Digital',
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE1F0CF)),
                  ),
                  onPressed: () {
                    _startTimer();
                  },
                  child: Text(
                    "Start Timer",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE1F0CF)),
                  ),
                  onPressed: () {
                    _stopTimer();
                  },
                  child: Text(
                    "Stop Timer",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Container(
              width: 350,
              child: TextField(
                controller: _workoutNoteController,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Add a workout note...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: Color(0xFF333333),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isAddExerciseVisible) // Only show the "Add Exercise" button if it's visible
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF333333)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: _navigateToChooseExercise,
                child: Container(
                  width: 200,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Add Exercise",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            _buildSelectedExercise(), // Display the selected exercise
            SizedBox(height: 20),
            if (isAddSetsVisible) // Show the "Add Sets" button only when exercise is chosen
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF333333)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: _addSets,
                child: Container(
                  width: 200,
                  height: 50,
                  child: Center(
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
              ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF333333)),
                ),
                onPressed: () {
                  // Navigate back to the Home screen when the button is pressed
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Home(),
                  ));
                },
                child: Text(
                  "Cancel Workout",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
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

void main() {
  List<Exercise> exerciseData = generateExerciseData(); // Fetch exerciseData from your source
  runApp(MaterialApp(
    home: StartNewWorkout(exerciseData: exerciseData),
  ));
}
