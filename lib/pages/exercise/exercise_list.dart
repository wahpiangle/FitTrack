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
          final exercises = snapshot.data!;
          final filteredExercises = exercises.where((exercise) {
            final exerciseBodyPart = exercise.bodyPart.target?.name ?? '';
            final exerciseCategory = exercise.category.target?.name ?? '';
            return (selectedBodyPart.isEmpty || exerciseBodyPart == selectedBodyPart) &&
                (selectedCategory.isEmpty || selectedCategory.contains(exerciseCategory));
          }).toList();
          final groupedExercise = groupExercises(filteredExercises);

          return SingleChildScrollView(
            child: Container(
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
                    _buildExerciseSection("Recent Exercises", recentExercises, false),
                    _buildExerciseSection(" ", groupedExercise.values.expand((x) => x).toList(), true),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseSection(String title, List<Exercise> exercises, bool showFilters) {
    if (exercises.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (showFilters) ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final category in selectedCategory)
                FilterLabel(
                  text: category,
                  isFilterSelected: true,
                  onTap: () => removeSelectedCategory(category),
                ),
              if (selectedBodyPart.isEmpty && selectedCategory.isEmpty)
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
        ],
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return Dismissible(
              key: Key(exercise.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  toggleExerciseVisibility(exercise);
                }
              },
              confirmDismiss: (direction) async {
                if (!exercise.isCustom) {
                  return false;
                }
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Hide ${exercise.name}", style: const TextStyle(color: Colors.white)),
                      content: const Text("This exercise will no longer be visible in the list. Are you sure?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text('Hide', style: TextStyle(color: Colors.red)),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                );
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(right: 20.0),
                alignment: Alignment.centerRight,
                child: const Text('Hide', style: TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
              child: ExerciseListItem(
                exercise: exercise,
                searchText: searchText,
                onToggleVisibility: () => toggleExerciseVisibility(exercise),
                isCustom: exercise.isCustom,
              ),
            );
          },
        ),
      ],
    );
  }
}