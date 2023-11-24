import 'package:flutter/material.dart';
import 'package:group_project/pages/exercise/exercise_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
          child: Text('History'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ExerciseListScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
