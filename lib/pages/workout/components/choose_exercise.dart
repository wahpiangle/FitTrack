import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/components/crop_image.dart';
import 'package:group_project/pages/exercise/components/exercises_list_filters.dart';
import 'package:group_project/pages/exercise/components/filter_label.dart';

// Top-Level function
// Allows it to be called outside of this class
void deselectAllExercises(List<Exercise> exercises) {
  for (var exercise in exercises) {
    exercise.isSelected = false;
  }
}

class ChooseExercise extends StatefulWidget {
  final List<Exercise> exercises;
  final void Function(Exercise selectedExercise) selectExercise;

  const ChooseExercise({
    super.key,
    required this.exercises,
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
  Stream<List<Exercise>> streamExercises = objectBox.watchAllExercise();


  @override
  void initState() {
    super.initState();
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
      isAnyExerciseSelected = widget.exercises.any((exercise) => exercise.isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
            "Choose Exercises",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor:  AppColours.primary,
      ),
      body: StreamBuilder<List<Exercise>>(
          stream: streamExercises,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final exercises = filteredExercises;
            final filteredData = exercises.where((exercise) {
              final exerciseBodyPart = exercise.bodyPart.target!.name;
              final exerciseCategory = exercise.category.target!.name;

              final isBodyPartMatch = selectedBodyPart.isEmpty ||
                  exerciseBodyPart == selectedBodyPart;
              final isCategoryMatch = selectedCategory.isEmpty ||
                  selectedCategory.contains(exerciseCategory);

              return isBodyPartMatch && isCategoryMatch;
            }).toList();

          final groupedExercises = groupExercises(filteredData);

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
                        removeSelectedCategory: removeSelectedCategory
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
                    child: ListView.builder(
                      itemCount: groupedExercises.length,
                      itemBuilder: (context, index) {
                        final firstLetter = groupedExercises.keys.toList()[index];
                        final groupExercises = groupedExercises[firstLetter]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: groupExercises.length,
                              itemBuilder: (context, index) {
                                final exercise = groupExercises[index];
                                return Material(
                                  color: const Color(0xFF1A1A1A),
                                  child: InkWell(
                                    onTap: () {
                                      _selectExercise(exercise);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      child: ListTile(
                                        tileColor: exercise.isSelected ? Colors.grey[800] : null,
                                        horizontalTitleGap: -10,
                                        leading: Stack(
                                          children: [
                                            SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(300.0),
                                                child: exercise.imagePath == ''
                                                    ? Container(
                                                  decoration: BoxDecoration(
                                                    color: exercise.isSelected ? Colors.grey[800] : const Color(0xFFE1F0CF),
                                                    borderRadius: BorderRadius.circular(300.0),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      exercise.name[0].toUpperCase(),
                                                      style: TextStyle(
                                                        color: exercise.isSelected ? Colors.black : Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : ClipPath(
                                                  clipper: MyClipperPath(),
                                                  child: exercise.isSelected
                                                      ? Container() // Empty container when exercise is selected (image hidden)
                                                      : Container(
                                                    height: 60,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: Image.asset(exercise.imagePath).image,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (exercise.isSelected)
                                              Positioned(
                                                top: 12.5,
                                                right: 50,
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:  Colors.black26,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            exercise.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.5,
                                            ),
                                          ),
                                        ),
                                        subtitle: Text(
                                          exercise.bodyPart.target!.name,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ]
                ),
              ),
            );
         }
        ),
      floatingActionButton: isAnyExerciseSelected
          ? FloatingActionButton(
        onPressed: () {
          for (final exercise in widget.exercises) {
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
