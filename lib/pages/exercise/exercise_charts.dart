import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import '../../constants/themes/exercise_list_theme.dart';
import 'exercise_navigation_buttons.dart';

class ExerciseCharts extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCharts(this.exercise, {super.key});

  @override
  State<ExerciseCharts> createState() => _ExerciseChartsState();
}

class _ExerciseChartsState extends State<ExerciseCharts> {
  int selectedPageIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ExerciseListThemes.appBarBackground,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Add edit functionality here
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 18,
                color: AppColours.secondary,
              ),
            ),
          )
        ],
        leading: IconButton(
          onPressed: () {},
          icon: IconButton(
            icon: const Icon(Icons.close_sharp, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Center(
          child: Text(
            widget.exercise.name,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    NavigationButtonsRow(
                      selectedPageIndex: selectedPageIndex,
                      exercise: widget.exercise,
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Charts',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
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
