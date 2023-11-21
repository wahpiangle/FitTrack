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
        body: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Column(
                    children: [
                      Card(
                        child: Image.asset(widget.exercise.imagePath),
                      ),
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
       );
  }
}
