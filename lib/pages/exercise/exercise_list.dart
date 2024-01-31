import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/components/exercises_list_filters.dart';
import 'package:group_project/pages/exercise/components/filter_label.dart';
import 'package:group_project/pages/exercise/components/exercise_list_item.dart';
import 'package:group_project/pages/workout/State/timer_sheet_manager.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({Key? key}) : super(key: key);

  @override
  ExerciseListScreenState createState() => ExerciseListScreenState();
}

class ExerciseListScreenState extends State<ExerciseListScreen> {
  String searchText = '';
  List<String> selectedCategory = [];
  String selectedBodyPart = '';
  Map<String, List<Exercise>> exerciseGroups = {};
  Stream<List<Exercise>> streamExercises =
  objectBox.exerciseService.watchAllExercise();
  final categories = objectBox.exerciseService.getCategories();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterExercises('');
      _handleTimerActive(context);
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
      searchText = query;
    });
  }

  void setSelectedBodyPart(String bodyPart) {
    setState(() {
      selectedBodyPart = bodyPart;
    });
  }

  void addSelectedCategory(String category) {
    setState(() {
      selectedCategory.add(category);
    });
  }

  void removeSelectedCategory(String category) {
    setState(() {
      selectedCategory.remove(category);
    });
  }

  void toggleExerciseVisibility(Exercise exercise) {
    setState(() {
      exercise.isVisible = !exercise.isVisible;
      objectBox.exerciseService.updateExerciselist(exercise);
    });
  }

  void _handleTimerActive(BuildContext context) {
    TimerProvider? timerProvider =
    Provider.of<TimerProvider>(context, listen: false);

    void handleTimerStateChanged() {
      if (timerProvider.isTimerRunning &&
          !TimerManager().isTimerActiveScreenOpen) {
        TimerManager().showTimerBottomSheet(context, []);
      } else if (!timerProvider.isTimerRunning &&
          TimerManager().isTimerActiveScreenOpen) {
        TimerManager().closeTimerBottomSheet(context);
      }
    }

    void Function()? listener;
    listener = () {
      if (mounted) {
        handleTimerStateChanged();
      } else {
        timerProvider.removeListener(listener!);
      }
    };

    timerProvider.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: streamExercises,
        builder: (context, AsyncSnapshot<List<Exercise>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: const Color(0xFF1A1A1A),
              height: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final filteredData = snapshot.data!.where((exercise) {
            final exerciseBodyPart = exercise.bodyPart.target?.name ?? '';
            final exerciseCategory = exercise.category.target?.name ?? '';

            final isBodyPartMatch = selectedBodyPart.isEmpty ||
                exerciseBodyPart == selectedBodyPart;
            final isCategoryMatch = selectedCategory.isEmpty ||
                selectedCategory.contains(exerciseCategory);

            return isBodyPartMatch && isCategoryMatch;
          }).toList();

          final groupedExercise = groupExercises(filteredData);

          return Container(
            color: const Color(0xFF1A1A1A),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ExercisesListFilters(
                    filterExercises: filterExercises,
                    selectedBodyPart: selectedBodyPart,
                    setSelectedBodyPart: setSelectedBodyPart,
                    selectedCategory: selectedCategory,
                    addSelectedCategory: addSelectedCategory,
                    removeSelectedCategory: removeSelectedCategory,
                  ),
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
                              },
                            ),
                        if (selectedBodyPart.isNotEmpty)
                          FilterLabel(
                            text: selectedBodyPart,
                            isFilterSelected: true,
                            onTap: () {
                              setSelectedBodyPart('');
                            },
                          ),
                        for (final category in selectedCategory)
                          FilterLabel(
                            text: category,
                            isFilterSelected: true,
                            onTap: () {
                              removeSelectedCategory(category);
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
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: groupedExercise.length,
                      itemBuilder: (context, index) {
                        final exercises =
                        groupedExercise.values.elementAt(index);
                        final key = groupedExercise.keys.elementAt(index);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              child: searchText == ''
                                  ? Text(
                                key,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : Container(),
                            ),
                            for (final exercise in exercises)
                              if (exercise.isVisible)
                                Dismissible(
                                key: Key(exercise.id.toString()), // Unique key for each exercise
                                direction: DismissDirection.endToStart, // Swipe from right to left
                                background: Container(
                                color: Colors.red, // Red background when swiping
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                                child: Text(
                                'Hide',
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                ),
                                ),
                                ),
                                // Implement confirmDismiss to control when the item can be dismissed
                                confirmDismiss: (direction) async {
                                // Always allow dismissal
                                return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xFF1A1A1A), // Set background color to 1A1A1A
                                    title: Text(
                                      "Hide ${exercise.name}",
                                      style: TextStyle(color: Colors.white), // Set title color to white
                                    ),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min, // Set the main axis size to minimum
                                      children: [
                                        Text(
                                          "This exercise will no longer be accessible.",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // Set text color to white
                                          ),
                                        ),
                                        SizedBox(height: 8), // Add some space between the sentences
                                        Text(
                                          "Hiding it will not affect any of your previous workouts with this exercise.",
                                          style: TextStyle(color: Colors.white), // Set text color to white
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0), // Adjust content padding

                                    actions: [
                                      Container(
                                        width: double.infinity, // Take the full width of the dialog
                                        padding: EdgeInsets.symmetric(vertical: 1.0), // Add vertical padding
                                        decoration: BoxDecoration(
                                          color: Colors.red, // Red fill color
                                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                        ),
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true); // Dismiss the dialog and accept the dismissal
                                            },
                                            child: Text(
                                              "Hide",
                                              style: TextStyle(color: Colors.white), // White text color
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3), // Add some space between buttons and content
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black, // Black fill color
                                                border: Border.all(color: Colors.black), // Black border color
                                                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false); // Dismiss the dialog and reject the dismissal
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(color: Colors.white), // Set text color to white
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );



                                },
                                );
                                },
                                onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                // Toggle exercise visibility
                                toggleExerciseVisibility(exercise);
                                }
                                },
                        child: ExerciseListItem(
                        exercise: exercise,
                        searchText: searchText,
                        onToggleVisibility: () => toggleExerciseVisibility(exercise),
                        ),
                        ),


                        ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
