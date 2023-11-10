import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/components/bottom_nav_bar.dart';
import 'package:group_project/pages/components/crop_image.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';
import 'package:group_project/pages/exercise/exercise_filter_page.dart'; // Import ExerciseFilterPage
import 'package:provider/provider.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ExerciseListScreenState createState() => ExerciseListScreenState();
}

class ExerciseListScreenState extends State<ExerciseListScreen> {
  String searchText = '';
  List<String> selectedCategory = []; // Default to []
  String selectedBodyPart = '';
  final int _selectedIndex = 3;
  Map<String, List<Exercise>> exerciseGroups = {};
  late Stream<List<Exercise>> streamExercises;
  final categories = objectBox.getCategories();
  final GlobalKey _filterButtonKey = GlobalKey();
  Rect? filterButtonRect;

  @override
  void initState() {
    super.initState();
    streamExercises = objectBox.watchAllExercise();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox filterButton =
          _filterButtonKey.currentContext?.findRenderObject() as RenderBox;
      final Offset buttonPosition = filterButton.localToGlobal(Offset.zero);
      filterButtonRect = Rect.fromPoints(
        buttonPosition,
        buttonPosition.translate(
            filterButton.size.width, filterButton.size.height),
      );
      // Populate the list with 'All' exercises by default
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
    final user = Provider.of<User?>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: streamExercises,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(color: const Color(0xFF333333)),
                              color: const Color(0xFF333333),
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: const Color(0xFF333333)),
                              ),
                              child: TextField(
                                onChanged: (query) {
                                  filterExercises(query);
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Search exercise...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(color: const Color(0xFF333333)),
                              color: const Color(0xFF333333),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.filter_list,
                                  color: Colors.white, size: 24.0),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ExerciseFilterPage(
                                        selectedBodyPart: selectedBodyPart,
                                        setBodyPart: (bodyPart) =>
                                            setSelectedBodyPart(bodyPart),
                                        selectedCategory: selectedCategory,
                                        addCategory: (category) =>
                                            addSelectedCategory(category),
                                        removeCategory: (category) =>
                                            removeSelectedCategory(category),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (selectedBodyPart.isNotEmpty ||
                            selectedCategory.isNotEmpty)
                          if (selectedBodyPart.isEmpty &&
                              selectedCategory.isEmpty)
                            filterLabel('All', true, () {
                              setSelectedBodyPart('');
                              selectedCategory.clear();
                            }),
                        if (selectedBodyPart.isNotEmpty)
                          filterLabel(selectedBodyPart, true, () {
                            setSelectedBodyPart('');
                          }),
                        for (final category in selectedCategory)
                          filterLabel(category, true, () {
                            removeSelectedCategory(category);
                          }),
                        if (selectedBodyPart.isEmpty &&
                            selectedCategory.isEmpty)
                          filterLabel('All', false, () {
                            setSelectedBodyPart('');
                            selectedCategory.clear();
                          }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
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
      // Return an empty container if the exercise doesn't match the search
      return Container();
    }
  }
}

Widget filterLabel(
  String text,
  bool isFilterSelected,
  Function() onTap,
) {
  if (isFilterSelected) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: SizedBox(
        height: 35,
        child: TextButton.icon(
          icon: const Icon(
            Icons.close,
            color: Color(0xFF333333),
            size: 20,
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: const Color(0xFFE1F0CF),
          ),
          label: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          onPressed: () {
            onTap();
          },
        ),
      ),
    );
  }
  return FittedBox(
    fit: BoxFit.fitWidth,
    child: Container(
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color(0xFFE1F0CF),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}
