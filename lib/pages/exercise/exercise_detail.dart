import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/exercise_list_theme.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/components/bottom_nav_bar.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:provider/provider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen(this.exercise, {super.key});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
        backgroundColor: ExerciseListThemes.appBarBackground,
        appBar: TopNavBar(
            title: 'Exercise Detail', user: user, showBackButton: true),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: ExerciseListThemes.listItemBorderColor,
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 4, // Add some shadow for the card
                            child: Column(
                              children: [
                                Image.asset(widget.exercise.imagePath),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Exercise Name: ${widget.exercise.name}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: ExerciseListThemes.appBarBackground,
                  child: Column(
                    children: [
                      for (var letter = 'A';
                          letter.compareTo('Z') <= 0;
                          letter =
                              String.fromCharCode(letter.codeUnitAt(0) + 1))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
        ));
  }
}
