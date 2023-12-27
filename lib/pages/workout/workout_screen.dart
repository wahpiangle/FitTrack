import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/components/tiles/components/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/new_workout.dart';
import 'package:group_project/pages/workout/components/start_new_workout_bottom_sheet.dart';


class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late List<Exercise> exerciseData;
  bool isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    exerciseData = objectBox.getAllExercises();
  }
  Future<void> _startNewWorkout(BuildContext context) async {
    TimerProvider timerProvider = Provider.of<TimerProvider>(context, listen: false);

    // Check if the timer is active
    if (timerProvider.isTimerRunning) {
      // Show a dialog with options to resume, stop, or close the dialog
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Existing Workout'),
            content: Text('Finish or pause the current workout before starting a new one.'),
            actions: [
              TextButton(
                onPressed: () async {
                  // Add code to handle resuming the workout
                  Navigator.of(ctx).pop(); // Close the dialog

                },
                child: Text('Resume Workout'),
              ),
              TextButton(
                onPressed: () {
                  // Add code to handle stopping and resetting the workout
                  Navigator.of(ctx).pop(); // Close the dialog

                  // Call _resetWorkout
                  _resetWorkout();

                  // Open the NewWorkoutBottomSheet
                  NewWorkoutBottomSheet.show(context, exerciseData);
                },
                child: Text('Start a new Workout'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close the dialog without taking any action
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
      return; // Exit the function without starting a new workout
    }

    // Create a new workout session
    objectBox.currentWorkoutSessionService.createCurrentWorkoutSession();

    // Show the NewWorkoutBottomSheet
    bool isBottomSheetClosed = await NewWorkoutBottomSheet.show(context, exerciseData);

  }


  void _resetWorkout() {
    // Cancel the workout (remove all sets and exercises)
    objectBox.currentWorkoutSessionService.cancelWorkout();

    // Reset timer
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.resetTimer();


    // Stop the timer
    timerProvider.stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);


    return Scaffold(
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
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xFF333333),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const Text(
                            "Add new template",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Empower your journey with a new workout.",
                            style: TextStyle(
                              color: Color(0xFFC1C1C1),
                              fontSize: 13,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 15),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add navigation logic for adding a new template.
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(290, 40)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFFE1F0CF)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Add New Template',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NewWorkout(
                    imagePath: 'assets/icons/dumbell.png',
                    workoutText: 'Legs',
                    exerciseData: exerciseData, // Add this line
                  ),
                  SizedBox(width: 15),
                  NewWorkout(
                    imagePath: 'assets/icons/dumbell.png',
                    workoutText: 'Back',
                    exerciseData: exerciseData, // Add this line
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NewWorkout(
                    imagePath: 'assets/icons/dumbell.png',
                    workoutText: 'Chest',
                    exerciseData: exerciseData, // Add this line
                  ),
                  SizedBox(width: 15),
                  NewWorkout(
                    imagePath: 'assets/icons/dumbell.png',
                    workoutText: 'Arms',
                    exerciseData: exerciseData, // Add this line
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}