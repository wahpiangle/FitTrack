import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/exercise_list.dart';
import 'package:group_project/pages/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/new_workout.dart';
import 'bottom_nav_bar.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

// nav bar
  int _selectedIndex = 2;
  final List<Widget Function()> pages = [
    () => const Home(),
    () => const HistoryScreen(),
    () => const ProfileScreen(),
    () =>  ExerciseListScreen(),
    () => const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < pages.length) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => pages[index]()));
    }
  }
// nav bar

  @override
  Widget build(BuildContext context) {
    //the user's information (name, email etc.) can be accessed from this variable
    final user = Provider.of<User?>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true, // center title horizontally
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Will lead to Search friends page
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user?.photoURL ?? 'assets/defaultimage.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1A1A1A),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  // Start an Empty Workout button
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFC1C1C1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.only(
                            top: 15, bottom: 15, left: 50, right: 50),
                      ),
                    ),
                    child: const Text(
                      "Start An Empty Workout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xFF333333),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Add new template",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Empower your journey with a new workout.",
                            style: TextStyle(
                              color: Color(0xFFC1C1C1),
                              fontSize: 13,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10), // Add some space between the two text widgets
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) =>),
                              // );
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(290, 40)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFE1F0CF)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      40), // Set the border radius to make it round
                                ),
                              ),
                            ),
                            child: const Text('Add New Template',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NewWorkout(
                          imagePath: 'assets/dumbell.png',
                          workoutText: 'Legs',
                        ),
                        NewWorkout(
                          imagePath: 'assets/dumbell.png',
                          workoutText: 'Back',
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NewWorkout(
                          imagePath: 'assets/dumbell.png',
                          workoutText: 'Chest',
                        ),
                        NewWorkout(
                          imagePath: 'assets/dumbell.png',
                          workoutText: 'Arms',
                        ),
                      ],
                    ),
                  ],
                )
              ] //Children widgets
                  ),
            ),
          ),
        ),
//Nav Bar
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ));
  }
}
