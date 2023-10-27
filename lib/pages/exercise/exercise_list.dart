import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/exercise.dart';
import 'package:group_project/pages/components/bottom_nav_bar.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:group_project/pages/exercise/exercise_detail.dart';
import 'package:provider/provider.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ExerciseListScreenState createState() => ExerciseListScreenState();
}

class ExerciseListScreenState extends State<ExerciseListScreen> {
  String searchText = '';
  String selectedCategory = 'All'; // Default to 'All'
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
      // groupExercises();
      // Populate the list with 'All' exercises by default
      filterExercises('', 'All');
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

  void filterExercises(String query, String category) {
    setState(() {
      searchText = query;
      selectedCategory = category;
    });
  }

  void showFilterMenu(BuildContext context) {
    if (filterButtonRect != null) {
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          filterButtonRect!.left + 70.0,
          filterButtonRect!.bottom + 70.0,
          filterButtonRect!.right,
          filterButtonRect!.bottom + 10.0,
        ),
        items: categories
            .map((category) => PopupMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                ))
            .toList(),
      ).then((value) {
        if (value != null) {
          filterExercises(searchText, value);
        }
      });
    }
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
          final groupedExercise = groupExercises(snapshot.data!);
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
                                  hintText: 'Search...',
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
                                showFilterMenu(context);
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
                          width: 80.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.black),
                            color: const Color(0xFFE1F0CF),
                          ),
                          child: Center(
                            child: Text(
                              selectedCategory,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                        final key = groupedExercise.keys.elementAt(index);
                        final exercises =
                            groupedExercise.values.elementAt(index);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                key,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            for (final exercise in exercises)
                              ExerciseListItem(exercise: exercise),
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

  const ExerciseListItem({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
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
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(300.0),
                child: exercise.imagePath == ''
                    ? Container(
                        width: 50,
                        height: 50,
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
                    : Image.asset(
                        exercise.imagePath,
                        width: 50,
                        height: 50,
                      )),
            title: Text(
              '${exercise.name} (${exercise.category.target!.name})',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              exercise.category.target!.name,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
      ),
    );
  }
}
