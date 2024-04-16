import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/components/exercises_list_filters.dart';
import 'package:group_project/pages/exercise/components/filter_label.dart';

// Top-Level function
// Allows it to be called outside of this class
void deselectAllExercises(List<Exercise> exercises) {
  for (var exercise in exercises) {
    objectBox.exerciseService.deselectExercise(exercise);
    exercise.isSelected = false;
  }
}

class ChooseExercise extends StatefulWidget {
  final void Function(Exercise selectedExercise) selectExercise;
  final List<Exercise> exercises = objectBox.exerciseService.getAllExercises();

  ChooseExercise({
    super.key,
    required this.selectExercise,
  });

  @override
  ChooseExerciseState createState() => ChooseExerciseState();
}

class ChooseExerciseState extends State<ChooseExercise> {
  List<Exercise> filteredExercises = [];
  bool isAnyExerciseSelected = false;
  List<String> selectedCategory = [];
  String selectedBodyPart = '';
  Stream<List<Exercise>> streamExercises =
  objectBox.exerciseService.watchAllExercise();
  List<Exercise> recentExercises = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    recentExercises = objectBox.exerciseService.getRecentExercises(10);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterExercises('');
    });
  }


  SplayTreeMap<String, List<Exercise>> groupExercises(exercises) {
    final groupedExercises = SplayTreeMap<String, List<Exercise>>();
    for (final exercise in exercises) {
      final firstLetter = exercise.name[0].toUpperCase();
      if (!groupedExercises.containsKey(firstLetter)) {
        groupedExercises[firstLetter] = [];
      }
      groupedExercises[firstLetter]!.add(exercise);
    }
    return groupedExercises;
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
      recentExercises = objectBox.exerciseService.getRecentExercises(10,
          category: selectedCategory.isEmpty ? null : selectedCategory.join(", "),
          bodyPart: selectedBodyPart.isEmpty ? null : selectedBodyPart);
    });
  }

  void setSelectedBodyPart(String bodyPart) {
    setState(() {
      selectedBodyPart = bodyPart;
      filterExercises(searchText);
    });
  }

  void addSelectedCategory(String category) {
    setState(() {
      selectedCategory.add(category);
      filterExercises(searchText);
    });
  }

  void removeSelectedCategory(String category) {
    setState(() {
      selectedCategory.remove(category);
      filterExercises(searchText);
    });
  }

  void submitSelectedExercise(Exercise selectedExercise) {
    if (selectedExercise.isSelected) {
      widget.selectExercise(selectedExercise);
    }
  }

  //change bool isSelected state
  void _selectExercise(Exercise selectedExercise) {
    setState(() {
      selectedExercise.isSelected = !selectedExercise.isSelected;
      checkSelectionStatus();
    });
  }

  //check if an exercise is selected
  void checkSelectionStatus() {
    setState(() {
      isAnyExerciseSelected = widget.exercises.any((exercise) => exercise.isSelected) ||
          recentExercises.any((exercise) => exercise.isSelected);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Choose Exercises",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColours.primary,
      ),
      body: StreamBuilder<List<Exercise>>(
        stream: streamExercises,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final exercises = filteredExercises;
          final filteredData = exercises.where((exercise) {
            final exerciseBodyPart = exercise.bodyPart.target?.name ?? '';
            final exerciseCategory = exercise.category.target?.name ?? '';
            return (selectedBodyPart.isEmpty || exerciseBodyPart == selectedBodyPart) &&
                (selectedCategory.isEmpty || selectedCategory.contains(exerciseCategory));
          }).toList();

          final groupedExercises = groupExercises(filteredData);

          return Container(
            color: Color(0xFF1A1A1A),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ExercisesListFilters(filterExercises: filterExercises, selectedBodyPart: selectedBodyPart, setSelectedBodyPart: setSelectedBodyPart, selectedCategory: selectedCategory, addSelectedCategory: addSelectedCategory, removeSelectedCategory: removeSelectedCategory),
                  Expanded(
                    child: ListView(
                      children: [
                        if (recentExercises.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text("Recent Exercises", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))),
                              Column(children: recentExercises.map((e) => exerciseTile(e)).toList()),
                            ],
                          ),
                        ...groupedExercises.keys.map((firstLetter) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text(firstLetter, style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))),
                              Column(children: groupedExercises[firstLetter]!.map((e) => exerciseTile(e)).toList()),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: isAnyExerciseSelected
          ? FloatingActionButton(
        onPressed: () {
          final allExercises = [...widget.exercises, ...recentExercises];
          for (final exercise in allExercises) {
            submitSelectedExercise(exercise);
          }
          Navigator.pop(context);
        },
        backgroundColor: AppColours.secondary,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget exerciseTile(Exercise exercise) {
    return InkWell(
      onTap: () => _selectExercise(exercise),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        color: exercise.isSelected ? Colors.grey[800] : null,
        child: ListTile(
          leading: SizedBox(
            width: 50.0,
            height: 50.0,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(300.0),
                  child: exercise.imagePath.isEmpty ? Container(
                    decoration: BoxDecoration(color: Color(0xFFE1F0CF), borderRadius: BorderRadius.circular(300.0)),
                    child: Center(
                      child: Text(exercise.name[0].toUpperCase(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24.0)),
                    ),
                  ) : Image.asset(exercise.imagePath, fit: BoxFit.cover),
                ),
                if (exercise.isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                  ),
              ],
            ),
          ),
          title: Text(exercise.name, style: TextStyle(color: Colors.white, fontSize: 16.5)),
          subtitle: Text("${exercise.bodyPart.target?.name ?? 'N/A'} (${exercise.category.target?.name ?? 'N/A'})", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ),
      ),
    );
  }

}