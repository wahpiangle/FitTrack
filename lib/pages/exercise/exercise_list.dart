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

  void groupExercises(exercises) {
    final groupedExercises = <String, List<Exercise>>{};
    for (final exercise in exercises) {
      final firstLetter = exercise.name[0].toUpperCase();
      if (!groupedExercises.containsKey(firstLetter)) {
        groupedExercises[firstLetter] = [];
      }
      groupedExercises[firstLetter]!.add(exercise);
    }
    exerciseGroups = groupedExercises;
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
        items: <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'All',
            child: Text('All'),
          ),
          PopupMenuItem<String>(
            value: 'Core',
            child: Text('Core'),
          ),
          PopupMenuItem<String>(
            value: 'Arms',
            child: Text('Arms'),
          ),
          PopupMenuItem<String>(
            value: 'Back',
            child: Text('Back'),
          ),
          PopupMenuItem<String>(
            value: 'Chest',
            child: Text('Chest'),
          ),
          PopupMenuItem<String>(
            value: 'Legs',
            child: Text('Legs'),
          ),
          PopupMenuItem<String>(
            value: 'Shoulders',
            child: Text('Shoulders'),
          ),
          PopupMenuItem<String>(
            value: 'Other',
            child: Text('Other'),
          ),
          PopupMenuItem<String>(
            value: 'Olympic',
            child: Text('Olympic'),
          ),
          PopupMenuItem<String>(
            value: 'Full Body',
            child: Text('Full Body'),
          ),
          PopupMenuItem<String>(
            value: 'Cardio',
            child: Text('Cardio'),
          ),
        ],
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
            return Container(
              color: const Color(0xFF1A1A1A),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                                border: Border.all(color: Color(0xFF333333)),
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
                  const SizedBox(height: 5.0),
                  SizedBox(
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Show a single circular rectangle for the selected category
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        // final alphabet = exerciseGroups.keys.elementAt(index);
                        // final groupExercises = exerciseGroups[alphabet] ?? [];
                        // return Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(
                        //         alphabet,
                        //         style: const TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 18.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //         Column(
                        //           children: groupExercises
                        //               .where((exercise) =>
                        //                   exercise.name
                        //                       .toLowerCase()
                        //                       .contains(searchText.toLowerCase()) &&
                        //                   (selectedCategory == 'All' ||
                        //                       exercise.category == selectedCategory))
                        //               .map((exercise) =>
                        //                   ExerciseListItem(exercise: exercise))
                        //               .toList(),
                        //         ),
                        //   ],
                        // );
                        return ListTile(
                          title: Text(snapshot.data![index].name),
                          subtitle: Row(
                            children: <Widget>[
                              Image.asset(
                                snapshot.data![index].imagePath,
                                width: 50,
                                height: 50,
                              ),
                              Text(snapshot.data![index].bodyPart.target!.name),
                              const Text(' - '),
                              Text(snapshot.data![index].category.target!.name),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
        ));
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8.0),
        color: const Color(0xFF333333),
      ),
      child: ListTile(
        leading: Image.asset(exercise.imagePath, width: 50, height: 50),
        title: Text(
          exercise.name,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(exercise),
            ));
          },
          child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }
}
