import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/workout/components/timer/timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/new_workout.dart';
import 'package:group_project/pages/workout/components/start_new_workout_bottom_sheet.dart';

import 'components/timer/custom_timer_provider.dart';
import 'components/timer/rest_timer_provider.dart';



class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});
  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late List<Exercise> exerciseData;
  bool isBottomSheetVisible = false;
  bool isTimerActiveScreenOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    exerciseData = objectBox.getAllExercises();
  }



  Future<void> _startNewWorkout(BuildContext context) async {
    TimerProvider timerProvider = Provider.of<TimerProvider>(context, listen: false);
    RestTimerProvider restTimerProvider = Provider.of<RestTimerProvider>(context, listen: false);
    CustomTimerProvider customTimerProvider = Provider.of<CustomTimerProvider>(context, listen: false);

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

                  // Open the NewWorkoutBottomSheet
                  bool isBottomSheetClosed = await NewWorkoutBottomSheet.show(context, exerciseData);

                  if (isBottomSheetClosed) {
                    // Always check if the timer is active after the bottom sheet is closed
                    _handleTimerActive(context);
                  }
                },
                child: Text('Resume Workout'),
              ),
              TextButton(
                onPressed: () {
                  // Add code to handle stopping and resetting the workout
                  Navigator.of(ctx).pop(); // Close the dialog
                  // Call _resetWorkout
                  _resetWorkout();
                  // Show the NewWorkoutBottomSheet
                  NewWorkoutBottomSheet.show(context, exerciseData);
                },

                child: Text('Start a New Workout'),
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

    if (isBottomSheetClosed) {
      // Always check if the timer is active after the bottom sheet is closed
      _handleTimerActive(context);
    }

    if(restTimerProvider.isRestTimerRunning) {
      print('kk');
      _showTimerActiveScreen(context);
    }
    else{
      print('hh');
      _showCustomTimerActiveScreen(context);

    }

  }

  void _showTimerActiveScreen(BuildContext context) {
    RestTimerProvider restTimerProvider = Provider.of<RestTimerProvider>(context, listen: false);

    // Show the TimerActiveScreen
    showBottomSheet(
      context: context,
      builder: (context) => TimerActiveScreen(
        exerciseData: exerciseData,
        onRestTimerEnded: () {
          // Show the AlertDialog when the rest timer ends
          restTimerProvider.showRestTimeEndedNotification(context);
        },
      ),
    );
  }


  void _showCustomTimerActiveScreen(BuildContext context) {
    CustomTimerProvider customTimerProvider = Provider.of<CustomTimerProvider>(context, listen: false);

    // Show the TimerActiveScreen
    showBottomSheet(
      context: context,
      builder: (context) => TimerActiveScreen(
        exerciseData: exerciseData,
        onRestTimerEnded: () {
          // Show the AlertDialog when the rest timer ends
          customTimerProvider.showCustomTimeEndedNotification(context);

        },
      ),
    );
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider timerProvider = Provider.of<TimerProvider>(context, listen: false);

    // Check if TimerActiveScreen is already open
    if (isTimerActiveScreenOpen) {
      return;
    }

    // Listen for changes in the timer status
    timerProvider.addListener(() {
      if (timerProvider.isTimerRunning && !isTimerActiveScreenOpen) {
        // If the timer is active and TimerActiveScreen is not open, show TimerActiveScreen as a bottom sheet
        isTimerActiveScreenOpen = true;
        showBottomSheet(
          context: context,
          builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
        ).closed.then((value) {
          // Reset the flag when TimerActiveScreen is closed
          isTimerActiveScreenOpen = false;
        });
      }
    });

    // Check the timer status immediately after adding the listener
    if (timerProvider.isTimerRunning && !isTimerActiveScreenOpen) {
      // If the timer is active and TimerActiveScreen is not open, show TimerActiveScreen as a bottom sheet
      isTimerActiveScreenOpen = true;
      showBottomSheet(
        context: context,
        builder: (context) => TimerActiveScreen(exerciseData: exerciseData),
      ).closed.then((value) {
        // Reset the flag when TimerActiveScreen is closed
        isTimerActiveScreenOpen = false;
      });
    }
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
      key: _scaffoldKey,
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