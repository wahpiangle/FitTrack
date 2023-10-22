import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:group_project/pages/NewWorkout.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //the user's information (name, emailm etc.) can be accessed from this variable
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

      body: Container(
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
                  width: 360,
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

              //Add a new template rectangle section
              Container(
                width: 350,
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
                        onPressed: () {},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(250, 40)),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
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

      ]
          ),
      ),
     ),
    );
  }
}
