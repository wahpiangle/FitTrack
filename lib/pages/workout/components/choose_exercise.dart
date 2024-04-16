import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/components/exercises_list_filters.dart';
import 'package:group_project/pages/exercise/components/filter_label.dart';
import 'package:group_project/pages/workout/components/workout_exercise_list_item.dart';

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
            color: const Color(0xFF1A1A1A),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ExercisesListFilters(filterExercises: filterExercises, selectedBodyPart: selectedBodyPart, setSelectedBodyPart: setSelectedBodyPart, selectedCategory: selectedCategory, addSelectedCategory: addSelectedCategory, removeSelectedCategory: removeSelectedCategory),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (selectedBodyPart.isNotEmpty ||
                            selectedCategory.isNotEmpty)
                          if (selectedBodyPart.isEmpty &&
                              selectedCategory.isEmpty)
                            FilterLabel(
                              text: 'All',
                              isFilterSelected: true,
                              onTap: () {
                                setSelectedBodyPart('');
                                selectedCategory.clear();
                                filterExercises('');
                              },
                            ),
                        if (selectedBodyPart.isNotEmpty)
                          FilterLabel(
                            text: selectedBodyPart,
                            isFilterSelected: true,
                            onTap: () {
                              setSelectedBodyPart('');
                              filterExercises('');
                            },
                          ),
                        for (final category in selectedCategory)
                          FilterLabel(
                            text: category,
                            isFilterSelected: true,
                            onTap: () {
                              removeSelectedCategory(category);
                              filterExercises('');
                            },
                          ),
                        if (selectedBodyPart.isEmpty &&
                            selectedCategory.isEmpty)
                          FilterLabel(
                            text: 'All',
                            isFilterSelected: false,
                            onTap: () {
                              setSelectedBodyPart('');
                              selectedCategory.clear();
                              filterExercises('');
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        if (recentExercises.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text("Recent Exercises", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))),
                              Column(children: recentExercises.map((e) => WorkoutExerciseListItem(exercise: e, onSelectExercise: _selectExercise)).toList()),
                            ],
                          ),
                        ...groupedExercises.keys.map((firstLetter) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(firstLetter, style: const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold))),
                              Column(children: groupedExercises[firstLetter]!.map((e) => WorkoutExerciseListItem(exercise: e, onSelectExercise: _selectExercise)).toList()),
                            ],
                          );
                        }),
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
}