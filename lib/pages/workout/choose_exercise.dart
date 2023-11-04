import 'package:flutter/material.dart';
import 'package:group_project/models/exercise.dart';

class ChooseExercise extends StatefulWidget {
  final List<Exercise> exercises;

  ChooseExercise({required this.exercises});

  @override
  _ChooseExerciseState createState() => _ChooseExerciseState();
}

class _ChooseExerciseState extends State<ChooseExercise> {
  List<Exercise> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = widget.exercises;
  }

  void filterExercises(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExercises = widget.exercises;
      } else {
        filteredExercises = widget.exercises
            .where((exercise) =>
            exercise.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // 1. Add the _selectExercise method
  void _selectExercise(Exercise selectedExercise) {
    Navigator.pop(context, selectedExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Choose an Exercise"),
        backgroundColor: Color(0xFF1A1A1A),
      ),
      body: Container(
        color: Color(0xFF1A1A1A),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: filterExercises,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for an exercise...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return GestureDetector( // 2. Wrap each exercise item with GestureDetector
                    onTap: () {
                      _selectExercise(exercise);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF333333),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 70,
                            child: Image.asset(
                              exercise.imagePath,
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Text(
                              exercise.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
