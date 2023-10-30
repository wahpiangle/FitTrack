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
  List selectedCategory = []; // Default to []
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
      // Populate the list with the selected category or body part by default
      filterExercises('', selectedCategory);
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

  void filterExercises(String query, List category) {
    setState(() {
      searchText = query;
      selectedCategory = category;
    });
  }

  void setSelectedBodyPart(String bodyPart) {
    setState(() {
      selectedBodyPart = bodyPart;
    });
  }

  void setSelectedCategory(List category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      appBar: TopNavBar(
        title: 'Exercise List',
        user: user,
      ),
      body: StreamBuilder(
        stream: streamExercises,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredData = snapshot.data!.where((exercise) {
            if (selectedBodyPart == '') {
              return true;
            } else {
              return exercise.bodyPart.target!.name == selectedBodyPart;
            }
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
                                  filterExercises(query, selectedCategory);
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Search Exercise',
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
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Show a single circular rectangle for the selected category
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.black),
                            color: const Color(0xFFE1F0CF),
                          ),
                          child: selectedBodyPart == ''
                              ? const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Text(
                                    'All',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                )
                              : TextButton.icon(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Color(0xFF333333),
                                    size: 20,
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  label: Text(
                                    selectedBodyPart,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    setSelectedBodyPart('');
                                  },
                                ),
                        ),
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
                              child: Text(
                                key,
                                style: const TextStyle(color: Colors.white),
                              ),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
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
    final exerciseCategory = exercise.category.target!.name;

    // Check if the exercise name or category contains the search text
    final containsSearchText =
        exerciseName.toLowerCase().contains(searchText.toLowerCase()) ||
            exerciseCategory.toLowerCase().contains(searchText.toLowerCase());
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
            leading: ClipRRect(
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
            title: Text(
              exercise.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              exerciseCategory,
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
