import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/exercises_screen.dart';
import 'package:group_project/pages/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/login_screen.dart';
import 'package:group_project/pages/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/new_workout.dart';
import 'bottom_nav_bar.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

// nav bar
  int _selectedIndex = 2;
  final List<Widget Function()> pages = [
        () => Home(),
        () => const HistoryScreen(),
        () => ProfileScreen(),
        () => const ExercisesListScreen(),
        () => const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < pages.length) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => pages[index]()));
    }
  }
// nav bar

  @override
  Widget build(BuildContext context) {
    //the user's information (name, email etc.) can be accessed from this variable
    final user = Provider.of<User?>(context, listen: false);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // center title horizontally
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Will lead to Search friends page
          },
        ),
      ),

      body:
      SingleChildScrollView(
        child: Container(
          color: Color(0xFF1A1A1A),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user?.photoURL != null)
                  ClipOval(
                    child: Image.network(
                      user?.photoURL ?? 'assets/defaultimage.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 15),
                Text(
                  user?.displayName ?? '',
                ),
                //const SizedBox(height: 32),
                //Start an Empty Widget
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  // Start an Empty Workout button
                  child: Container(
                    width: 340,
                    height: 60,
                    child: TextButton(
                      onPressed: (){},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xFFC1C1C1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Set the border radius to make it round
                            ),
                          ),
                        ),
                        child: Text(
                            "Start an empty workout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            fontSize: 18,
                          ),
                        ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //Add a new template rectangle section
                Container(
                  width: 340,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Color(0xFF333333),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Add new Template",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:10),
                        Text(
                          "Empower your journey with a new workout.",
                          style: TextStyle(
                            color: Color(0xFFC1C1C1),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 10), // Add some space between the two text widgets
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) =>),
                            // );
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(295, 41)),
                            backgroundColor: MaterialStateProperty.all(Color(0xFFE1F0CF)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40), // Set the border radius to make it round
                              ),
                            ),
                          ),
                          child: Text(
                              'Add New Template',
                            style: TextStyle(
                              color: Colors.black,
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //End of Start a widget
                SizedBox(width:0, height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  child: Column(
                    children: [
                      Row(
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
                      Row(
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
                  ),
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
    )
    );

  }
}
