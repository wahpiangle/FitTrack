import 'package:flutter/material.dart';

class ExercisesListScreen extends StatefulWidget {
  const ExercisesListScreen({super.key});

  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Exercise List'),
      ),
    );
  }
}
