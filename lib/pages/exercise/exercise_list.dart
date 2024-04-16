import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/exercise/components/exercises_list_filters.dart';
import 'package:group_project/pages/exercise/components/filter_label.dart';
import 'package:group_project/pages/exercise/components/exercise_list_item.dart';
import 'package:group_project/pages/workout/State/timer_sheet_manager.dart';
import 'package:group_project/pages/workout/components/timer/providers/timer_provider.dart';
import 'package:group_project/services/firebase/firebase_customexercise_service.dart';
import 'package:provider/provider.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

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
  List<Exercise> recentExercises = [];


  @override
  void initState() {
    super.initState();
    recentExercises = objectBox.exerciseService.getRecentExercises(10);
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

  void toggleExerciseVisibility(Exercise exercise) {
    // Only allow hiding custom exercises
    if (exercise.isCustom == true) {
      setState(() {
        exercise.isVisible = !exercise.isVisible;
        objectBox.exerciseService.updateExerciselist(exercise);
        FirebaseExercisesService.setExerciseToNotVisible(exercise.id);
      });
    } else {
      // Handle non-custom exercise case, maybe show a message or take some other action
    }
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
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final filteredData = snapshot.data!.where((exercise) {
            final exerciseBodyPart = exercise.bodyPart.target?.name ?? '';
            final exerciseCategory = exercise.category.target?.name ?? '';
            return (selectedBodyPart.isEmpty || exerciseBodyPart == selectedBodyPart) &&
                (selectedCategory.isEmpty || selectedCategory.contains(exerciseCategory));
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
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: searchText.isEmpty
                              ? const Text(
                            "Recent",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ) : Container(),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = recentExercises[index];
                            return ExerciseListItem(
                              exercise: exercise,
                              searchText: searchText,
                              onToggleVisibility: () =>
                                  toggleExerciseVisibility(exercise),
                              isCustom: exercise.isCustom,
                            );
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: groupedExercise.length,
                          itemBuilder: (context, index) {
                            final exercises = groupedExercise.values.elementAt(
                                index);
                            final key = groupedExercise.keys.elementAt(index);

                            final visibleExercises = exercises
                                .where((exercise) => exercise.isVisible)
                                .toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: searchText.isEmpty
                                      ? Text(
                                    key,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : Container(),
                                ),
                                for (final exercise in visibleExercises)
                                  Dismissible(
                                    key: Key(exercise.id.toString()),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(
                                          right: 20.0),
                                      child: const Text(
                                        'Hide',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      if (!exercise.isCustom) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text("${exercise
                                                .name} can't be hidden"),
                                            duration: const Duration(
                                                seconds: 2),
                                          ),
                                        );
                                        return false;
                                      }
                                      if (exercise.isCustom) {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              surfaceTintColor: const Color(
                                                  0xFF1A1A1A),
                                              backgroundColor: const Color(
                                                  0xFF1A1A1A),
                                              title: Text(
                                                "Hide ${exercise.name}",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: const Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "This exercise will no longer be accessible.",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    "Hiding it will not affect any of your previous workouts with this exercise.",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                ],
                                              ),
                                              contentPadding: const EdgeInsets
                                                  .fromLTRB(
                                                  24.0, 20.0, 24.0, 0),
                                              actions: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 1.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                      child: const Text(
                                                        "Hide",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(10.0),
                                                        ),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, false);
                                                          },
                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        toggleExerciseVisibility(exercise);
                                      }
                                    },
                                    child: ExerciseListItem(
                                      exercise: exercise,
                                      searchText: searchText,
                                      onToggleVisibility: () =>
                                          toggleExerciseVisibility(exercise),
                                      isCustom: exercise.isCustom,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}