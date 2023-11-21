import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/components/crop_image.dart';
import 'package:group_project/pages/exercise/components/exercises_list_filters.dart';
import 'package:group_project/pages/exercise/components/filter_label.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ExerciseListScreenState createState() => ExerciseListScreenState();
}

class ExerciseListScreenState extends State<ExerciseListScreen> {
  String searchText = '';
  List<String> selectedCategory = []; // Default to []
  String selectedBodyPart = '';
  Map<String, List<Exercise>> exerciseGroups = {};
  Stream<List<Exercise>> streamExercises = objectBox.watchAllExercise();
  final categories = objectBox.getCategories();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: streamExercises,
        builder: (context, snapshot) {
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
            final exerciseBodyPart = exercise.bodyPart.target!.name;
            final exerciseCategory = exercise.category.target!.name;

            // Check if the exercise body part or category matches the selected body part or category
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
                                }),
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
                              margin: const EdgeInsets.symmetric(vertical: 5),
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
                              ExerciseListItem(
                                  exercise: exercise, searchText: searchText),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          objectBox.removeExercises();
          objectBox.addExercises();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final String searchText;

  const ExerciseListItem(
      {super.key, required this.exercise, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final exerciseName = exercise.name;
    final exerciseBodyPart = exercise.bodyPart.target!.name;

    // Check if the exercise name or category contains the search text
    final containsSearchText =
        exerciseName.toLowerCase().contains(searchText.toLowerCase());
    if (searchText.isEmpty || containsSearchText) {
      return Material(
        color: const Color(0xFF1A1A1A),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(exercise),
              ),
            );
          },
          child: ListTile(
            horizontalTitleGap: -10,
            leading: SizedBox(
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300.0),
                child: exercise.imagePath == ''
                    ? Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F0CF),
                          borderRadius: BorderRadius.circular(300.0),
                        ),
                        child: Center(
                          child: Text(
                            exercise.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      )
                    : ClipPath(
                        clipper: MyClipperPath(),
                        child: Container(
                          height: 60,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: Image.asset(exercise.imagePath).image,
                            fit: BoxFit.contain, //or whatever BoxFit you want
                          )),
                        ),
                      ),
              ),
            ),
            title: Text(
              exercise.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              exerciseBodyPart,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
