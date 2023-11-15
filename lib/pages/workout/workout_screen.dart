import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/workout/start_new_workout.dart';
import 'package:group_project/pages/components/bottom_nav_bar.dart';
import 'package:group_project/pages/workout/new_workout.dart';
import 'package:group_project/models/exercise.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final int _selectedIndex = 2;
  late List<Exercise> exerciseData;

  @override
  void initState() {
    super.initState();
    exerciseData = objectBox.getAllExercises();
  }

  Future<void> _startNewWorkout(BuildContext context) async {
    objectBox.createWorkoutSession();

    await showModalBottomSheet(
      context: context,
      builder: (context) => StartNewWorkout(
        exerciseData: exerciseData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: TopNavBar(title: 'Home', user: user),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                        const EdgeInsets.symmetric(vertical: 15),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
